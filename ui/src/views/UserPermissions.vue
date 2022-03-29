<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            default-href="/search"
            :text="t('btn.cancel')"
          ></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="end" v-if="pendingChanges">
          <ion-button @click="applyChanges()">
            {{ t("btn.save") }}
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-text v-if="!loading && permissionList.length == 0">
        {{ t("msg.emptyResult") }}
      </ion-text>
      <ion-list v-if="permissionList.length > 0">
        <ion-item lines="full" v-for="p in permissionList" :key="p">
          <ion-icon :icon="skullOutline" slot="start"></ion-icon>
          <ion-label>
            <h2>{{ t(`perm.${p}`) }}</h2>
            <p>{{ p }}</p>
          </ion-label>
          <ion-checkbox
            slot="end"
            :checked="user.can(p)"
            @ionChange="permissionChanged(p, $event)"
          ></ion-checkbox>
        </ion-item>
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
  IonIcon,
  IonLoading,
  IonList,
  IonItem,
  IonText,
  IonLabel,
  IonCheckbox,
  IonButton,
  toastController,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { skullOutline } from 'ionicons/icons';
import { getAvailablePermissions, getUserByName, setUserPermissions } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { User } from '@/models/user';

export default defineComponent({
  name: 'UserPermissions',
  components: {
    IonPage,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
    IonIcon,
    IonLoading,
    IonList,
    IonItem,
    IonText,
    IonLabel,
    IonCheckbox,
    IonButton,
  },
  props: {
    username: String,
  },
  computed: {
    currentUsername() {
      return this.username || this.$route.params.name || '';
    },
  },
  methods: {
    async reloadData() {
      if (!this.currentUsername) {
        return;
      }
      this.pendingChanges = false;
      this.loading = true;
      try {
        const u = await getUserByName(this.currentUsername as string);
        (this.user as unknown) = u;
        this.permissionList = await getAvailablePermissions();
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      this.loading = false;
    },
    permissionChanged(permission: any, ev: CustomEvent) {
      if (!this.user) {
        return;
      }
      if (ev.detail.checked) {
        // Add permission to user
        (this.user as User).permissions.set(permission, true);
      } else {
        // Remove permission from user
        (this.user as User).permissions.delete(permission);
      }
      this.pendingChanges = true;
    },
    async applyChanges() {
      if (!this.user) {
        return;
      }
      const perms: Array<string> = [];
      (this.user as User).permissions.forEach((_, perm) => {
        perms.push(perm);
      })
      try {
        await setUserPermissions((this.user as User).name, perms);
      } catch (err) {
        this.showError(String(err), 'err.save');
        return;
      }
      const toast = await toastController.create({
        message: this.t('msg.saveSuccess'),
        position: 'bottom',
        color: 'success',
        duration: 2000,
      });
      this.$router.back();
      await toast.present();
    }
  },
  mounted() {
    this.$nextTick(function () {
      this.reloadData();
    });
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const pendingChanges = ref(false);
    const user: Ref<User> | Ref<null> = ref(null);
    const permissionList: Ref<Array<string>> = ref([]);
    const loading = ref(false);

    return {
      t,
      dismissError,
      showError,
      user,
      permissionList,
      loading,
      pendingChanges,
      // Icons
      skullOutline,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Berechtigungen
loading: Lade...
msg:
  emptyResult: |
    Berechtigungen nicht geladen
  saveSuccess: Berechtigungen erfolgreich gespeichert
btn:
  dismiss: Schließen
  save: Anwenden
  cancel: Abbrechen
err:
  load: Beim Laden der Daten ist ein Fehler aufgetreten
  save: Beim Speichern der Änderungen ist ein Fehler aufgetreten
perm:
  'link:create': "Link erstellen"
  'link:delete': "Link löschen"
  'link:read': "Links anzeigen"
  'part:move': "Teil umziehen"
  part:
    'attachment:create': "Teile: Dateien hochladen"
    'attachment:read': "Teile: Dateien anzeigen"
    'stock:manage': "Teile: Bestand verwalten"
  report:
    'storageContents:view': "Report: Lagerort-Inhaltsliste"
    'venueSummary:view': "Report: Veranstaltung"
  'user:read': "Benutzer anzeigen"
  'user:delete': "Benutzer löschen"
  'user:create': "Benutzer erstellen"
  user:
    'permission:grant': "Benutzerrechte bearbeiten"
    'password:admin': "Benutzer: Passwörter verwalten"
    'password:set': "Eigenes Passwort ändern"
    'token:admin': "Benutzer: Tokens verwalten"
  'venue:create': "Veranstaltung anlegen"
  'venue:delete': "Veranstaltung löschen"
  'venue:finish': "Veranstaltung beenden"
  'venue:read': "Veranstaltungen anzeigen"
  venue:
    'item:checkin': "Venue: Teile einchecken"
    'item:checkout': "Venue: Teile auschecken"
    'item:inspected': "Venue: Teile prüfen"

</i18n>
<i18n locale="en" lang="yaml">
title: Links
loading: Permissions
msg:
  emptyResult: |
    No permissions loaded
  saveSuccess: Permissions updated successfully
btn:
  dismiss: Dismiss
  save: Apply
  cancel: Cancel
err:
  load: An error occurred while loading data
  save: An error occurred while saving the changes
perm:
  'link:create': "Create link"
  'link:delete': "Delete link"
  'link:read': "Show links"
  'part:move': "Teil umziehen"
  part:
    'attachment:create': "Parts: Upload files"
    'attachment:read': "Parts: View files"
    'stock:manage': "Parts: Manage stock"
  report:
    'storageContents:view': "Report: Storage contents"
    'venueSummary:view': "Report: Venue Summary"
  'user:read': "Show users"
  'user:delete': "Delete user"
  'user:create': "Create user"
  user:
    'permission:grant': "Manage user permissions"
    'password:admin': "Manage user passwords"
    'password:set': "Change own password"
    'token:admin': "Manage user tokens"
  'venue:create': "Create venue"
  'venue:delete': "Delete venue"
  'venue:finish': "Finish venue"
  'venue:read': "List venues"
  venue:
    'item:checkin': "Venue: Item checkin"
    'item:checkout': "Venue: Item checkout"
    'item:inspected': "Venue: Inspect item"
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
