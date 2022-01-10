// Package permission collects constants for the permissions available in PartMAtE
package permission

const (

	//-- Links ---------------------------------------------------------------------------------------------------------

	// LinkCreate allows the creation of new links for entities
	LinkCreate = "link:create"
	// LinkDelete allows the deletion of existing links
	LinkDelete = "link:delete"
	// LinkRead allows to see the list of links for an entity
	LinkRead = "link:read"

	//-- Parts ---------------------------------------------------------------------------------------------------------

	// PartAttachmentRead allows to see and download the attachments of a part
	PartAttachmentRead = "part.attachment:read"

	//-- Users ---------------------------------------------------------------------------------------------------------

	// UserCreate allows the creation of new users
	UserCreate = "user:create"
	// GrantPermissions allows granting permissions to other users
	UserGrantPermissions = "user.permission:grant"
	// UserPasswordSet allows updating ones own password (disabled for guests)
	UserPasswordSet = "user.password:set"
	// UserPasswordAdmin allows administrating the passwords for all users
	UserPasswordAdmin = "user.password:admin"
)

// Exists checks if a given permission exists as permission in the application
func Exists(perm string) bool {
	switch perm {
	case
		LinkCreate,
		LinkDelete,
		LinkRead,
		PartAttachmentRead,
		UserCreate,
		UserGrantPermissions,
		UserPasswordAdmin,
		UserPasswordSet:
		return true
	default:
		return false
	}
}

// AvailablePermissions returns a list of all permissions available in the application
func AvailablePermissions() []string {
	return []string{
		LinkCreate,
		LinkDelete,
		LinkRead,
		PartAttachmentRead,
		UserCreate,
		UserGrantPermissions,
		UserPasswordAdmin,
		UserPasswordSet,
	}
}
