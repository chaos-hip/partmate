interface JwtPayload {
    sub?: string;
    exp?: number;
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

export class User {
    name: string;
    expires: number;

    constructor(jwt: string) {
        const payload = decodeJWTPayload(jwt);
        this.name = payload.sub || '';
        this.expires = payload.exp || 0;
        console.dir(this);
    }

    public get valid(): boolean {
        const dt = new Date();
        return dt.getTime() < (this.expires * 1000);
    }

}
