<template>
  <IonApp>
    <IonSplitPane content-id="main-content">
      <ion-menu content-id="main-content" type="overlay">
        <ion-content>
          <ion-list id="menu-list">
            <ion-list-header>{{ t("menu.title") }}</ion-list-header>
            <ion-note>{{ userName }}</ion-note>

            <ion-menu-toggle
              auto-hide="false"
              v-for="(p, i) in appPages"
              :key="i"
            >
              <ion-item
                @click="selectedIndex = i"
                router-direction="root"
                :router-link="p.url"
                lines="none"
                detail="false"
                class="hydrated"
                v-show="$store.state.user && $store.state.user.valid"
                :class="{ selected: selectedIndex === i }"
                v-if="
                  !Array.isArray(p.perm) ||
                  ($store.state.user && $store.state.user.can(...p.perm))
                "
              >
                <ion-icon
                  slot="start"
                  :ios="p.iosIcon"
                  :md="p.mdIcon"
                ></ion-icon>
                <ion-label>{{ p.title }}</ion-label>
              </ion-item>
            </ion-menu-toggle>
            <ion-menu-toggle auto-hide="false">
              <ion-item
                router-direction="root"
                router-link="/login"
                lines="none"
                detail="false"
                class="hydrated"
                v-if="!$store.state.user || !$store.state.user.valid"
              >
                <ion-icon
                  slot="start"
                  :ios="logInOutline"
                  :md="logInSharp"
                ></ion-icon>
                <ion-label>{{ t("menu.login") }}</ion-label>
              </ion-item>
            </ion-menu-toggle>
          </ion-list>
          <ion-list id="labels-list">
            <ion-item
              @click="doLogout()"
              lines="none"
              detail="false"
              class="hydrated"
              v-if="$store.state.user && $store.state.user.valid"
            >
              <ion-icon
                slot="start"
                :ios="logOutOutline"
                :md="logOutSharp"
              ></ion-icon>
              <ion-label>{{ t("menu.logout") }}</ion-label>
            </ion-item>
          </ion-list>
        </ion-content>
      </ion-menu>
      <ion-router-outlet id="main-content"></ion-router-outlet>
    </IonSplitPane>
  </IonApp>
</template>

<script lang="ts">
import { IonApp, IonContent, IonIcon, IonItem, IonLabel, IonList, IonListHeader, IonMenu, IonMenuToggle, IonNote, IonRouterOutlet, IonSplitPane } from '@ionic/vue';
import { defineComponent, ref } from 'vue';
import { useRoute } from 'vue-router';
import {
  searchOutline,
  searchSharp,
  cameraOutline,
  cameraSharp,
  codeSlashOutline,
  codeSlashSharp,
  logInOutline,
  logInSharp,
  logOutOutline,
  logOutSharp,
  peopleOutline,
  peopleSharp,
} from 'ionicons/icons';
import { useI18n } from 'vue-i18n';
import { Permission } from '@/models/user'

export default defineComponent({
  name: 'App',
  computed: {
    userName() {
      return this.$store.state.user ? this.$store.state.user.name : '';
    },
    loggedIn() {
      return this.$store.state.user != null;
    }
  },
  components: {
    IonApp,
    IonContent,
    IonIcon,
    IonItem,
    IonLabel,
    IonList,
    IonListHeader,
    IonMenu,
    IonMenuToggle,
    IonNote,
    IonRouterOutlet,
    IonSplitPane,
  },
  methods: {
    doLogout() {
      this.$store.commit('loggedOut');
    }
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })
    const selectedIndex = ref(0);
    const appPages = [
      {
        title: t('menu.search'),
        url: '/search',
        iosIcon: searchOutline,
        mdIcon: searchSharp
      },
      {
        title: t('menu.userAdmin'),
        url: '/admin/users',
        iosIcon: peopleOutline,
        mdIcon: peopleSharp,
        perm: [Permission.UserLoginTokenAdmin],
      },
    ];

    const path = window.location.pathname.split('example/')[1];
    if (path !== undefined) {
      selectedIndex.value = appPages.findIndex(page => page.title.toLowerCase() === path.toLowerCase());
    }

    const route = useRoute();

    return {
      selectedIndex,
      appPages,
      searchOutline,
      searchSharp,
      cameraOutline,
      cameraSharp,
      codeSlashOutline,
      codeSlashSharp,
      logInOutline,
      logInSharp,
      logOutOutline,
      logOutSharp,
      peopleOutline,
      peopleSharp,
      Permission,
      t,
      isSelected: (url: string) => url === route.path ? 'selected' : ''
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
  menu:
    title: 'PartMATE'
    login: 'Einloggen'
    logout: 'Ausloggen'
    search: 'Suche'
    userAdmin: 'Benutzer'
  'Not authenticated. You have to log-in to use this API': |
    Du bist nicht eingeloggt.
    <br>Bitte melde dich erneut an.
  btn:
    dismiss: Schließen
</i18n>
<i18n locale="en" lang="yaml">
  menu:
    title: 'PartMATE'
    login: 'Login'
    logout: 'Logout'
    search: 'Search'
    userAdmin: 'Users'
  'Not authenticated. You have to log-in to use this API': |
    Your are not logged in.
    <br>Please authenticate again.
  btn:
    dismiss: Dismiss
</i18n>

<style scoped>
ion-menu ion-content {
  --background: var(--ion-item-background, var(--ion-background-color, #fff));
}

ion-menu.md ion-content {
  --padding-start: 8px;
  --padding-end: 8px;
  --padding-top: 20px;
  --padding-bottom: 20px;
}

ion-menu.md ion-list {
  padding: 20px 0;
}

ion-menu.md ion-note {
  margin-bottom: 30px;
}

ion-menu.md ion-list-header,
ion-menu.md ion-note {
  padding-left: 10px;
}

ion-menu.md ion-list#menu-list {
  border-bottom: 1px solid var(--ion-color-step-150, #d7d8da);
}

ion-menu.md ion-list#menu-list ion-list-header {
  font-size: 22px;
  font-weight: 600;

  min-height: 20px;
}

ion-menu.md ion-list#labels-list ion-list-header {
  font-size: 16px;

  margin-bottom: 18px;

  color: #757575;

  min-height: 26px;
}

ion-menu.md ion-item {
  --padding-start: 10px;
  --padding-end: 10px;
  border-radius: 4px;
}

ion-menu.md ion-item.selected {
  --background: rgba(var(--ion-color-primary-rgb), 0.14);
}

ion-menu.md ion-item.selected ion-icon {
  color: var(--ion-color-primary);
}

ion-menu.md ion-item ion-icon {
  color: #616e7e;
}

ion-menu.md ion-item ion-label {
  font-weight: 500;
}

ion-menu.ios ion-content {
  --padding-bottom: 20px;
}

ion-menu.ios ion-list {
  padding: 20px 0 0 0;
}

ion-menu.ios ion-note {
  line-height: 24px;
  margin-bottom: 20px;
}

ion-menu.ios ion-item {
  --padding-start: 16px;
  --padding-end: 16px;
  --min-height: 50px;
}

ion-menu.ios ion-item.selected ion-icon {
  color: var(--ion-color-primary);
}

ion-menu.ios ion-item ion-icon {
  font-size: 24px;
  color: #73849a;
}

ion-menu.ios ion-list#labels-list ion-list-header {
  margin-bottom: 8px;
}

ion-menu.ios ion-list-header,
ion-menu.ios ion-note {
  padding-left: 16px;
  padding-right: 16px;
}

ion-menu.ios ion-note {
  margin-bottom: 8px;
}

ion-note {
  display: inline-block;
  font-size: 16px;

  color: var(--ion-color-medium-shade);
}

ion-item.selected {
  --color: var(--ion-color-primary);
}
</style>
