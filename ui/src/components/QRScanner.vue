<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="end">
          <ion-button @click="onCloseClick">{{ t("btn.close") }}</ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="false">
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
  loadingController,
  toastController,
  IonicSafeString,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { alertCircleOutline } from 'ionicons/icons';
import { Html5Qrcode } from 'html5-qrcode';
import { getLinkInfo } from '@/api';

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
    (this.scanner as unknown) = scanner;
  },
  beforeUnmount() {
    this.$emit('scan-cancel');
    this.stopScanning();
  },
  methods: {
    getLinkId(link: string): string {
      const arr = (/([a-z0-9]+)\/?$/i).exec(link);
      return (arr && arr.length > 1) ? arr[1] : '';
    },
    stopScanning() {
      if (this.scanner !== null) {
        (this.scanner as Html5Qrcode).stop();
        this.scanner = null;
      }
    },
    async onScanSuccess(decodedText: string) {
      if (this.waitingForResult) {
        return;
      }
      this.waitingForResult = true;
      const loading = await loadingController.create({
        message: this.t('link.loading'),
      });
      await loading.present();
      try {
        const link = await getLinkInfo(this.getLinkId(decodedText));
        this.stopScanning();
        this.$emit('scan-result', link);
      } catch (err) {
        const toast = await toastController.create({
          header: this.t('err.loadLinkInfo'),
          message: new IonicSafeString(String(err)),
          position: 'bottom',
          icon: alertCircleOutline,
          color: 'danger',
          buttons: [
            {
              side: 'end',
              text: this.t('btn.dismiss'),
              handler: () => {
                toast.dismiss();
              }
            }
          ],
        });
        await toast.present();
      }
      loading.dismiss();
      this.waitingForResult = false;
    },
    onCloseClick() {
      this.$emit('scan-cancel');
      this.stopScanning();
    }
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local',
    });

    const scanner: Ref<null> | Ref<Html5Qrcode> = ref(null);
    const waitingForResult = ref(false);

    return {
      t,
      scanner,
      waitingForResult,
      alertCircleOutline,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Scannen
btn:
  close: Abbrechen
  dismiss: Schließen
link:
  loading: Lade...
err:
  loadLinkInfo: Fehler beim Laden der Link-Infos
</i18n>
<i18n locale="en" lang="yaml">
title: Scan
btn:
  close: Cancel
  dismiss: Schließen
link:
  loading: Loading...
err:
  loadLinkInfo: Error while loading link infos
</i18n>

<style scoped>
#qrScanRegion {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-content: center;
  align-items: center;
  flex-wrap: nowrap;
}
</style>
