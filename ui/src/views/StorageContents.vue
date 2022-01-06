<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search/storage"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-refresher
        slot="fixed"
        @ionRefresh="refresh($event)"
        id="contents-refresher"
      >
        <ion-refresher-content
          :pulling-icon="chevronDownCircleOutline"
          pulling-text="Ziehen zum neu laden..."
          refreshing-spinner="circles"
          refreshing-text="Lade..."
        ></ion-refresher-content>
      </ion-refresher>
      <ion-list>
        <ion-list-header>
          <ion-label>{{ storage.name }}</ion-label>
        </ion-list-header>
        <part-list-item
          v-for="part in partList"
          :part="part"
          @click="partSelected(part.id)"
          :key="part.id"
        ></part-list-item>
      </ion-list>
      <ion-infinite-scroll
        @ionInfinite="paginate($event)"
        threshold="100px"
        :disabled="!stillScrolling"
      >
        <ion-infinite-scroll-content
          loading-spinner="bubbles"
          :loading-text="t('loading')"
        ></ion-infinite-scroll-content>
      </ion-infinite-scroll>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import PartListItem from '@/components/PartListItem.vue';
import {
  IonPage,
  IonToolbar,
  IonTitle,
  IonHeader,
  IonBackButton,
  IonContent,
  IonRefresher,
  IonRefresherContent,
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonList,
  IonListHeader,
  IonLabel,
  IonButtons,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { errorDisplay } from '@/composables/errorDisplay';
import { chevronDownCircleOutline } from 'ionicons/icons';
import { Part } from '@/models/part';
import { getStorageById, getStorageContentsByStorageId } from '@/api';
import { StorageLocation } from '@/models/storage';

export default defineComponent({
  name: 'StorageContentsView',
  components: {
    IonPage,
    IonToolbar,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
    PartListItem,
    IonRefresher,
    IonRefresherContent,
    IonInfiniteScroll,
    IonInfiniteScrollContent,
    IonList,
    IonListHeader,
    IonLabel,
    IonButtons,
  },
  computed: {
    storageId(): string {
      return this.id || this.$route.params.id as string || '';
    }
  },
  props: {
    id: String,
  },
  mounted() {
    this.$nextTick(function () {
      this.loadData(true);
    })
  },
  methods: {
    async loadData(clear?: boolean) {
      if (!this.storageId) {
        return;
      }
      if (clear) {
        this.partList = [];
        try {
          this.storage = await getStorageById(this.storageId);
        } catch (err) {
          this.showError(this.t((err as Error).message));
        }
      }
      try {
        const res = await getStorageContentsByStorageId(this.storageId, this.partList.length, this.pageSize);
        this.stillScrolling = res.length > 0;
        this.partList.push(...res);
      } catch (err) {
        this.showError(this.t((err as Error).message));
      }
    },
    async paginate(ev: CustomEvent) {
      await this.loadData();
      const target = ev.target as any;
      target.complete();
    },
    async refresh(ev: CustomEvent) {
      await this.loadData(true);
      const target = ev.target as any;
      target.complete();
    },
    partSelected(id: string) {
      this.$router.push(`/part/${id}`);
    },
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const loading = ref(false);
    const partList: Ref<Array<Part>> = ref([]);
    const stillScrolling = ref(true);
    const pageSize = ref(20);
    const storage = ref(new StorageLocation());

    return {
      t,
      dismissError,
      showError,
      chevronDownCircleOutline,
      loading,
      partList,
      stillScrolling,
      pageSize,
      storage,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Enthaltene Teile
loading: Lade...
</i18n>
<i18n locale="en" lang="yaml">
title: Parts contained
loading: Loading...
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
