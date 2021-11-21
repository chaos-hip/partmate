export interface StorageObj {
    id?: string;
    name?: string;
}

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
}

export class StorageLocation {
    id = "";
    name = "";

    constructor(obj?: StorageObj) {
        if (obj) {
            Object.assign(this, obj);
        }
    }
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

    constructor(obj?: PartObj) {
        if (obj) {
            Object.assign(this, obj);
            if (obj.storage) {
                this.storage = new StorageLocation(obj.storage);
            }
        }
    }

    getThumbnailPath(): string {
        return this.image ? `/api/attachments/${this.image}/thumb` : '/assets/img/noThumb.png';
    }
}
