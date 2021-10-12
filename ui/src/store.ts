import { createStore } from 'vuex';
import { User } from './models/user';


export interface StateObject {
    jwt: string;
    user: User | null;
}

// Our global store
const store = createStore({
    state() {
        return {
            jwt: '',
            user: null,
        }
    },
    mutations: {
        loggedIn(state: StateObject, jwt: string) {
            state.jwt = jwt;
            state.user = new User(jwt);
        },
        loggedOut(state: StateObject) {
            state.jwt = '';
            state.user = null;
        }
    }
})

export default store;
