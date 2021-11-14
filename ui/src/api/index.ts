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
