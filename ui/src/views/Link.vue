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
      <ion-card>
        <ion-card-header>
          <ion-card-subtitle>{{ t("title") }}</ion-card-subtitle>
          <ion-card-title>{{ linkId }}</ion-card-title>
        </ion-card-header>
        <ion-card-content>
          <h2 color="primary">{{ t("card.header") }}</h2>
          <p>{{ t("card.main1") }}</p>
          <p>{{ t("card.main2") }}</p>
        </ion-card-content>
        <ion-item lines="full" @click="doSelect(LinkType.Part)" button>
          <ion-icon slot="start" :icon="hardwareChipOutline"></ion-icon>
          <ion-label>{{ t("option.part") }}</ion-label>
        </ion-item>
        <ion-item
          lines="none"
          @click="doSelect(LinkType.StorageLocation)"
          button
        >
          <ion-icon slot="start" :icon="cubeOutline"></ion-icon>
          <ion-label>{{ t("option.storage") }}</ion-label>
        </ion-item>
      </ion-card>
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
  IonCard,
  IonCardHeader,
  IonCardTitle,
  IonCardSubtitle,
  IonCardContent,
  IonIcon,
  IonLabel,
  IonItem,
} from '@ionic/vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { hardwareChipOutline, cubeOutline } from 'ionicons/icons';
import { LinkType } from '@/models/link';

export default defineComponent({
  name: 'LinkView',
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
    IonCardContent,
    IonIcon,
    IonLabel,
    IonItem,
  },
  computed: {
    linkId() {
      return this.$route.params.id || '';
    }
  },
  methods: {
    doSelect(linkType: string) {
      console.dir(linkType);
    }
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })

    return {
      t,
      hardwareChipOutline,
      cubeOutline,
      LinkType,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Link
card:
  header: Dieser Link wurde noch nicht verwendet.
  main1: Du kannst ihn mit einem Element in PartMATE verknüpfen.
  main2: "Bitte wähle ein Ziel:"
option:
  part: Gegenstand
  storage: Lagerort
</i18n>
<i18n locale="en" lang="yaml">
title: Link
card:
  header: This link is not being used yet.
  main1: You can connect it to an entity within PartMATE.
  main2: "Please choose a target:"
option:
  part: Gegenstand
  storage: Lagerort
</i18n>

<style scoped>
ion-card > ion-item {
  --background: transparent;
}
</style>
