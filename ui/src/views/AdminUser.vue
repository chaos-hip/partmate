<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="primary">
          <ion-button @click="addUser()">
            <ion-icon slot="icon-only" :icon="personAddOutline"></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-list v-if="userList.length > 0">
        <ion-item-sliding v-for="user in userList" :key="user">
          <ion-item
            lines="full"
            @click="$router.push(`/admin/users/${user}`)"
            detail
          >
            <ion-icon
              :icon="personOutline"
              slot="start"
              :color="user == username ? 'tertiary' : ''"
            ></ion-icon>
            <ion-text>{{ user }}</ion-text>
          </ion-item>
          <ion-item-options side="end">
            <ion-item-option
              color="danger"
              v-if="user !== username && can(Permission.UserDelete)"
              @click="removeUser(user)"
            >
              {{ t("btn.delete") }}
            </ion-item-option>
          </ion-item-options>
        </ion-item-sliding>
      </ion-list>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import {
  IonPage,
  IonToolbar,
  IonButtons,
  IonTitle,
  IonHeader,
  IonBackButton,
  IonContent,
  IonButton,
  IonIcon,
  IonLoading,
  IonItemSliding,
  IonItemOption,
  IonItemOptions,
  IonList,
  IonItem,
  IonText,
  alertController,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { personOutline, personAddOutline } from 'ionicons/icons';
import { deleteUser, getUsers } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { Permission } from '@/models/user';

export default defineComponent({
  name: 'PartLinkOverview',
  components: {
    IonPage,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
    IonButton,
    IonIcon,
    IonLoading,
    IonItemSliding,
    IonItemOption,
    IonItemOptions,
    IonList,
    IonItem,
    IonText,
  },
  computed: {
    username() {
      return this.$store.state.user ? this.$store.state.user.name : '';
    }
  },
  methods: {
    can(permission: Permission) {
      if (!this.$store.state.user) {
        return false;
      }
      return this.$store.state.user.can(permission);
    },
    async reloadData() {
      this.loading = true;
      try {
        this.userList = await getUsers();
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      this.loading = false;
    },
    async addUser() {
      const alert = await alertController.create({
        header: this.t('alert.new.title'),
        message: this.t('alert.new.message'),
        buttons: [this.t('alert.close')],
      });
      await alert.present();
    },
    async removeUser(name: string) {
      if (!name || (this.$store.state.user && name === this.$store.state.user.name)) {
        return;
      }
      try {
        await deleteUser(name);
      } catch (err) {
        this.showError(String(err), 'err.remove');
      }
      this.reloadData();
    },
  },
  mounted() {
    this.$nextTick(function () {
      this.reloadData();
    });
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const userList: Ref<Array<string>> = ref([]);
    const loading = ref(false);

    return {
      t,
      dismissError,
      showError,
      personOutline,
      personAddOutline,
      userList,
      loading,
      Permission,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Benutzer
loading: Lade...
btn:
  delete: Löschen
  dismiss: Schließen
err:
  load: Fehler beim Datenabruf
  remove: User konnte nicht gelöscht werden
alert:
  new:
    title: Nicht verfügbar
    message: Diese Funktion ist zur Zeit noch nicht verfügbar
  close: Schließen
</i18n>
<i18n locale="en" lang="yaml">
title: Users
loading: Loading...
btn:
  delete: Delete
  dismiss: Dismiss
err:
  load: Error loading data
  remove: Could not delete user
alert:
  new:
    title: Not implemented
    message: This function is not yet implemented
  close: Close
</i18n>

<style scoped>
.partPreview {
  width: 100%;
  height: auto;
  object-fit: cover;
}

ion-card > ion-item {
  --background: transparent;
}
</style>
