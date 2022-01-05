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
    component: () => import('../views/Search.vue'),
    children: [
      {
        path: '',
        redirect: '/search/parts'
      },
      {
        path: 'parts',
        component: () => import('../views/PartSearch.vue'),
      },
      {
        path: 'storage',
        component: () => import('../views/StorageSearch.vue'),
      }
    ]
  },
  {
    name: 'LinkViewer',
    path: '/link/:id',
    component: () => import('../views/Link.vue')
  },
  {
    name: 'PartViewer',
    path: '/part/:id',
    component: () => import('../views/Part.vue'),
  },
  {
    name: 'PartLinksViewer',
    path: '/link/:id/links',
    component: () => import('../views/LinkEditor.vue'),
  },
  {
    name: 'StorageViewer',
    path: '/storage/:id',
    component: () => import('../views/Storage.vue'),
  },
  {
    name: 'StorageContentsViewer',
    path: '/storage/:id/contents',
    component: () => import('../views/StorageContents.vue'),
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
