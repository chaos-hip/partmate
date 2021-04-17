package main

import (
	"fmt"

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
	conf := viper.New()
	conf.Get("hello.world")
	logrus.Info("Hello again")
	gin.Default()
	x := sqlx.AT
	logrus.Info(x)
	fmt.Println("Hello PartMATE")
}
