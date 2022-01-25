export interface PartAttachmentObj {
    id: string;
    name: string;
    description: string;
    mimeType: string;
    fileSize: number;
}

/**
 * Represents an attachment added for a part
 */
export class PartAttachment {

    id = "";
    name = "";
    description = "";
    mimeType = "";
    fileSize = "";

    constructor(obj?: PartAttachmentObj) {
        if (obj) {
            Object.assign(this, obj);
        }
    }

    get isImage(): boolean {
        switch (this.mimeType) {
            case "image/png":
            case "image/jpeg":
            case "image/gif":
                return true
        }
        return false;
    }

    getDownloadLink(): string {
        return `/api/attachments/${this.id}`;
    }

    getThumbnailPath(): string {
        return `/api/attachments/${this.id}/thumb`;
    }
}
