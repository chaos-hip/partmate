<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-text v-if="!loading && attachmentList.length == 0">
        {{ t("msg.emptyResult") }}
      </ion-text>
      <ion-list v-if="attachmentList.length > 0">
        <ion-item-sliding v-for="att in attachmentList" :key="att.id">
          <ion-item lines="full" :href="att.getDownloadLink()" target="_blank">
            <ion-icon
              :icon="getFileIcon(att.mimeType)"
              slot="start"
            ></ion-icon>
            <ion-thumbnail v-if="att.isImage" slot="end">
              <img :src="att.getThumbnailPath()" />
            </ion-thumbnail>
            <ion-label>
              <h2>{{ att.name }}</h2>
              <p>{{ att.description }}</p>
            </ion-label>
          </ion-item>
        </ion-item-sliding>
      </ion-list>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import {
  IonPage,
  IonToolbar,
  IonButtons,
  IonTitle,
  IonHeader,
  IonBackButton,
  IonContent,
  IonIcon,
  IonLoading,
  IonItemSliding,
  IonList,
  IonItem,
  IonText,
  IonLabel,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { documentOutline, documentTextOutline, imageOutline, barChartOutline } from 'ionicons/icons';
import { getAttachmentsByPartLink } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { PartAttachment } from '@/models/attachment';

export default defineComponent({
  name: 'PartAttachmentOverview',
  components: {
    IonPage,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
    IonIcon,
    IonLoading,
    IonItemSliding,
    IonList,
    IonItem,
    IonText,
    IonLabel,
  },
  props: {
    id: String,
  },
  computed: {
    parentPart() {
      return this.id || this.$route.params.id as string || '';
    }
  },
  methods: {
    async reloadData() {
      if (!this.parentPart) {
        return;
      }
      this.loading = true;
      try {
        this.attachmentList = await getAttachmentsByPartLink(this.parentPart);
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      this.loading = false;
    },
    getFileIcon(mime: string): any {
      switch (mime) {
        case "image/png":
        case "image/jpeg":
        case "image/gif":
        case "image/webp":
        case "image/avif":
        case "image/bmp":
          return imageOutline;
        case "application/pdf":
        case "text/text":
        case "text/markdown":
        case "application/xml":
        case "text/xml":
          return documentTextOutline;
        case "application/vnd.ms-excel":
        case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet":
          return barChartOutline;
        default:
          documentOutline;
      }
    },
  },
  mounted() {
    this.$nextTick(function () {
      this.reloadData();
    });
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const attachmentList: Ref<Array<PartAttachment>> = ref([]);
    const loading = ref(false);

    return {
      t,
      dismissError,
      showError,
      attachmentList,
      loading,
      documentOutline,
      documentTextOutline,
      imageOutline,
      barChartOutline,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Dateien
loading: Lade...
msg:
  emptyResult: |
    Dieses Teil hat keine angehängten Dateien
btn:
  dismiss: Schließen
err:
  load: Beim Laden der Daten ist ein Fehler aufgetreten
</i18n>
<i18n locale="en" lang="yaml">
title: Files
loading: Loading...
msg:
  emptyResult: |
    This part has no files attached
btn:
  dismiss: Dismiss
err:
  load: An error ocurred while loading data
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
