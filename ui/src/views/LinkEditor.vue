<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
        <ion-buttons slot="primary">
          <ion-button>
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
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })

    return {
      t,
      addSharp,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
title: Links
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
