<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ t("title") }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content :fullscreen="true">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">FOO</ion-title>
        </ion-toolbar>
      </ion-header>
      <ion-list>
        <ion-item v-for="part in searchResult" :key="part.id">
          <ion-thumbnail slot="start">
            <img
              src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAAAAACH5BAAAAAAALAAAAAABAAEAAAICTAEAOw=="
            />
          </ion-thumbnail>
          <ion-label>
            {{ part.name }}
          </ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { Part } from '@/models/part';
import {
  IonButtons,
  IonContent,
  IonHeader,
  IonMenuButton,
  IonPage,
  IonTitle,
  IonToolbar,
  IonList,
  IonItem,
  IonThumbnail,
  IonLabel,
  toastController
} from '@ionic/vue';
import { defineComponent, ref } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { searchParts } from '../api';

export default defineComponent({
  name: 'Folder',
  components: {
    IonButtons,
    IonContent,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonTitle,
    IonToolbar,
    IonList,
    IonItem,
    IonThumbnail,
    IonLabel,
  },
  methods: {
    async doSearch() {
      try {
        this.searchResult = await searchParts("");
      } catch (err) {
        this.showError(this.t('err.search'), this.t((err as Error).message));
      }
    },
    async showError(title: string, message: string) {
      const toast = await toastController.create({
        header: title,
        message: message,
        position: 'middle',
        color: 'danger',
        buttons: [
          {
            text: this.t('btn.dismiss'),
          }
        ]
      });
      await toast.present();
    },
  },
  mounted() {
    this.doSearch();
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local'
    })

    const searchResult = ref(([] as Part[]));

    return {
      t,
      searchResult,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
  title: 'Suche'
</i18n>
<i18n locale="en" lang="yaml">
  title: 'Search'
</i18n>

<style scoped>
#container {
  text-align: center;
  position: absolute;
  left: 0;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
}

#container strong {
  font-size: 20px;
  line-height: 26px;
}

#container p {
  font-size: 16px;
  line-height: 22px;
  color: #8c8c8c;
  margin: 0;
}

#container a {
  text-decoration: none;
}
</style>
