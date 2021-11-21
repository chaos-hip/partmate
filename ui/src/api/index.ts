import { Part, PartObj } from '@/models/part';
import store from '../store';

interface LoginResponse {
    token: string;
}

interface ApiErrorObj {
    type: string;
    error: string;
}

export class ApiError extends Error {

    #type: string;
    #response: Response;

    constructor(obj: ApiErrorObj, resp: Response) {
        super(obj.error);
        this.#type = obj.type || 'UNKNOWN';
        this.#response = resp;
    }

    public get type(): string {
        return this.#type;
    }

    public get response(): Response {
        return this.#response;
    }
}

async function makeApiError(res: Response): Promise<ApiError> {
    const obj = (await res.json()) as ApiErrorObj;
    return new ApiError(obj, res);
}

/**
 * Logs in the user with the given credentials.
 * Will throw an error if something goes wrong.
 *
 * If successful, the user instance will be reachable through the application's store
 *
 * @param username The user name to log in with
 * @param password The password to log in with
 */
export async function login(username: string, password: string) {
    const res = await fetch('/api/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            user: username,
            password: password,
        }),
    });
    if (res.status != 200) {
        const err = await makeApiError(res);
        throw err;
    }
    const data = (await res.json()) as LoginResponse;
    if (!data.token) {
        throw new Error("No token in server response");
    }
    store.commit('loggedIn', data.token);
}

interface SearchPayload {
    term?: string;
    offset: number;
    limit: number;
}

function prepareRequestHeaders(): HeadersInit {
    const out = new Headers({
        'Content-Type': 'application/json',
    });
    if (store.state.jwt) {
        out.set('Authorization', `Bearer ${store.state.jwt}`);
    }
    return out;
}

/**
 * Searches for parts matching a given search term
 *
 * @param term Search term
 * @returns A list of parts matching the search term
 */
export async function searchParts(term: string, offset: number, limit: number): Promise<Array<Part>> {
    const payload: SearchPayload = {
        term,
        offset: offset >= 0 ? offset : 0,
        limit: limit >= 0 ? (limit <= 100 ? limit : 100) : 0,
    };
    const res = await fetch(
        '/api/parts/search',
        {
            method: 'POST',
            headers: prepareRequestHeaders(),
            body: JSON.stringify(payload),
        }
    );
    if (res.status != 200) {
        const err = await makeApiError(res);
        throw err;
    }
    const returnedData = (await res.json()) as Array<PartObj>;
    return returnedData.map(item => new Part(item));
}
