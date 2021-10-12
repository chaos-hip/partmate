interface JwtPayload {
    sub?: string;
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
    #name: string;

    constructor(jwt: string) {
        const payload = decodeJWTPayload(jwt);
        this.#name = payload.sub || '';
    }

    public get name() {
        return this.#name;
    }
}
