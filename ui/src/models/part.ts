import { StorageObj, StorageLocation } from "./storage";

export interface PartObj {
    id?: string;
    name?: string;
    description?: string;
    comment?: string;
    condition?: string;
    stockLevel?: number;
    minStockLevel?: number;
    status?: string;
    needsReview?: boolean;
    lowStock?: boolean;
    image?: string;
    storage?: StorageObj;
    attachmentCount?: number;
}

export class Part {

    id = "";
    name = "";
    description = "";
    comment = "";
    condition = "";
    stockLevel = 0;
    minStockLevel = 0;
    status = "";
    needsReview = false;
    lowStock = false;
    image = "";
    storage = new StorageLocation();
    attachmentCount = 0;

    constructor(obj?: PartObj) {
        if (obj) {
            Object.assign(this, obj);
            if (obj.storage) {
                this.storage = new StorageLocation(obj.storage);
            }
        }
    }

    getBase(): string {
        const base = document.querySelector('base');
        return base ? base.href : '';
    }

    getThumbnailPath(): string {
        return this.image ? `/api/attachments/${this.image}/thumb` : `${this.getBase()}assets/img/noThumb.png`;
    }
}
