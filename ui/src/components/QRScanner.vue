<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="end">
          <ion-button @click="onCloseClick">{{ t("btn.close") }}</ion-button>
        </ion-buttons>
        <ion-buttons slot="start">
          <ion-button @click="onScanFromFileClick">
            <ion-icon :icon="documentOutline"> </ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="false">
      <div id="qrScanRegion"></div>
      <input
        type="file"
        id="qrFileInput"
        accept="image/*"
        @change="onFileChosen"
      />
      <ion-item>
        <ion-label position="fixed">{{ t("label.manualEntry") }}</ion-label>
        <ion-input
          autofocus
          clear-input
          required
          id="qrManualInput"
          v-model="enteredString"
          @keyup="onKeyUp"
        ></ion-input>
      </ion-item>
      <ion-button
        expand="block"
        @click="onScanSuccess(enteredString)"
        v-if="enteredString.trim() != ''"
      >
        {{ t("btn.manualCommit") }}
      </ion-button>
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
  IonIcon,
  IonItem,
  IonLabel,
  IonInput,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { alertCircleOutline, documentOutline } from 'ionicons/icons';
import { Html5Qrcode } from 'html5-qrcode';
import { getLinkInfo } from '@/api';
import { Html5QrcodeCameraScanConfig } from 'html5-qrcode/esm/html5-qrcode';

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
    IonIcon,
    IonItem,
    IonLabel,
    IonInput,
  },
  mounted() {
    this.$nextTick(function () {
      this.startScanning();
    });
  },
  beforeUnmount() {
    this.$emit('scan-cancel');
    this.stopScanning();
  },
  methods: {
    async startScanning() {
      (document.querySelector('#qrManualInput') as HTMLInputElement).focus();
      const config: Html5QrcodeCameraScanConfig = {
        fps: 10,
        qrbox: 300,
      }
      const scanner = new Html5Qrcode('qrScanRegion', false);
      try {
        await scanner.start({ facingMode: "environment" }, config, this.onScanSuccess, undefined);
      } catch (err) {
        const toast = await toastController.create({
          header: this.t('err.startScanning'),
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
      (this.scanner as unknown) = scanner;
    },
    /**
     * Tries to scan the code from a file provided by the user
     */
    onScanFromFileClick() {
      const input = document.querySelector('#qrFileInput') as HTMLInputElement;
      input.click();
    },
    async onFileChosen(ev: CustomEvent) {
      const input = ev.target as HTMLInputElement;
      if (!input.files || input.files.length == 0 || !this.scanner) {
        // Nothing selected
        return;
      }
      const scanner = (this.scanner as Html5Qrcode);
      try {
        scanner.stop();
        const decodedText = await scanner.scanFile(input.files[0]);
        this.onScanSuccess(decodedText);
      } catch (err) {
        this.scanner = null;
        const toast = await toastController.create({
          message: this.t('err.scanFromFile'),
          position: 'bottom',
          icon: alertCircleOutline,
          color: 'danger',
          duration: 2000,
        });
        await toast.present();
        this.startScanning();
      }
    },
    getLinkId(link: string): string {
      const arr = (/([a-z0-9]+)\/?$/i).exec(link);
      return (arr && arr.length > 1) ? arr[1] : '';
    },
    async stopScanning() {
      if (this.scanner !== null) {
        try {
          await (this.scanner as Html5Qrcode).stop();
        } catch (err) {
          // Do nothing
        }
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
    },
    onKeyUp(ev: KeyboardEvent) {
      if (ev.key == 'Enter') {
        this.onScanSuccess(this.enteredString.trim());
      }
    },
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local',
    });

    const scanner: Ref<null> | Ref<Html5Qrcode> = ref(null);
    const waitingForResult = ref(false);
    const enteredString = ref("");

    return {
      t,
      scanner,
      waitingForResult,
      enteredString,
      alertCircleOutline,
      documentOutline,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Scannen
btn:
  close: Abbrechen
  dismiss: Schließen
  manualCommit: Manelle Eingabe
link:
  loading: Lade...
err:
  loadLinkInfo: Fehler beim Laden der Link-Infos
  startScanning: Konnte Scanner nicht starten
  scanFromFile: Im Bild wurde kein Code gefunden
label:
  manualEntry: Code
</i18n>
<i18n locale="en" lang="yaml">
title: Scan
btn:
  close: Cancel
  dismiss: Schließen
  manualCommit: Manelle entry
link:
  loading: Loading...
err:
  loadLinkInfo: Error while loading link infos
  startScanning: Failed to start scanner
  scanFromFile: No code found in file
label:
  manualEntry: Code
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

#qrFileInput {
  display: block;
  opacity: 0;
}
</style>
