// Package commands contains a set of CLI commands the application can be called with in order to perform some
// low-level administrative operations
package command

// A Command is an executable sub-command that gets a number of args passed from the commandline when running
type Command interface {
	// Run runs the command with the commandline flags passed as string array
	Run(args []string) error
}
