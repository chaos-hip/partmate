import { createRouter, createWebHistory } from '@ionic/vue-router';
import { RouteRecordRaw } from 'vue-router';
import store from '../store';

const routes: Array<RouteRecordRaw> = [
  {
    path: '',
    redirect: '/search'
  },
  {
    name: 'Login',
    path: '/login',
    component: () => import('../views/Login.vue')
  },
  {
    name: 'Search',
    path: '/search',
    component: () => import('../views/Search.vue')
  },
  {
    name: 'PartViewer',
    path: '/part/:id',
    component: () => import('../views/Part.vue')
  },
  {
    name: 'PartLinks',
    path: '/part/:id/links',
    component: () => import('../views/PartLinks.vue')
  },
  {
    name: 'StorageViewer',
    path: '/storage/:id',
    component: () => import('../views/Search.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.name !== 'Login' && (!store.state.user || !store.state.user.valid)) {
    next('/login');
    return;
  } else if (to.name === 'Login' && store.state.user && store.state.user.valid) {
    next('/');
    return;
  }
  next();
});

export default router
