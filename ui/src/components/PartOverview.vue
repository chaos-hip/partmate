<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            defaultHref="/search"
            :text="isPlatform('ios') ? t('back') : ''"
          ></ion-back-button>
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
        <ion-item detail lines="full">
          <ion-icon slot="start" :icon="documentsSharp"></ion-icon>
          <ion-label>{{ t("part.attachments") }}</ion-label>
        </ion-item>
        <ion-nav-link
          :component="PartLinkOverview"
          :component-props="{ parent: part }"
        >
          <ion-item detail lines="none">
            <ion-icon slot="start" :icon="linkSharp"></ion-icon>
            <ion-label>{{ t("part.links") }}</ion-label>
          </ion-item>
        </ion-nav-link>
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
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardTitle,
  IonCardSubtitle,
  IonItem,
  IonLabel,
  IonNavLink,
  isPlatform,
} from '@ionic/vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { documentsSharp, linkSharp } from 'ionicons/icons';
import PartLinkOverview from '@/components/PartLinkOverview.vue';

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
    IonCard,
    IonCardContent,
    IonCardHeader,
    IonCardTitle,
    IonCardSubtitle,
    IonItem,
    IonLabel,
    IonNavLink,
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
      documentsSharp,
      linkSharp,
      isPlatform,
      PartLinkOverview,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
back: Suche
part:
    new: 'Neues Teil'
    subtitle: 'Teil'
    attachments: 'Dateien'
    links: 'Verknüpfungen'
</i18n>
<i18n locale="en" lang="yaml">
back: Search
part:
    new: 'New Part'
    subtitle: 'Part'
    attachments: 'Files'
    links: 'Links'
</i18n>

<style scoped>
.partPreview {
  width: 100%;
  height: auto;
  object-fit: cover;
}

ion-card ion-item {
  --background: transparent;
}
</style>
