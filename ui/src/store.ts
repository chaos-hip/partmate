import { createStore } from 'vuex';
import { User } from './models/user';

const storageKey = 'activeUser';

export interface StateObject {
    jwt: string;
    user: User | null;
}

// Our global store
const store = createStore({
    state() {
        let jwt: string = localStorage.getItem(storageKey) || '';
        let user: User | null = null;
        if (jwt) {
            user = new User(jwt);
            if (!user.valid) {
                // Reset
                jwt = '';
                user = null;
            }
        }
        return {
            jwt: jwt,
            user: user,
        }
    },
    mutations: {
        loggedIn(state: StateObject, jwt: string) {
            localStorage.setItem(storageKey, jwt);
            state.jwt = jwt;
            state.user = new User(jwt);
        },
        loggedOut(state: StateObject) {
            state.jwt = '';
            state.user = null;
            localStorage.removeItem(storageKey);
        }
    }
})

export default store;
