import { Part, PartObj } from '@/models/part';
import { StorageObj, StorageLocation } from '@/models/storage';
import { LinkInfo, LinkType } from '@/models/link';
import store from '../store';
import { PartAttachment, PartAttachmentObj } from '@/models/attachment';
import { User, UserObj } from '@/models/user';
import { LoginToken, LoginTokenObj } from '@/models/loginToken';

//-- Helpers -----------------------------------------------------------------------------------------------------------


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

//-- Helper classes and interfaces -------------------------------------------------------------------------------------

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

interface SearchPayload {
    term?: string;
    offset: number;
    limit: number;
}

//-- API functions -----------------------------------------------------------------------------------------------------

/**
 * Logs in the user with the given credentials.
 * Will throw an error if something goes wrong.
 *
 * If successful, the user instance will be reachable through the application's store
 *
 * @param username The user name to log in with
 * @param password The password to log in with
 */
export async function login(username: string, password: string): Promise<void> {
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

/**
 * Tries to log-in using an access token
 *
 * @param token The token to log-in with
 */
export async function tokenLogin(token: string): Promise<void> {
    if (!isValidLink(token)) {
        throw new Error('Invalid token');
    }
    const res = await fetch(`/api/login/token/${token}`, {
        method: 'POST',
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

/**
 * Deletes a link from the PartMATE database
 * @param link The link to delete from the database
 */
export async function deleteLink(link: string): Promise<void> {
    if (!isValidLink(link)) {
        throw new Error('Invalid link ID');
    }
    const res = await fetch(`/api/links/${link}`, {
        method: 'DELETE',
        headers: prepareRequestHeaders(),
    });
    if (res.status !== 204) {
        throw await makeApiError(res);
    }
}

/**
 * Returns a list of links that link to the same target(s) the given link ID links to
 *
 * @param link The link ID to get the associated links for
 * @returns A list of other links that point to the same target(s) as the current one does
 */
export async function getLinksByParentLink(link: string): Promise<Array<LinkInfo>> {
    if (!isValidLink(link)) {
        throw new Error('Invalid link ID');
    }
    const res = await fetch(`/api/links/${link}/links`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    return (await res.json()) as Array<LinkInfo>;
}

/**
 * Loads a list of attachments associated to the given part
 *
 * @param link The link ID of the part to list the attachments for
 * @returns A list of attachments associated to the given part
 */
export async function getAttachmentsByPartLink(link: string): Promise<Array<PartAttachment>> {
    if (!isValidLink(link)) {
        throw new Error('Invalid link ID');
    }
    const res = await fetch(`/api/parts/${link}/attachments`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const objList = (await res.json()) as Array<PartAttachmentObj>;
    return objList.map(item => new PartAttachment(item));
}

/**
 * Prepares a report showing a printable storage location content list
 * Once created, the token can be used to open the report in a new tab
 *
 * @param storageId The ID of the storage location to create the report for
 * @returns A token that can be used to open the report
 */
export async function prepareStorageContentReport(storageId: string): Promise<string> {
    if (!isValidLink(storageId)) {
        throw new Error('Invalid link ID');
    }
    const res = await fetch(`/api/storage/${storageId}/reports/contents`, { method: 'POST', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const list = (await res.json()) as string;
    return list;
}

/**
 * Loads the list of users
 * @returns A list of all existing users
 */
export async function getUsers(): Promise<Array<string>> {
    const res = await fetch(`/api/users`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const list = (await res.json()) as Array<string>;
    return list;
}

/**
 * Removes the user with the given user name
 *
 * @param username The name of the user to remove
 */
export async function deleteUser(username: string): Promise<void> {
    if (!isValidLink(username)) {
        throw new Error('Invalid user name');
    }
    const res = await fetch(`/api/users/${username}`, { method: 'DELETE', headers: prepareRequestHeaders() });
    if (res.status !== 204) {
        throw await makeApiError(res);
    }
}

/**
 * Loads the list of users
 * @returns A list of all existing users
 */
export async function getUserByName(name: string): Promise<User> {
    if (!isValidLink(name)) {
        throw new Error('Invalid user name');
    }
    const res = await fetch(`/api/users/${name}`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const item = (await res.json()) as UserObj;
    return new User(item);
}

/**
 * Loads a list of login tokens for the given user
 * @param username The name of the user to get the login tokens for
 * @returns The list of login tokens the user currently has
 */
export async function getLoginTokensForUser(username: string): Promise<Array<LoginToken>> {
    if (!isValidLink(username)) {
        throw new Error('Invalid user name');
    }
    const res = await fetch(`/api/users/${username}/tokens`, { method: 'GET', headers: prepareRequestHeaders() });
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
    const items = (await res.json()) as Array<LoginTokenObj>;
    return items.map(item => new LoginToken(item));
}

/**
 * Deletes the login token entry having the given token string
 *
 * @param token The token string to delete the token entry for
 */
export async function deleteLoginToken(token: string): Promise<void> {
    if (!isValidLink(token)) {
        throw new Error('Invalid token');
    }
    // "foo" is just a stand-in since the user name doesn't matter
    const res = await fetch(`/api/users/foo/tokens/${token}`, { method: 'DELETE', headers: prepareRequestHeaders() });
    if (res.status !== 204) {
        throw await makeApiError(res);
    }
}

/**
 * Creates a new login token for a user
 *
 * @param username The user name to create the new token for
 * @param expires When will the token expire?
 * @param sessionLength How long (in seconds) will a created session be?
 */
export async function createLoginToken(username: string, expires: Date | null, sessionLength: number): Promise<void> {
    if (!isValidLink(username)) {
        throw new Error('Invalid user name');
    }
    if (sessionLength < 60) {
        sessionLength = 60;
    }
    const payload = {
        expiresAt: expires ? expires.getTime() : null,
        sessionLength: sessionLength,
    };
    const res = await fetch(
        `/api/users/${username}/tokens`,
        {
            method: 'POST',
            headers: prepareRequestHeaders(),
            body: JSON.stringify(payload),
        }
    );
    if (res.status !== 200) {
        throw await makeApiError(res);
    }
}

/**
 * Moves a part to a new storage location
 *
 * @param partLink Link to the part that should be moved
 * @param storageLink Link to the storage location that the part will be moved to
 */
export async function movePart(partLink: string, storageLink: string): Promise<void> {
    if (!isValidLink(partLink)) {
        throw new Error('Invalid part link');
    }
    if (!isValidLink(storageLink)) {
        throw new Error('Invalid storage link');
    }
    const payload = {
        to: storageLink
    }
    const res = await fetch(
        `/api/parts/${partLink}/rpc/move`,
        {
            method: 'POST',
            headers: prepareRequestHeaders(),
            body: JSON.stringify(payload),
        }
    );
    if (res.status !== 204) {
        throw await makeApiError(res);
    }
}
