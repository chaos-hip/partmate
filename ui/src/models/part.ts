interface PartObj {
    id?: string;
    name?: string;
    description?: string;
    comment?: string;
    categoryId?: number;
    condition?: string;
    stockLevel?: number;
    minStockLevel?: number;
    status?: string;
    needsReview?: boolean;
    lowStock?: boolean;
}

export class Part {

    id = "";
    name = "";
    description = "";
    comment = "";
    categoryId = 0;
    condition = "";
    stockLevel = 0;
    minStockLevel = 0;
    status = "";
    needsReview = false;
    lowStock = false;

    constructor(obj: PartObj | undefined) {
        if (obj) {
            Object.assign(this, obj);
        }
    }
}
