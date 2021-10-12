import { createRouter, createWebHistory } from '@ionic/vue-router';
import { RouteRecordRaw } from 'vue-router';
import store from '../store';

const routes: Array<RouteRecordRaw> = [
  {
    path: '',
    redirect: '/example/Suche'
  },
  {
    name: 'Login',
    path: '/login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/example/:id',
    component: () => import('../views/Folder.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.name !== 'Login' && !store.state.user) {
    next('/login');
    return;
  } else if (to.name === 'Login' && store.state.user) {
    next('/');
    return;
  }
  next();
});

export default router
