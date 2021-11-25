<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button defaultHref="/search"></ion-back-button>
        </ion-buttons>
        <ion-title>{{ part.name }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-card>
        <img :src="part.getThumbnailPath()" class="partPreview" />
        <ion-card-header>
          <ion-card-subtitle color="primary">{{
            part.storage.name
          }}</ion-card-subtitle>
          <ion-card-title>{{ part.name }}</ion-card-title>
          <p>{{ part.description }}</p>
        </ion-card-header>
        <ion-card-content>
          {{ part.comment }}
        </ion-card-content>
      </ion-card>
    </ion-content>
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
} from '@ionic/vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';

export default defineComponent({
  name: 'PartOverview',
  components: {
    IonPage,
    IonToolbar,
    IonButtons,
    IonTitle,
    IonHeader,
    IonBackButton,
    IonContent,
  },
  props: {
    part: Part,
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
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
part:
    new: 'Neues Teil'
    subtitle: 'Teil'
</i18n>
<i18n locale="en" lang="yaml">
part:
    new: 'New Part'
    subtitle: 'Part'
</i18n>

<style scoped>
.partPreview {
  width: 100%;
  height: auto;
  object-fit: cover;
}
</style>
