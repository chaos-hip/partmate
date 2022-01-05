import { Part, PartObj } from '@/models/part';
import { StorageObj, StorageLocation } from '@/models/storage';
import { LinkInfo, LinkType } from '@/models/link';
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
    if (res.status == 403) {
        // Logged out again
        store.commit('loggedOut');
    }
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

/**
 * Checks if the given link is valid
 * @param link The link to check
 * @returns `true` if the link is a valid one
 */
function isValidLink(link: string): boolean {
    return (/^[a-z0-9]+$/i).test(link);
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

/**
 * Searches for storage locations matching a given search term
 *
 * @param term Search term
 * @returns A list of storage locations matching the search term
 */
export async function searchStorageLocation(term: string, offset: number, limit: number): Promise<Array<StorageLocation>> {
    const payload: SearchPayload = {
        term,
        offset: offset >= 0 ? offset : 0,
        limit: limit >= 0 ? (limit <= 100 ? limit : 100) : 10,
    };
    const res = await fetch(
        '/api/storage/search',
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
    const returnedData = (await res.json()) as Array<StorageObj>;
    return returnedData.map(item => new StorageLocation(item));
}

/**
 * Gets the storage location with the given ID
 * @param id ID of the storage location to load
 * @returns The storage location having the given ID
 */
export async function getStorageById(id: string): Promise<StorageLocation> {
    if (!isValidLink(id)) {
        throw new Error('Invalid storage location ID');
    }
    const res = await fetch(`/api/storage/${id}`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    return new StorageLocation(await res.json());
}

/**
 * Gets the contents of the given storage location
 * @param id ID of the storage location to get the contents for
 * @param offset The number of records to skip when returning the paginated result
 * @param limit The number of items to return per page
 * @returns A list of parts contained in the current storage location
 */
export async function getStorageContentsByStorageId(id: string, offset: number, limit: number): Promise<Array<Part>> {
    if (!isValidLink(id)) {
        throw new Error('Invalid storage location ID');
    }
    offset = offset >= 0 ? Number(offset) : 0;
    limit = limit >= 0 ? (limit <= 100 ? Number(limit) : 100) : 10;
    const res = await fetch(`/api/storage/${id}/contents?limit=${limit}&offset=${offset}`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const returnedData = (await res.json()) as Array<PartObj>;
    return returnedData.map(item => new Part(item));
}

/**
 * Gets the part with the given ID
 * @param id ID of the part to load
 * @returns The part having the given ID
 */
export async function getPartById(id: string): Promise<Part> {
    if (!isValidLink(id)) {
        throw new Error('Invalid part ID');
    }
    const res = await fetch(`/api/parts/${id}`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    return new Part(await res.json());
}

/**
 * Gets information about what kind of object is behind a link
 *
 * @param linkId The link ID to get more information about
 * @returns Information about the selected link
 */
export async function getLinkInfo(linkId: string): Promise<LinkInfo> {
    if (!isValidLink(linkId)) {
        throw new Error('Invalid link ID');
    }
    const res = await fetch(`/api/links/${linkId}`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    return await res.json() as LinkInfo;
}

/**
 * Creates a new link in the database linking to the entity given
 *
 * @param link The link ID the new link will have
 * @param targetType The kind of entity the link will target
 * @param target The link ID the target has right now
 */
export async function createLink(link: string, targetType: LinkType, target: string): Promise<void> {
    if (!isValidLink(link)) {
        throw new Error('Invalid link ID');
    }
    if (!isValidLink(target)) {
        throw new Error('Invalid target ID');
    }
    const payload = {
        link,
        targetType,
        target,
    }
    const res = await fetch(`/api/links`, {
        method: 'POST',
        headers: prepareRequestHeaders(),
        body: JSON.stringify(payload),
    });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
}
