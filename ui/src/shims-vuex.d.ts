import { ComponentCustomProperties } from 'vue'
import { Store } from 'vuex'
import { StateObject } from './store'

declare module '@vue/runtime-core' {
    interface ComponentCustomProperties {
        $store: Store<StateObject>
    }
}
