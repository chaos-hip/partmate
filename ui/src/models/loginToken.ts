export interface LoginTokenObj {
    token: string;
    expiresAt?: number;
    sessionLength: number;
}

export class LoginToken {
    token = "";
    expires: Date | null = null;
    sessionLength = 0;

    constructor(data?: LoginTokenObj) {
        if (data) {
            Object.assign(this, data);
            if (data.expiresAt) {
                this.expires = new Date(Number(data.expiresAt))
            }
        }
    }
}
