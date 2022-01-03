export interface StorageCategoryObj {
    name?: string;
    description?: string;
    path?: string;
}
export interface StorageObj {
    id?: string;
    name?: string;
    image?: string;
    category?: StorageCategoryObj;
}

export class StorageLocationCategory {
    name = "";
    description = "";
    path = "";

    constructor(obj?: StorageCategoryObj) {
        if (obj) {
            Object.assign(this, obj);
        }
    }

    get fullPath(): string {
        return [this.path, this.name].join(this.path == '/' ? '' : '/').substring(1);
    }
}

export class StorageLocation {
    id = "";
    name = "";
    image = "";
    category = new StorageLocationCategory();

    constructor(obj?: StorageObj) {
        if (obj) {
            Object.assign(this, obj);
            if (obj.category) {
                this.category = new StorageLocationCategory(obj.category);
            }
        }
    }

    getThumbnailPath() {
        return '/assets/img/noThumb.png';
        // return this.image ? `/api/attachments/${this.image}/thumb` : '/assets/img/noThumb.png';
    }
}
