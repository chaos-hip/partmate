<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search/storage"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ storage ? storage.name : "" }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-card v-if="!loading && storage">
        <ion-card-header>
          <ion-card-subtitle color="primary">{{
            storage.category.fullPath
          }}</ion-card-subtitle>
          <ion-card-title>{{ storage.name }}</ion-card-title>
          <p>{{ storage.description }}</p>
        </ion-card-header>
        <ion-item
          detail
          lines="none"
          @click="$router.push(`/storage/${storageId}/links`)"
        >
          <ion-icon slot="start" :icon="linkSharp"></ion-icon>
          <ion-label>{{ t("storage.links") }}</ion-label>
        </ion-item>
      </ion-card>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
      <ion-list v-if="!loading && storage">
        <ion-list-header>
          <ion-label>{{ t("storage.contents") }}</ion-label>
        </ion-list-header>
      </ion-list>
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
  IonList,
  IonListHeader,
  isPlatform,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { documentsSharp, linkSharp } from 'ionicons/icons';
import { getStorageById } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';

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
    IonList,
    IonListHeader,
  },
  props: {
    id: String,
    backButtonLabel: String,
  },
  mounted() {
    this.loadStorageLocation();
  },
  computed: {
    storageId() {
      return this.id || this.$route.params.id || '';
    }
  },
  watch: {
    storageId(newVal: string) {
      if (newVal) {
        this.loadStorageLocation();
      }
    }
  },
  methods: {
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
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const storage: Ref<StorageLocation> | Ref<null> = ref(null);
    const loading = ref(false);

    return {
      t,
      showError,
      dismissError,
      documentsSharp,
      linkSharp,
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
    contents: 'Teile in dieser Location'
err:
  load: Teileinfo konnte nicht geladen werden
</i18n>
<i18n locale="en" lang="yaml">
loading: Loading...
storage:
    links: 'Links'
    contents: 'Parts in this location'
err:
  load: Failed to load part information
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
