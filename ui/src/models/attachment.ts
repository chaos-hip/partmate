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

    getDownloadLink(): string {
        return `/api/attachments/${this.id}`;
    }
}
