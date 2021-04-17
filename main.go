package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
)

/*
	Which libs do we want to use?
	=> https://github.com/avelino/awesome-go

	- HTTP Server => Go-Kit || Gin✅ || Echo || Gorilla
	- Auth & Permissions =>
	- DB-Access => sql || sqlx✅ || gorm
	- DB-Migration =>
	- Config => viper✅
	- Logging => log || logrus✅ || zap
*/

func main() {
	// -- Predefinition --
	conf := viper.New()
	conf.Get("hello.world")
	logrus.Info("Hello again")

	x := sqlx.AT
	logrus.Info(x)
	fmt.Println("Hello PartMATE")
	// -- Live --
	router := gin.Default()
	router.GET("/i/:id", handleQrShortLink)
	router.GET("/t-stuff", handleTeaPottJeeey)
	router.GET("/attachments/:id/:format", handleTeaPottJeeey) // download attachment

	apiRouter := router.Group("/api")
	{
		apiRouter.POST("/login", handleTeaPottJeeey)
		apiRouter.POST("/logout", handleTeaPottJeeey)
		// Part handling
		apiRouter.GET("/parts/:id", handleTeaPottJeeey)
		apiRouter.GET("/parts/:id/qr", handleTeaPottJeeey)
		apiRouter.POST("/parts/search", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/attachments", handleTeaPottJeeey) // manage Attachements of Parts
		// Link handling
		apiRouter.POST("/links", handleTeaPottJeeey) // create Link
		apiRouter.DELETE("/links/:id", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/link", handleTeaPottJeeey)
		apiRouter.DELETE("/parts/:id/link/:linkID", handleTeaPottJeeey)
		// Inc or Dec Stock count
		apiRouter.POST("/parts/:id/stockadd", handleTeaPottJeeey)
		apiRouter.POST("/parts/:id/stockremove", handleTeaPottJeeey)
	}
	router.Run()
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
