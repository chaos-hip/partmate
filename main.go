package main

import (
	"net/http"
	"path/filepath"
	"strings"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

const (
	envVarPrefix = "PARTMATE"
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
*/

func main() {
	conf, err := initConfig()
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize configuration")
	}

	_, err = initLogger(conf)
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize logger")
	}

	_, err = initDB()
	if err != nil {
		logrus.WithError(err).Fatal("Failed to initialize database connection")
	}

	router := initRouting()
	router.Run(conf.GetString("listen"))
}

func initLogger(conf *viper.Viper) (logrus.StdLogger, error) {
	return nil, nil
}

func initRouting() *gin.Engine {
	router := gin.Default()

	apiRouter := router.Group("/api")
	{
		apiRouter.POST("/login", handleTeaPottJeeey)
		apiRouter.POST("/logout", handleTeaPottJeeey)
		// Part handling
		apiRouter.GET("/parts/:id", handleTeaPottJeeey)
		apiRouter.GET("/parts/:id/qr", handleTeaPottJeeey)
		apiRouter.POST("/parts/search", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/attachments", handleTeaPottJeeey) // manage Attachments of Parts
		// Link handling
		apiRouter.POST("/links", handleTeaPottJeeey) // create Link
		apiRouter.DELETE("/links/:id", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/link/:linkID", handleTeaPottJeeey)
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
	conf.SetDefault("log.level", "warn")
	conf.SetDefault("db.host", "mariadb")
	conf.SetDefault("db.user", "partmate")
	conf.SetDefault("db.password", "change_me")
	conf.SetDefault("db.database", "partkeepr")
	conf.SetDefault("partkeepr.data-dir", filepath.Join(".", "data"))

	if err := conf.ReadInConfig(); err != nil {
		if strings.Contains(err.Error(), "Config File \"config\" Not Found in") {
			logrus.Warn("No configuration file found. Hope you have everything configured with EnvVars...")
		} else {
			return nil, err
		}
	}
	return conf, nil
}

func initDB() (*sqlx.DB, error) {
	return nil, nil
}

func handleQrShortLink(ctx *gin.Context) {
	id := ctx.Param("id")
	ctx.JSON(http.StatusOK, gin.H{
		"id": id,
	})
}

func handleTeaPottJeeey(ctx *gin.Context) {
	ctx.JSON(http.StatusTeapot, gin.H{
		"error": "A nice warm Cup of green Tea (Kameldung)",
	})
}
