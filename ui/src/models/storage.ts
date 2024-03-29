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
    partsContained?: number;
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
    partsContained = 0;

    constructor(obj?: StorageObj) {
        if (obj) {
            Object.assign(this, obj);
            if (obj.category) {
                this.category = new StorageLocationCategory(obj.category);
            }
        }
    }

    getBase(): string {
        const base = document.querySelector('base');
        return base ? base.href : '';
    }

    getThumbnailPath() {
        return `${this.getBase()}assets/img/noThumb.png`;
        // return this.image ? `/api/attachments/${this.image}/thumb` : '/assets/img/noThumb.png';
    }
}
