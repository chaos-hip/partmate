package main

import (
	"crypto/rand"
	"crypto/rsa"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"git.chaos-hip.de/RepairCafe/PartMATE/auth"
	"git.chaos-hip.de/RepairCafe/PartMATE/command"
	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/db/mysql"
	"git.chaos-hip.de/RepairCafe/PartMATE/routes"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
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
	router.Static("/ui", "public")

	apiRouter := router.Group("/api")
	{
		apiRouter.Use(auth.MakeAuthMiddleware(dbInstance, &privateKey.PublicKey))

		// Users
		apiRouter.POST("/user", routes.MakeUserCreateHandler(dbInstance))
		// Part handling
		apiRouter.GET("/parts/:id", handleTeaPottJeeey)
		apiRouter.GET("/parts/:id/qr", handleTeaPottJeeey)
		apiRouter.POST("/parts/search", routes.MakePartsSearchHandler(dbInstance))
		apiRouter.POST("/parts/:id/attachments", handleTeaPottJeeey) // manage Attachments of Parts
		// Link handling
		apiRouter.POST("/links", routes.MakeLinkCreateHandler(dbInstance))       // create Link
		apiRouter.DELETE("/links/:id", routes.MakeLinkDeleteHandler(dbInstance)) // delete Link
		apiRouter.POST("/parts/:id/link/:linkID", routes.MakeLinkCreateByPathHandler(dbInstance))
		// Inc or Dec Stock count
		apiRouter.POST("/parts/:id/stockadd", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/stockremove", handleTeaPottJeeey)
		// Lists
		apiRouter.GET("/categories", handleTeaPottJeeey)        // Get a list of all categories
		apiRouter.GET("/manufacturers", handleTeaPottJeeey)     // Get a list of manufacturers
		apiRouter.GET("/distributors", handleTeaPottJeeey)      // Get list of distributors
		apiRouter.GET("/storage-locations", handleTeaPottJeeey) // Get list of available storage locations
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
