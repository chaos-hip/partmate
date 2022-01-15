interface JwtPayload {
    sub?: string;
    exp?: number;
    perm?: Array<string>;
}

/**
 * Quick and dirty implementation for decoding the contents of a JWT's payload body
 *
 * Since we don't need any validation on the client side and are only interested in the user information transported
 * in the JWT, this implementation ought to be enough.
 *
 * @param jwt The JWT in its string representation
 */
function decodeJWTPayload(jwt: string): JwtPayload {
    const parts = jwt.split('.');
    if (parts.length > 1) {
        return JSON.parse(atob(parts[1])) as JwtPayload;
    }
    return {} as JwtPayload;
}

export enum Permission {
    // LinkCreate allows the creation of new links for entities
    LinkCreate = "link:create",
    // LinkDelete allows the deletion of existing links
    LinkDelete = "link:delete",
    // LinkRead allows to see the list of links for an entity
    LinkRead = "link:read",

    //-- Parts ---------------------------------------------------------------------------------------------------------

    // PartAttachmentCreate allows to upload new attachments to a part
    PartAttachmentCreate = "part.attachment:create",
    // PartAttachmentRead allows to see and download the attachments of a part
    PartAttachmentRead = "part.attachment:read",
    // PartStockManage allows adding and removing stock for parts
    PartStockManage = "part.stock:manage",

    //-- Reporting -----------------------------------------------------------------------------------------------------

    // ReportStorageContents allows viewing the storage contents report
    ReportStorageContents = "report.storageContents:view",

    // ReportVenueSummary allows viewing the venue summary report
    ReportVenueSummary = "report.venueSummary:view",

    //-- Users ---------------------------------------------------------------------------------------------------------

    // UserCreate allows the creation of new users
    UserCreate = "user:create",
    // GrantPermissions allows granting permissions to other users
    UserGrantPermissions = "user.permission:grant",
    // UserPasswordSet allows updating ones own password (disabled for guests)
    UserPasswordSet = "user.password:set",
    // UserPasswordAdmin allows administrating the passwords for all users
    UserPasswordAdmin = "user.password:admin",
    // UserLoginTokenAdmin allows administrating the login tokens to all users
    UserLoginTokenAdmin = "user.token:admin",
    // UserRead allows access to the user administration in general including the user list
    UserRead = "user:read",
    // UserDelete allows to delete users
    UserDelete = "user:delete",

    //-- Venues --------------------------------------------------------------------------------------------------------

    // VenueCreate allows to create a new venue
    VenueCreate = "venue:create",

    // VenueFinish allows to mark a venue as finished
    VenueFinish = "venue:finish",

    // VenueRead allows to see the venues
    VenueRead = "venue:read",

    // VenueDelete allows to delete a venue
    VenueDelete = "venue:delete",

    //-- Venue items ---------------------------------------------------------------------------------------------------

    // VenueItemCheckout allows to check-out an item on a venue
    VenueItemCheckout = "venue.item:checkout",

    // VenueItemCheckin allows to check-in an item checked out of a venue
    VenueItemCheckin = "venue.item:checkin",

    // VenueItemInspected allows to set or remove the inspected flag on venue items
    VenueItemInspected = "venue.item:inspected",
}

export interface UserObj {
    name: string;
    permissions?: Array<string>;
}

export class User {
    name: string;
    expires: number;
    permissions: Map<string, boolean>;

    constructor(data: string | UserObj) {
        this.permissions = new Map<string, boolean>();
        if (typeof data == 'string') {
            const payload = decodeJWTPayload(data);
            this.name = payload.sub || '';
            this.expires = payload.exp || 0;
            if (payload.perm && Array.isArray(payload.perm)) {
                payload.perm.forEach(item => {
                    this.permissions.set(item, true);
                });
            }
        } else {
            this.expires = 0;
            this.name = data.name;
            if (data.permissions && Array.isArray(data.permissions)) {
                data.permissions.forEach(item => {
                    this.permissions.set(item, true);
                });
            }
        }
    }

    public get valid(): boolean {
        const dt = new Date();
        return dt.getTime() < (this.expires * 1000);
    }

    /**
     * Checks if the user has the given permission
     *
     * @param perm The permission to check for
     * @returns `true` if the user has the given permission, `false` if not
     */
    public can(perm: string): boolean {
        return this.permissions.has(perm);
    }

}
