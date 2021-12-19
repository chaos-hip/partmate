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
      <ion-modal
        :is-open="searchModalOpen"
        @onDidDismiss="handleSearchCancel"
        keyboard-close
      >
        <search-view
          :selectOnly="true"
          @partSelected="handleSelect"
          @cancelled="handleSearchCancel"
        ></search-view>
      </ion-modal>
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
  IonModal,
  toastController,
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import { hardwareChipOutline, cubeOutline, linkOutline } from 'ionicons/icons';
import { LinkType } from '@/models/link';
import SearchView from '@/views/Search.vue';
import { errorDisplay } from '@/composables/errorDisplay';
import { createLink } from '@/api';

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
    IonModal,
    SearchView,
  },
  computed: {
    linkId() {
      return (this.$route.params.id as string) || '';
    }
  },
  methods: {
    doSelect(linkType: LinkType) {
      this.searchModalOpen = true;
      this.searchedLinkType = linkType;
    },
    handleSearchCancel() {
      this.searchModalOpen = false;
    },
    async handleSelect(selectedTarget: string) {
      this.searchModalOpen = false;
      try {
        await createLink(this.linkId, this.searchedLinkType, selectedTarget);
        const toast = await toastController.create({
          message: this.t('msg.linkCreated'),
          position: 'bottom',
          icon: linkOutline,
          color: 'success',
          duration: 1000,
        });
        await toast.present();
        // Move to the location of the new link
        switch (this.searchedLinkType) {
          case LinkType.Part:
            this.$router.replace(`/part/${this.linkId}`);
            break;
          case LinkType.StorageLocation:
            this.$router.replace(`/storage/${this.linkId}`);
            break;
        }
      } catch (err) {
        this.showError(String(err), 'err.createLinkFailed');
      }
    },
  },
  setup() {
    const { t, showError } = errorDisplay();

    const searchModalOpen = ref(false);
    const searchedLinkType = ref(LinkType.Part);

    return {
      t,
      showError,
      hardwareChipOutline,
      cubeOutline,
      LinkType,
      searchModalOpen,
      searchedLinkType,
      linkOutline,
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
err:
  createLinkFailed: Link erstellen fehlgeschlagen
msg:
  linkCreated: Link erfolgreich zugewiesen
btn:
  dismiss: Verwerfen
'Error: A link with the given ID does already exist': |
  Dieser Link wurde bereits für ein anderes Element verwendet.
'Error: Target validation failed': |
  Ziel konnte nicht gefunden werden.
</i18n>
<i18n locale="en" lang="yaml">
title: Link
card:
  header: This link is not being used yet.
  main1: You can connect it to an entity within PartMATE.
  main2: "Please choose a target:"
option:
  part: Part
  storage: Storage location
err:
  createLinkFailed: Failed to create link
msg:
  linkCreated: Link created successfully
btn:
  dismiss: Dismiss
'Error: A link with the given ID does already exist': |
  This link was already used for a different entity.
'Error: Target validation failed': |
  Target could not be found.
</i18n>

<style scoped>
ion-card > ion-item {
  --background: transparent;
}
</style>
