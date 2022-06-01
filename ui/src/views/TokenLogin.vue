<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="true">
      <ion-loading v-if="loading"></ion-loading>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue';
import {
  IonButtons,
  IonContent,
  IonHeader,
  IonMenuButton,
  IonPage,
  IonTitle,
  IonToolbar,
  IonLoading,
} from '@ionic/vue';
import { tokenLogin } from '../api';
import { errorDisplay } from '@/composables/errorDisplay';

export default defineComponent({
  name: 'partmate-token-login',
  components: {
    IonButtons,
    IonContent,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonTitle,
    IonToolbar,
    IonLoading,
  },
  computed: {
    token() {
      return this.$route.params.id || '';
    }
  },
  mounted() {
    this.$nextTick(function () {
      this.doLogin();
    });
  },
  methods: {
    async doLogin() {
      if (!this.$store.state.user && !this.token) {
        this.showError('err.noToken')
        return;
      }
      this.loading = true;
      try {
        await tokenLogin(this.token as string);
      } catch (err) {
        this.showError(this.t('err.loginFailed'), this.t(`err.` + (err as Error).message));
        this.loading = false;
        return;
      }
      this.loading = true;
      this.$router.replace('/');
    },
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();
    const loading = ref(false);

    return {
      t,
      dismissError,
      showError,
      loading,
    };
  }
});
</script>

<i18n locale="de" lang="yaml">
title: 'PartMATE - Token Login'
err:
  loginFailed: 'Login fehlgeschlagen'
  noToken: 'Kein Token verfügbar'
btn:
  dismiss: Schließen
</i18n>
<i18n locale="en" lang="yaml">
title: 'PartMATE - Token Login'
err:
  loginFailed: 'Login failed'
  noToken: 'No token available'
btn:
  dismiss: Dismiss
</i18n>

<style scoped>
ion-item {
  --background: transparent;
}
</style>
