<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="end">
          <ion-button @click="onCloseClick">{{ t("close") }}</ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="true">
      <div id="qrScanRegion"></div>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import {
  IonPage,
  IonHeader,
  IonToolbar,
  IonButtons,
  IonTitle,
  IonContent,
  IonButton,
  IonModal,
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { Html5Qrcode } from 'html5-qrcode';

export default defineComponent({
  name: 'ScanView',
  components: {
    IonPage,
    IonHeader,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonContent,
    IonButton,
  },
  mounted() {
    const config = {
      fps: 10,
      qrbox: 300,
    }
    const scanner = new Html5Qrcode('qrScanRegion', false);
    scanner.start({ facingMode: "environment" }, config, this.onScanSuccess, undefined);
    this.scanner = scanner;
  },
  methods: {
    onScanSuccess(decodedText: string, decodedResult: any) {
      this.$emit('scan-result', decodedText, decodedResult);
      const scanner = (this.scanner as Html5Qrcode);
      scanner.stop();
    },
    onCloseClick() {
      this.$emit('scan-cancel');
      const scanner = (this.scanner as Html5Qrcode);
      scanner.stop();
    }
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    });

    const scanner = ref({});

    return {
      t,
      scanner,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Scannen
close: Abbrechen
</i18n>
<i18n locale="en" lang="yaml">
title: Scan
close: Cancel
</i18n>

<style scoped>
</style>
