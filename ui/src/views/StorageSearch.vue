<template>
  <ion-page>
    <ion-header :translucent="true">
      <!-- Just a placeholder for the height -->
      <ion-toolbar v-if="!selectOnly"> </ion-toolbar>
      <ion-toolbar>
        <ion-searchbar
          animated
          autocomplete="off"
          :placeholder="t('search.placeholder')"
          enterkeyhint="send"
          debounce="500"
          :value="searchTerm"
          @ionInput="searchTerm = $event.target.value"
          @change="doSearch(true)"
          @ionClear="
            searchTerm = '';
            doSearch($event);
          "
        ></ion-searchbar>
        <ion-buttons slot="end">
          <ion-button @click="$emit('cancelled')" v-if="selectOnly">
            {{ t("btn.cancel") }}
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content :fullscreen="true">
      <ion-refresher
        slot="fixed"
        @ionRefresh="refresh($event)"
        id="gallery-refresher"
      >
        <ion-refresher-content
          :pulling-icon="chevronDownCircleOutline"
          :pulling-text="t('pullingText')"
          refreshing-spinner="circles"
          :refreshing-text="t('loading')"
        ></ion-refresher-content>
      </ion-refresher>
      <ion-list>
        <ion-item
          lines="inset"
          button
          v-for="storage in searchResult"
          @click="storageSelected(storage.id)"
          :key="storage.id"
        >
          <ion-label>
            <p>{{ storage.category.fullPath }}</p>
            <h2>{{ storage.name }}</h2>
            <p>{{ storage.description }}</p>
          </ion-label>
        </ion-item>
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
import { StorageLocation } from '@/models/storage';
import {
  IonContent,
  IonHeader,
  IonPage,
  IonToolbar,
  IonList,
  IonItem,
  IonLabel,
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonSearchbar,
  IonRefresher,
  IonRefresherContent,
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import { chevronDownCircleOutline, cameraOutline, cameraSharp } from 'ionicons/icons';
import { searchStorageLocation } from '@/api';
import PartOverview from '@/views/Part.vue';
import { errorDisplay } from '@/composables/errorDisplay';

export default defineComponent({
  name: 'StorageSearchView',
  components: {
    IonContent,
    IonHeader,
    IonPage,
    IonToolbar,
    IonList,
    IonItem,
    IonLabel,
    IonInfiniteScroll,
    IonInfiniteScrollContent,
    IonSearchbar,
    IonRefresher,
    IonRefresherContent,
  },
  props: {
    /**
     * Set to `true` in order to use the search for selecting a part or storage location
     */
    selectOnly: Boolean,
  },
  methods: {
    storageSelected(id: string) {
      if (!this.selectOnly) {
        this.$router.push(`/storage/${id}`);
      }
      this.$emit('storage-selected', id);
    },
    scanQRCode() {
      this.$emit('scan-qr');
    },
    async doSearch(clear?: boolean) {
      if (clear) {
        this.searchResult = [];
      }
      try {
        const res = await searchStorageLocation(this.searchTerm, this.searchResult.length, this.pageSize);
        this.stillScrolling = res.length > 0;
        this.searchResult.push(...res);
      } catch (err) {
        this.showError(this.t((err as Error).message));
      }
    },
    async paginate(ev: CustomEvent) {
      await this.doSearch();
      const target = ev.target as any;
      target.complete();
    },
    async refresh(ev: CustomEvent) {
      await this.doSearch(true);
      const target = ev.target as any;
      target.complete();
    },
  },
  mounted() {
    this.$nextTick(function () {
      this.doSearch(true);
    })
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const searchResult = ref(([] as StorageLocation[]));
    const searchTerm = ref("");
    const stillScrolling = ref(true);
    const pageSize = ref(20);

    return {
      t,
      showError,
      dismissError,
      searchResult,
      searchTerm,
      stillScrolling,
      pageSize,
      chevronDownCircleOutline,
      PartOverview,
      cameraSharp,
      cameraOutline,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
  loading: 'Lade...'
  pullingText: 'Ziehen zum neu laden...'
  btn:
    dismiss: Schließen
    back: Suche
    cancel: Abbrechen
  search:
    placeholder: 'Lagerort suchen...'
    parts: 'Teile'
    locations: 'Lager'
</i18n>
<i18n locale="en" lang="yaml">
  loading: 'Loading...'
  pullingText: 'Pull to reload...'
  btn:
    dismiss: Close
    back: Search
    cancel: Cancel
  search:
    placeholder: 'Search for storage locations...'
    parts: 'Parts'
    locations: 'Storage'
</i18n>

<style scoped>
#container {
  text-align: center;
  position: absolute;
  left: 0;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
}

#container strong {
  font-size: 20px;
  line-height: 26px;
}

#container p {
  font-size: 16px;
  line-height: 22px;
  color: #8c8c8c;
  margin: 0;
}

#container a {
  text-decoration: none;
}

.storage {
  background-color: rgba(46, 91, 216, 0.4);
  font-weight: normal;
  font-style: italic;
}
</style>
