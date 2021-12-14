<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="end">
          <ion-button @click="scanQRCode()">
            <ion-icon
              slot="icon-only"
              :ios="cameraOutline"
              :md="cameraSharp"
            ></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
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
      </ion-toolbar>
    </ion-header>

    <ion-content :fullscreen="true">
      <ion-modal
        :is-open="qrModalIsOpen"
        @onDidDismiss="handleScanCancel"
        keyboard-close
      >
        <scan-view
          @scanCancel="handleScanCancel"
          @scanResult="handleScanResult"
        ></scan-view>
      </ion-modal>
      <ion-refresher
        slot="fixed"
        @ionRefresh="refresh($event)"
        id="gallery-refresher"
      >
        <ion-refresher-content
          :pulling-icon="chevronDownCircleOutline"
          pulling-text="Ziehen zum neu laden..."
          refreshing-spinner="circles"
          refreshing-text="Lade..."
        ></ion-refresher-content>
      </ion-refresher>
      <ion-list>
        <ion-nav-link
          v-for="part in searchResult"
          :key="part.id"
          :component="PartOverview"
          :component-props="{ part: part }"
        >
          <ion-item lines="inset" button detail>
            <ion-thumbnail slot="start">
              <img :src="part.getThumbnailPath()" />
            </ion-thumbnail>
            <ion-label>
              <h2>{{ part.name }}</h2>
              <p>{{ part.description }}</p>
              <ion-badge color="tertiary" class="storage">
                {{ part.storage.name }}
              </ion-badge>
            </ion-label>
            <ion-badge
              slot="end"
              :color="part.lowStock ? 'danger' : 'medium'"
              >{{ part.stockLevel }}</ion-badge
            >
          </ion-item>
        </ion-nav-link>
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
import { Part } from '@/models/part';
import {
  IonButtons,
  IonContent,
  IonHeader,
  IonMenuButton,
  IonPage,
  IonTitle,
  IonToolbar,
  IonList,
  IonItem,
  IonThumbnail,
  IonLabel,
  toastController,
  IonBadge,
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonSearchbar,
  IonRefresher,
  IonRefresherContent,
  IonNavLink,
  IonIcon,
  IonButton,
  IonModal,
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { chevronDownCircleOutline, cameraOutline, cameraSharp } from 'ionicons/icons';
import { searchParts } from '../api';
import PartOverview from '@/components/PartOverview.vue';
import ScanView from '@/components/QRScanner.vue';

export default defineComponent({
  name: 'SearchComponent',
  components: {
    IonButtons,
    IonContent,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonTitle,
    IonToolbar,
    IonList,
    IonItem,
    IonThumbnail,
    IonLabel,
    IonBadge,
    IonInfiniteScroll,
    IonInfiniteScrollContent,
    IonSearchbar,
    IonRefresher,
    IonRefresherContent,
    IonNavLink,
    IonIcon,
    IonButton,
    IonModal,
    ScanView,
  },
  methods: {
    scanQRCode() {
      this.qrModalIsOpen = true;
    },
    handleScanCancel() {
      this.qrModalIsOpen = false;
    },
    handleScanResult(text: string, result: any) {
      this.qrModalIsOpen = false;
      console.dir(text);
    },
    async doSearch(clear?: boolean) {
      if (clear) {
        this.searchResult = [];
      }
      try {
        const res = await searchParts(this.searchTerm, this.searchResult.length, this.pageSize);
        this.stillScrolling = res.length > 0;
        this.searchResult.push(...res);
      } catch (err) {
        this.showError(this.t('err.search'), this.t((err as Error).message));
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
  mounted() {
    this.doSearch(true);
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })

    const searchResult = ref(([] as Part[]));
    const searchTerm = ref("");
    const stillScrolling = ref(true);
    const pageSize = ref(20);

    const qrModalIsOpen = ref(false);

    return {
      t,
      searchResult,
      searchTerm,
      stillScrolling,
      pageSize,
      chevronDownCircleOutline,
      PartOverview,
      cameraSharp,
      cameraOutline,
      qrModalIsOpen,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
  title: 'Suche'
  loading: 'Lade...'
  search:
    placeholder: 'Nach Teilen suchen...'
    parts: 'Teile'
    locations: 'Lager'
</i18n>
<i18n locale="en" lang="yaml">
  title: 'Search'
  loading: 'Loading...'
  search:
    placeholder: 'Search for parts...'
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
