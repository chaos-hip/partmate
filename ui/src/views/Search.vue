<template>
  <ion-page>
    <ion-toolbar>
      <ion-buttons slot="start" v-if="!selectOnly">
        <ion-menu-button color="primary"></ion-menu-button>
      </ion-buttons>
      <ion-title>
        {{ t("title") }}
      </ion-title>
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
    <ion-tabs @ionTabsDidChange="afterTabChange">
      <ion-router-outlet></ion-router-outlet>

      <ion-tab-bar slot="bottom">
        <ion-tab-button tab="parts" href="/search/parts">
          <ion-icon :icon="hardwareChipOutline"></ion-icon>
          <ion-label>{{ t("tab.parts") }}</ion-label>
        </ion-tab-button>
        <ion-tab-button tab="storage" href="/search/storage">
          <ion-icon :icon="cubeOutline"></ion-icon>
          <ion-label>{{ t("tab.storage") }}</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  </ion-page>
</template>

<script lang="ts">
import { Part } from '@/models/part';
import {
  IonPage,
  IonTabs,
  IonTabBar,
  IonToolbar,
  IonTabButton,
  IonIcon,
  IonLabel,
  IonRouterOutlet,
  IonModal,
  IonButton,
  IonTitle,
  IonButtons,
  IonMenuButton,
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import {
  hardwareChipOutline,
  cubeOutline,
  cameraOutline,
  cameraSharp,
} from 'ionicons/icons';
import PartOverview from '@/views/Part.vue';
import ScanView from '@/components/QRScanner.vue';
import { LinkInfo, navigateToLink } from '@/models/link';
import { errorDisplay } from '@/composables/errorDisplay';

export default defineComponent({
  name: 'SearchView',
  components: {
    IonPage,
    IonTabs,
    IonToolbar,
    IonTabBar,
    IonTabButton,
    IonIcon,
    IonLabel,
    IonRouterOutlet,
    IonModal,
    IonButton,
    IonTitle,
    IonButtons,
    IonMenuButton,
    ScanView,
  },
  props: {
    /**
     * Set to `true` in order to use the search for selecting a part or storage location
     */
    selectOnly: Boolean,
  },
  methods: {
    afterTabChange(...rest: any[]) {
      console.dir(rest);
    },
    scanQRCode() {
      this.qrModalIsOpen = true;
    },
    handleScanCancel() {
      this.qrModalIsOpen = false;
    },
    handleScanResult(link: LinkInfo) {
      this.qrModalIsOpen = false;
      navigateToLink(link);
    },
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const searchResult = ref(([] as Part[]));
    const searchTerm = ref("");
    const stillScrolling = ref(true);
    const pageSize = ref(20);

    const qrModalIsOpen = ref(false);

    return {
      t,
      showError,
      dismissError,
      hardwareChipOutline,
      cubeOutline,
      cameraOutline,
      cameraSharp,
      searchResult,
      searchTerm,
      stillScrolling,
      pageSize,
      PartOverview,
      qrModalIsOpen,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
  title: Suche
  tab:
    parts: Teile
    storage: Lager
</i18n>
<i18n locale="en" lang="yaml">
  title: Search
  tab:
    parts: Parts
    storage: Storage
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
