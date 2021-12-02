<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button defaultHref="/search"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="primary">
          <ion-button @click="scanBarcode()">
            <ion-icon slot="icon-only" :icon="addSharp"></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen> </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { Part } from '@/models/part';
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
} from '@ionic/vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { addSharp } from 'ionicons/icons';
import { BarcodeScanner } from '@ionic-native/barcode-scanner/ngx'

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
  },
  props: {
    parent: Part,
  },
  methods: {
    async scanBarcode() {
      const data = await this.barcodeScanner.scan();
      console.log('Data: ', data);
    }
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })

    const barcodeScanner = new BarcodeScanner();

    return {
      t,
      addSharp,
      barcodeScanner,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Verknüpfungen
</i18n>
<i18n locale="en" lang="yaml">
title: Links
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
