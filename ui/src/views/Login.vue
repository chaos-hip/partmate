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
      <ion-card style="max-width: 450px">
        <ion-card-content>
          <form @submit.prevent="doLogin" ref="loginForm">
            <ion-item>
              <ion-label position="fixed">{{ t("label.user") }}</ion-label>
              <ion-input
                autofocus
                clear-input
                required
                v-model="username"
                @keyup="onUserKeyUp"
              ></ion-input>
            </ion-item>
            <ion-item>
              <ion-label position="fixed">{{ t("label.password") }}</ion-label>
              <ion-input
                id="iptPassword"
                clear-input
                enterkeyhint="send"
                required
                type="password"
                v-model="password"
                @keyup="onPassKeyUp"
              ></ion-input>
            </ion-item>
            <ion-item>
              <ion-button slot="end" color="primary" @click="doLogin">{{
                t("btn.login")
              }}</ion-button>
            </ion-item>
          </form>
        </ion-card-content>
      </ion-card>
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
  IonCard,
  IonCardContent,
  IonButton,
  IonItem,
  IonLabel,
  IonInput,
  toastController,
} from '@ionic/vue';
import { login } from '../api';
import { useI18n } from 'vue-i18n'

export default defineComponent({
  name: 'Folder',
  components: {
    IonButtons,
    IonContent,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonTitle,
    IonToolbar,
    IonCard,
    IonCardContent,
    IonButton,
    IonItem,
    IonLabel,
    IonInput,
  },
  methods: {
    async doLogin() {
      if (this.username !== '' && this.password !== '') {
        try {
          await login(this.username, this.password);
        } catch (err) {
          this.showError(this.t('err.loginFailed'), this.t(`err.` + (err as Error).message));
          return;
        }
        this.password = '';
        this.$router.push('/');
      }
    },
    onUserKeyUp(ev: KeyboardEvent) {
      if (ev.key == 'Enter') {
        if (this.password !== '' && this.username !== '') {
          this.doLogin();
        } else if (this.username !== '') {
          (document.querySelector('#iptPassword > input') as HTMLElement).focus();
        }
      }
    },
    onPassKeyUp(ev: KeyboardEvent) {
      if (ev.key == 'Enter' && this.password !== '' && this.username !== '') {
        this.doLogin();
      }
    },
    async showError(title: string, message: string) {
      const toast = await toastController.create({
        header: title,
        message: message,
        position: 'middle',
        color: 'danger',
        buttons: [
          {
            text: this.t('btn.dismiss'),
          }
        ]
      });
      await toast.present();
    },
  },
  setup() {
    const username = ref("");
    const password = ref("");
    const errorTitle = ref("");
    const errorMessage = ref("");
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })
    return {
      username,
      password,
      errorTitle,
      errorMessage,
      t,
    };
  }
});
</script>

<i18n locale="de" lang="yaml">
  title: 'PartMATE - Login'
  btn:
    dismiss: Verwerfen
    login: Einloggen
  label:
    user: Benutzer
    password: Kennwort
  err:
    loginFailed: 'Login fehlgeschlagen'
    'User does not exist': 'Der Benutzername existiert nicht'
    'Wrong password': 'Falsches Kennwort.'
</i18n>
<i18n locale="en" lang="yaml">
  title: 'PartMATE - Login'
  btn:
    dismiss: Dismiss
    login: Login
  label:
    user: User
    password: Password
  err:
    loginFailed: 'Login failed'
    'User does not exist': 'The user with the given name does not exist'
    'Wrong password': 'Wrong password.'
</i18n>

<style scoped>
</style>
