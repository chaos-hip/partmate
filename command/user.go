package command

import (
	"flag"
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"

	"github.com/chaos-hip/partmate/db"
	"github.com/chaos-hip/partmate/models"
	"github.com/logrusorgru/aurora/v3"
	"golang.org/x/term"
)

var (
	userRegex = regexp.MustCompile(`^[a-z0-9_\-\.]+$`)
)

type User struct {
	fs *flag.FlagSet
	db db.DB
}

// NewUser creates a new user command to manage users with
func NewUser(dbInstance db.DB) *User {
	return &User{
		fs: flag.NewFlagSet("user", flag.ExitOnError),
		db: dbInstance,
	}
}

// Run implements the Command interface
func (u *User) Run(args []string) error {
	if len(args) == 0 {
		return fmt.Errorf("no action specified")
	}
	switch args[0] {
	case "add":
		return u.add(args[1:])
	case "pass":
		return u.setPassword(args[1:])
	case "rm":
		return u.delete(args[1:])
	default:
		return fmt.Errorf("unknown command %#v", args[0])
	}
}

func (u *User) add(args []string) error {
	fmt.Println(aurora.Green("-- "), "Creating a new user", aurora.Green(" -------------"))
	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		return err
	}
	defer term.Restore(int(os.Stdin.Fd()), oldState)
	t := term.NewTerminal(os.Stdin, "")
	username := ""
	for {
		fmt.Print(aurora.Blue("Username: "))
		tmp, err := t.ReadLine()
		if err != nil {
			if err == io.EOF {
				return nil
			}
			return fmt.Errorf("failed to read user name: %w", err)
		}
		username = strings.TrimSpace(strings.ToLower(tmp))
		if userRegex.MatchString(username) {
			// Check if the user does already exist
			u, err := u.db.GetUserByName(username)
			if err != nil {
				return fmt.Errorf("failed to read user information")
			}
			if u == nil {
				break
			}
			fmt.Printf(
				"%s%s%s\n\r",
				aurora.BrightRed("The user "),
				aurora.BrightBlue(username),
				aurora.BrightRed(" does already exist\r"),
			)
		} else {
			fmt.Println(aurora.BrightRed("Illegal username. Use only characters, numbers, underscores, hyphens and dots"))
		}
	}
	password := ""
	for {
		fmt.Print(aurora.Blue("Password: "))
		password, err = t.ReadPassword("")
		if err != nil {
			if err == io.EOF {
				return nil
			}
			return fmt.Errorf("failed to read password: %w", err)
		}
		password = strings.TrimSpace(password)
		if password == "" {
			fmt.Println(aurora.BrightRed("Please enter a non-empty password\r"))
		} else {
			fmt.Print(aurora.Blue("Confirm password: "))
			confirm, err := t.ReadPassword("")
			if err != nil {
				if err == io.EOF {
					return nil
				}
				return fmt.Errorf("failed to read password confirmation: %w", err)
			}
			confirm = strings.TrimSpace(confirm)
			if confirm == password {
				// All fine
				break
			}
			fmt.Println(aurora.BrightRed("Password and confirmation do not match. \n\rPlease try again\r"))
		}
	}
	// All collected. Let's create that user
	newUser := models.UserDTO{
		Username: username,
		Password: password,
	}
	userModel, err := newUser.ToUser()
	if err != nil {
		return fmt.Errorf("failed to create user model: %w", err)
	}
	if err := u.db.CreateUser(*userModel); err != nil {
		return fmt.Errorf("cannot create new user: %w", err)
	}
	fmt.Println(aurora.BrightGreen("User created successfully\r"))
	return nil
}

func (u *User) setPassword(args []string) error {
	fmt.Println(aurora.BrightRed("Not implemented right now"))
	return nil
}

func (u *User) delete(args []string) error {
	fmt.Println(aurora.BrightRed("Not implemented right now"))
	return nil
}
