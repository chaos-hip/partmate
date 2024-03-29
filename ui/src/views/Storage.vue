<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search/storage"></ion-back-button>
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>
          {{ storage ? storage.name : "" }}
        </ion-title>
        <ion-buttons slot="end">
          <ion-button @click="showOptions()">
            <ion-icon
              slot="icon-only"
              :ios="ellipsisHorizontal"
              :md="ellipsisVertical"
            ></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-grid :fixed="true">
        <ion-row>
          <ion-col size="12" size-sm="8" size-md="6" size-xl="5">
            <ion-card v-if="!loading && storage">
              <ion-card-header>
                <ion-card-subtitle color="primary">
                  {{ storage.category.fullPath }}
                </ion-card-subtitle>
                <ion-card-title>
                  {{ storage.name }}
                </ion-card-title>
                <p>{{ storage.description }}</p>
              </ion-card-header>
              <ion-item
                detail
                lines="none"
                @click="$router.push(`/link/${storage.id}/links`)"
              >
                <ion-icon slot="start" :icon="linkSharp"></ion-icon>
                <ion-label>{{ t("storage.links") }}</ion-label>
              </ion-item>
              <ion-item
                detail
                lines="none"
                @click="$router.push(`/storage/${storage.id}/contents`)"
              >
                <ion-icon slot="start" :icon="hardwareChipOutline"></ion-icon>
                <ion-label>{{ t("storage.contents") }}</ion-label>
                <ion-note slot="end" color="medium">
                  {{ storage.partsContained }}
                </ion-note>
              </ion-item>
            </ion-card>
          </ion-col>
        </ion-row>
      </ion-grid>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { StorageLocation } from '@/models/storage';
import {
  IonPage,
  IonToolbar,
  IonButtons,
  IonTitle,
  IonHeader,
  IonBackButton,
  IonContent,
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardSubtitle,
  IonItem,
  IonLabel,
  IonLoading,
  IonIcon,
  IonButton,
  IonNote,
  isPlatform,
  IonCol,
  IonRow,
  IonGrid,
  IonMenuButton,
  actionSheetController,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { linkSharp, hardwareChipOutline, ellipsisVertical, ellipsisHorizontal } from 'ionicons/icons';
import { getStorageById, prepareStorageContentReport } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { Permission } from '@/models/user';

export default defineComponent({
  name: 'StorageOverview',
  components: {
    IonPage,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
    IonCard,
    IonCardHeader,
    IonCardTitle,
    IonCardSubtitle,
    IonItem,
    IonLabel,
    IonLoading,
    IonIcon,
    IonButton,
    IonNote,
    IonCol,
    IonRow,
    IonGrid,
    IonMenuButton,
  },
  props: {
    id: String,
    backButtonLabel: String,
  },
  mounted() {
    this.$nextTick(function () {
      this.loadStorageLocation();
    });
  },
  computed: {
    storageId() {
      return this.id || this.$route.params.id || '';
    }
  },
  methods: {
    can(permission: Permission) {
      if (!this.$store.state.user) {
        return false;
      }
      return this.$store.state.user.can(permission);
    },
    async loadStorageLocation() {
      this.storage = null;
      if (!this.storageId) {
        return;
      }
      this.loading = true;
      try {
        const p = await getStorageById(this.storageId as string);
        (this.storage as unknown) = p;
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      this.loading = false;
    },
    async showOptions() {
      const buttons = [];
      if (this.can(Permission.ReportStorageContents)) {
        buttons.push({
          text: this.t('actions.contentReport'),
          icon: hardwareChipOutline,
          handler: async () => {
            if (!this.storageId) {
              return;
            }
            try {
              const token = await prepareStorageContentReport(this.storageId as string);
              window.open(`/reports/${token}`, 'report');
            } catch (err) {
              this.showError(String(err), 'err.load');
            }
          }
        });
      }
      if (buttons.length == 0) {
        return;
      }
      const sheet = await actionSheetController.create({
        header: this.t('actions.title'),
        buttons: buttons,
      });
      await sheet.present();
    },
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const storage: Ref<StorageLocation> | Ref<null> = ref(null);
    const loading = ref(false);

    return {
      t,
      showError,
      dismissError,
      linkSharp,
      hardwareChipOutline,
      ellipsisVertical,
      ellipsisHorizontal,
      isPlatform,
      storage,
      loading,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
loading: Lade...
storage:
    links: Links
    contents: Teile
err:
  load: Lagerort konnte nicht geladen werden
actions:
  title: Actions
  contentReport: Inhaltsliste drucken...
</i18n>
<i18n locale="en" lang="yaml">
loading: Loading...
storage:
    links: 'Links'
    contents: Parts
err:
  load: Failed to load storage location information
actions:
  title: Actions
  contentReport: Open content report...
</i18n>

<style scoped>
.partPreview {
  width: 100%;
  height: auto;
  object-fit: cover;
}

ion-card ion-item {
  --background: transparent;
}
</style>
