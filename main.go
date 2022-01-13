package main

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/auth"
	"git.chaos-hip.de/RepairCafe/PartMATE/command"
	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/db/mysql"
	"git.chaos-hip.de/RepairCafe/PartMATE/models/permission"
	"git.chaos-hip.de/RepairCafe/PartMATE/routes"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/golang-jwt/jwt/v4"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	ginlogrus "github.com/toorop/gin-logrus"
)

const (
	envVarPrefix = "PARTMATE"

	confKeyLogLevel      = "log.level"
	confKeyDBHost        = "db.host"
	confKeyDBPort        = "db.port"
	confKeyDBUser        = "db.user"
	confKeyDBPass        = "db.password"
	confKeyDBName        = "db.database"
	confKeyDataDir       = "partkeepr.data-dir"
	confKeyListen        = "listen"
	confKeyJWTPrivateKey = "jwt.key"
	confKeyJWTIssuer     = "jwt.issuer"
	confKeyJWTKeyLength  = "jwt.keylength"
	confKeyBaseURL       = "http.baseurl" // The base URL used for absolute paths or redirects
)

/*
	Which libs do we want to use?
	=> https://github.com/avelino/awesome-go

	- HTTP Server => Go-Kit || Gin✅ || Echo || Gorilla
	- Auth & Permissions =>
	- DB-Access => sql || sqlx✅ || gorm
	- DB-Migration => https://github.com/golang-migrate/migrate
	- Config => viper✅
	- Logging => log || logrus✅ || zap

	QR-Core link format:
	${baseURL}/l/${ID}

	e.g.
	https://i.repaircafe-hilpoltstein.de/l/fooBarBaz
*/

func main() {
	conf, err := initConfig()
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize configuration")
	}

	if err = initLogger(conf); err != nil {
		logrus.WithError(err).Fatal("Failed to initialize logger")
	}

	dbInstance, err := initDB(conf)
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize database connection")
	}

	if err := initDirectories(conf); err != nil {
		logrus.WithError(err).Fatal("Failed to initialize directory structure for local files")
	}

	if len(os.Args) > 1 {
		subcmd := os.Args[1]
		var cmd command.Command
		switch subcmd {
		case "qr":
			cmd = command.NewQR()
		case "user":
			cmd = command.NewUser(dbInstance)
		default:
			logrus.Errorf("Unknown command %#v", subcmd)
			os.Exit(1)
		}
		if err := cmd.Run(os.Args[2:]); err != nil {
			logrus.WithError(err).Errorf("Failed to execute command %#v", subcmd)
			os.Exit(1)
		} else {
			logrus.Infof("Finished executing command %#v", subcmd)
			os.Exit(0)
		}
	}

	// JWT keys
	jwtKeyStr := conf.GetString(confKeyJWTPrivateKey)
	var privateKey *rsa.PrivateKey
	if jwtKeyStr == "" {
		// Generate our private key
		logrus.Info("No private key configured - generating our own")
		privateKey, err = generateJWTKeypair(conf.GetInt(confKeyJWTKeyLength))
		if err != nil {
			logrus.WithError(err).Fatal("Failed to generate private key for JWT generation")
		}
	} else {
		// Load the external private key
		privateKey, err = jwt.ParseRSAPrivateKeyFromPEM([]byte(jwtKeyStr))
		if err != nil {
			logrus.WithError(err).Fatal("Failed to load private key for JWT generation")
		}
	}

	router := initRouting(dbInstance, privateKey, conf)
	router.Run(conf.GetString("listen"))
}

func initDirectories(conf *viper.Viper) error {
	baseDir := conf.GetString(confKeyDataDir)
	dirs := []string{
		filepath.Join(baseDir, "thumb", "PartAttachment"),
		filepath.Join(baseDir, "thumb", "storagelocation"),
	}
	for _, dir := range dirs {
		if err := os.MkdirAll(dir, 0777); err != nil {
			return fmt.Errorf("failed to create directory %#v: %w", dir, err)
		}
	}
	return nil
}

func initLogger(conf *viper.Viper) error {
	switch conf.GetString("log.level") {
	case "debug":
		logrus.Info("Setting log level to 'debug'")
		logrus.SetLevel(logrus.DebugLevel)
	case "info":
		logrus.Info("Setting log level to 'info'")
		logrus.SetLevel(logrus.InfoLevel)
	case "warn":
		logrus.Info("Setting log level to 'warn'")
		logrus.SetLevel(logrus.WarnLevel)
	case "error":
		logrus.Info("Setting log level to 'error'")
		logrus.SetLevel(logrus.ErrorLevel)
	default:
		logrus.Warnf("Illegal log level %#v - falling back to default level \"info\"")
		logrus.SetLevel(logrus.InfoLevel)
	}
	return nil
}

func initRouting(dbInstance db.DB, privateKey *rsa.PrivateKey, conf *viper.Viper) *gin.Engine {

	baseURL := conf.GetString(confKeyBaseURL)

	router := gin.Default()

	// Load templates
	router.LoadHTMLGlob("templates/*")

	router.Use(ginlogrus.Logger(logrus.StandardLogger()), gin.Recovery())
	// Respond with a proper JSON on 404
	router.NoRoute(routes.Default404Handler)

	// Unsecured API
	router.POST("/api/login", routes.MakeLoginHandler(dbInstance, privateKey, conf.GetString(confKeyJWTIssuer)))
	// No logout - the frontend will just delete its JWT

	// Redirect all requests to "/" to the UI
	router.GET("/", func(c *gin.Context) {
		c.Redirect(http.StatusTemporaryRedirect, "/ui/index.html")
	})

	// Static files
	router.Static("ui", "public")

	// Unsecured attachment downloads
	router.GET("/api/attachments/:id/thumb", routes.MakeGetThumbnailImageHandler(dbInstance)) // Get thumbnail for attachment
	router.GET("/api/attachments/:id", routes.MakePartAttachmentDownloadHandler(dbInstance))  // Download attachment

	// Unsecured link redirection
	router.GET("/l/:id", routes.MakeLinkRedirectHandler(dbInstance, baseURL)) // Redirect to the correct UI view based on the incoming link

	//-- Login via token ----------------------------------------------------------------------------------------------

	// Redirect to the correct UI view for logging in with a token
	router.GET("/t/:id", routes.MakeLoginTokenRedirector(baseURL))
	// Login via token
	router.POST(
		"/api/login/token/:id",
		routes.MakeTokenLoginHandler(dbInstance, privateKey, conf.GetString(confKeyJWTIssuer)),
	)

	// Secured API access
	apiRouter := router.Group("/api")
	{
		apiRouter.Use(auth.MakeAuthMiddleware(dbInstance, &privateKey.PublicKey))

		// List available permissions
		apiRouter.GET("/permissions", routes.MakeGetAvailablePermissions())

		//-- Users -----------------------------------------------------------------------------------------------------

		// Create a new user
		apiRouter.POST(
			"/user",
			auth.MakePermissionMiddleware(permission.UserCreate),
			routes.MakeUserCreateHandler(dbInstance),
		)

		// Set user permissions
		apiRouter.POST("/user/:name/permissions",
			auth.MakePermissionMiddleware(permission.UserGrantPermissions),
			routes.MakeUserSetPermissionsHandler(dbInstance),
		)

		// Create a new login token for an existing user
		apiRouter.POST("/user/:name/tokens",
			auth.MakePermissionMiddleware(permission.UserLoginTokenAdmin),
			routes.MakeCreateUserLoginTokenHandler(dbInstance),
		)

		// List existing tokens for an existing user
		apiRouter.GET("/user/:name/tokens",
			auth.MakePermissionMiddleware(permission.UserLoginTokenAdmin),
			routes.MakeListUserLoginTokensHandler(dbInstance),
		)

		// Delete login token by token ID (:name is ignored here)
		apiRouter.DELETE("/user/:name/tokens/:id",
			auth.MakePermissionMiddleware(permission.UserLoginTokenAdmin),
			routes.MakeDeleteUserLoginTokenHandler(dbInstance),
		)

		//-- Part handling ---------------------------------------------------------------------------------------------

		// Get details about a given part
		apiRouter.GET("/parts/:id", routes.MakeGetPartByLinkHandler(dbInstance))

		// Get the QR code for a part
		apiRouter.GET("/parts/:id/qr", handleTeaPottJeeey)

		// Search for parts
		apiRouter.POST("/parts/search", routes.MakePartsSearchHandler(dbInstance))

		// Add an attachment to a part
		apiRouter.POST("/parts/:id/attachments",
			auth.MakePermissionMiddleware(permission.PartAttachmentCreate),
			handleTeaPottJeeey,
		)

		// List attachments for a part
		apiRouter.GET("/parts/:id/attachments",
			auth.MakePermissionMiddleware(permission.PartAttachmentRead),
			routes.MakePartAttachmentListHandler(dbInstance),
		)

		//-- Stock management for parts --------------------------------------------------------------------------------

		stockMgr := apiRouter.Group("").Use(auth.MakePermissionMiddleware(permission.PartStockManage))

		// Increase the current stock of a part
		stockMgr.POST("/parts/:id/stockadd", handleTeaPottJeeey)

		// Decrease the current stock of a part
		stockMgr.POST("/parts/:id/stockremove", handleTeaPottJeeey)

		//-- Storage locations -----------------------------------------------------------------------------------------

		// Paginated search for storage locations
		apiRouter.POST("/storage/search", routes.MakeStorageSearchHandler(dbInstance))

		// Get details about a single storage location
		apiRouter.GET("/storage/:id", routes.MakeGetStorageByLinkHandler(dbInstance))

		// Get a paginated list of parts located in a storage location
		apiRouter.GET("/storage/:id/contents", routes.MakeGetPartsByStorageLocationLink(dbInstance))

		//-- Link handling ---------------------------------------------------------------------------------------------

		// List links for a part
		apiRouter.GET("/links/:id/links",
			auth.MakePermissionMiddleware(permission.LinkRead),
			routes.MakeLinkListHandler(dbInstance),
		)

		// Get infos about where a link points at
		apiRouter.GET("/links/:id",
			auth.MakePermissionMiddleware(permission.LinkRead),
			routes.MakeGetLinkInfoHandler(dbInstance),
		)

		// Create Link
		apiRouter.POST("/links",
			auth.MakePermissionMiddleware(permission.LinkCreate),
			routes.MakeLinkCreateHandler(dbInstance),
		)

		// Delete Link
		apiRouter.DELETE("/links/:id",
			auth.MakePermissionMiddleware(permission.LinkDelete),
			routes.MakeLinkDeleteHandler(dbInstance),
		)

		// Create link for a part
		apiRouter.POST("/parts/:id/links/:linkID",
			auth.MakePermissionMiddleware(permission.LinkCreate),
			routes.MakeLinkCreateByPathHandler(dbInstance),
		)

		//-- Venue management ------------------------------------------------------------------------------------------

		// List registered venues
		apiRouter.GET("/venues",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Start/Create a venue (or venue template)
		apiRouter.POST("/venues",
			auth.MakePermissionMiddleware(permission.VenueCreate),
			handleTeaPottJeeey,
		)

		// Get info about a venue
		apiRouter.GET("/venues/:id",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// End a venue
		apiRouter.POST("/venues/:id/finish",
			auth.MakePermissionMiddleware(permission.VenueFinish),
			handleTeaPottJeeey,
		)

		// Delete a venue
		apiRouter.DELETE("/venues/:id",
			auth.MakePermissionMiddleware(permission.VenueDelete),
			handleTeaPottJeeey,
		)

		//-- Managing items on a venue ---------------------------------------------------------------------------------

		// Get list of items taken to the venue
		apiRouter.GET("/venues/:id/items",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Get info about an item taken to the venue
		apiRouter.GET("/venues/:id/items/:id",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Check-out an item on a venue (lend to someone)
		apiRouter.POST("/venues/:id/items/:id/check-out",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Check-in an item on a venue (returned by someone)
		apiRouter.POST("/venues/:id/items/:id/check-in",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Mark an item as inspected (checked when the venue ends)
		apiRouter.POST("/venues/:id/items/:id/inspected",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		// Remove inspection marker from an item
		apiRouter.DELETE("/venues/:id/items/:id/inspected",
			auth.MakePermissionMiddleware(permission.VenueRead),
			handleTeaPottJeeey,
		)

		//-- Reporting / Printing --------------------------------------------------------------------------------------

		// Create a list with the contents of a storage location
		apiRouter.POST("/storage-locations/:id/reports/contents",
			auth.MakePermissionMiddleware(permission.ReportStorageContents),
			handleTeaPottJeeey,
		)

		// Summary about a venue
		apiRouter.POST("/venues/:id/reports/summary",
			auth.MakePermissionMiddleware(permission.ReportVenueSummary),
			handleTeaPottJeeey,
		)

		//-- Lists -----------------------------------------------------------------------------------------------------

		// Get a list of all categories
		apiRouter.GET("/categories",
			handleTeaPottJeeey,
		)
		// Get a list of manufacturers
		apiRouter.GET("/manufacturers",
			handleTeaPottJeeey,
		)
		// Get list of distributors
		apiRouter.GET("/distributors",
			handleTeaPottJeeey,
		)

	}
	return router
}

func initConfig() (*viper.Viper, error) {
	conf := viper.New()
	conf.AddConfigPath(".")
	conf.AddConfigPath(filepath.Join(".", "config"))
	conf.SetConfigName("config")
	conf.SetConfigType("toml")
	conf.SetEnvPrefix(envVarPrefix)
	conf.SetEnvKeyReplacer(strings.NewReplacer("-", "_", ".", "_", " ", "_", ":", "_"))
	logrus.Debugf("Configuration env var prefix set to '%s_'", envVarPrefix)
	conf.AutomaticEnv()

	// Prepare the defaults for the config
	conf.SetDefault(confKeyLogLevel, "warn")
	conf.SetDefault(confKeyDBHost, "mariadb")
	conf.SetDefault(confKeyDBPort, "3306")
	conf.SetDefault(confKeyDBUser, "partmate")
	conf.SetDefault(confKeyDBPass, "change_me")
	conf.SetDefault(confKeyDBName, "partkeepr")
	conf.SetDefault(confKeyListen, ":3000")
	conf.SetDefault(confKeyDataDir, filepath.Join(".", "data"))

	// JWT
	conf.SetDefault(confKeyJWTIssuer, "partmate")
	conf.SetDefault(confKeyJWTPrivateKey, "")
	conf.SetDefault(confKeyJWTKeyLength, 4096)

	if err := conf.ReadInConfig(); err != nil {
		if strings.Contains(err.Error(), "Config File \"config\" Not Found in") {
			logrus.Warn("No configuration file found. Hope you have everything configured with EnvVars...")
		} else {
			return nil, err
		}
	}
	return conf, nil
}

func initDB(conf *viper.Viper) (db.DB, error) {
	return mysql.NewDB(
		conf.GetString(confKeyDBHost),
		conf.GetString(confKeyDBPort),
		conf.GetString(confKeyDBUser),
		conf.GetString(confKeyDBPass),
		conf.GetString(confKeyDBName),
		"file://dbmigrations",
		conf.GetString(confKeyDataDir),
	)
}

func handleTeaPottJeeey(ctx *gin.Context) {
	ctx.JSON(http.StatusTeapot, gin.H{
		"error": "A nice warm Cup of green Tea (Kameldung)",
	})
}

// generateJWTKey creates a new keypair (public- and private keys) that can be used to sign JWTs after login
func generateJWTKeypair(keyLength int) (*rsa.PrivateKey, error) {
	logrus.Infof("Generating RSA private key for JWT signing with a length of %d", keyLength)
	return rsa.GenerateKey(rand.Reader, keyLength)
}
