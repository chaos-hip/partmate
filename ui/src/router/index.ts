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
    name: 'TokenLogin',
    path: '/token/:id',
    component: () => import('../views/TokenLogin.vue')
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
    name: 'PartAttachmentViewer',
    path: '/part/:id/attachments',
    component: () => import('../views/PartAttachments.vue'),
  },
  {
    name: 'LinksViewer',
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
  },
  {
    name: 'UserAdminView',
    path: '/admin/users',
    component: () => import('../views/AdminUser.vue'),
  },
  {
    name: 'UserEditor',
    path: '/admin/users/:name',
    component: () => import('../views/User.vue'),
  },
  {
    name: 'UserPermissionEditor',
    path: '/admin/users/:name/permissions',
    component: () => import('../views/UserPermissions.vue'),
  },

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.name !== 'Login' && to.name !== 'TokenLogin' && (!store.state.user || !store.state.user.valid)) {
    next('/login');
    return;
  } else if ((to.name === 'Login' || to.name === 'TokenLogin') && store.state.user && store.state.user.valid) {
    next('/');
    return;
  }
  next();
});

export default router
