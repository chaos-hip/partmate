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

	// PartAttachmentCreate allows to upload new attachments to a part
	PartAttachmentCreate = "part.attachment:create"
	// PartAttachmentRead allows to see and download the attachments of a part
	PartAttachmentRead = "part.attachment:read"
	// PartStockManage allows adding and removing stock for parts
	PartStockManage = "part.stock:manage"

	//-- Reporting -----------------------------------------------------------------------------------------------------

	// ReportStorageContents allows viewing the storage contents report
	ReportStorageContents = "report.storageContents:view"

	// ReportVenueSummary allows viewing the venue summary report
	ReportVenueSummary = "report.venueSummary:view"

	//-- Users ---------------------------------------------------------------------------------------------------------

	// UserCreate allows the creation of new users
	UserCreate = "user:create"
	// GrantPermissions allows granting permissions to other users
	UserGrantPermissions = "user.permission:grant"
	// UserPasswordSet allows updating ones own password (disabled for guests)
	UserPasswordSet = "user.password:set"
	// UserPasswordAdmin allows administrating the passwords for all users
	UserPasswordAdmin = "user.password:admin"
	// UserLoginTokenAdmin allows administrating the login tokens to all users
	UserLoginTokenAdmin = "user.token:admin"
	// UserRead allows access to the user administration in general including the user list
	UserRead = "user:read"
	// UserDelete allows to delete users
	UserDelete = "user:delete"

	//-- Venues --------------------------------------------------------------------------------------------------------

	// VenueCreate allows to create a new venue
	VenueCreate = "venue:create"

	// VenueFinish allows to mark a venue as finished
	VenueFinish = "venue:finish"

	// VenueRead allows to see the venues
	VenueRead = "venue:read"

	// VenueDelete allows to delete a venue
	VenueDelete = "venue:delete"

	//-- Venue items ---------------------------------------------------------------------------------------------------

	// VenueItemCheckout allows to check-out an item on a venue
	VenueItemCheckout = "venue.item:checkout"

	// VenueItemCheckin allows to check-in an item checked out of a venue
	VenueItemCheckin = "venue.item:checkin"

	// VenueItemInspected allows to set or remove the inspected flag on venue items
	VenueItemInspected = "venue.item:inspected"
)

// Exists checks if a given permission exists as permission in the application
func Exists(perm string) bool {
	switch perm {
	case
		LinkCreate,
		LinkDelete,
		LinkRead,
		PartAttachmentCreate,
		PartAttachmentRead,
		PartStockManage,
		ReportStorageContents,
		ReportVenueSummary,
		UserRead,
		UserDelete,
		UserCreate,
		UserGrantPermissions,
		UserPasswordAdmin,
		UserLoginTokenAdmin,
		UserPasswordSet,
		VenueCreate,
		VenueDelete,
		VenueFinish,
		VenueRead,
		VenueItemCheckin,
		VenueItemCheckout,
		VenueItemInspected:
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
		PartAttachmentCreate,
		PartAttachmentRead,
		PartStockManage,
		ReportStorageContents,
		ReportVenueSummary,
		UserRead,
		UserDelete,
		UserCreate,
		UserGrantPermissions,
		UserPasswordAdmin,
		UserLoginTokenAdmin,
		UserPasswordSet,
		VenueCreate,
		VenueDelete,
		VenueFinish,
		VenueRead,
		VenueItemCheckin,
		VenueItemCheckout,
		VenueItemInspected,
	}
}
