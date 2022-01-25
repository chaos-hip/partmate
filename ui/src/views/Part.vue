<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ part ? part.name : "" }}</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-grid :fixed="true">
        <ion-row>
          <ion-col size="12" size-sm="8" size-md="6" size-xl="5">
            <ion-card v-if="!loading && part">
              <img :src="part.getThumbnailPath()" class="partPreview" />
              <ion-card-header>
                <ion-card-subtitle color="primary">{{
                  part.storage.name
                }}</ion-card-subtitle>
                <ion-card-title>{{ part.name }}</ion-card-title>
                <p>{{ part.description }}</p>
              </ion-card-header>
              <ion-card-content class="comment">
                {{ part.comment }}
              </ion-card-content>
              <ion-item
                detail
                :lines="
                  $store.state.user &&
                  $store.state.user.can(Permission.LinkRead)
                    ? 'full'
                    : 'none'
                "
                @click="$router.push(`/part/${partId}/attachments`)"
                v-if="
                  $store.state.user &&
                  $store.state.user.can(Permission.PartAttachmentRead)
                "
              >
                <ion-icon slot="start" :icon="documentsSharp"></ion-icon>
                <ion-label>{{ t("part.attachments") }}</ion-label>
                <ion-note slot="end" color="medium">
                  {{ part.attachmentCount }}
                </ion-note>
              </ion-item>
              <ion-item
                detail
                lines="none"
                @click="$router.push(`/link/${partId}/links`)"
                v-if="
                  $store.state.user &&
                  $store.state.user.can(Permission.LinkRead)
                "
              >
                <ion-icon slot="start" :icon="linkSharp"></ion-icon>
                <ion-label>{{ t("part.links") }}</ion-label>
              </ion-item>
            </ion-card>
          </ion-col>
        </ion-row>
      </ion-grid>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { Part } from '@/models/part';
import { Permission } from '@/models/user';
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
  IonLoading,
  IonIcon,
  isPlatform,
  IonMenuButton,
  IonCol,
  IonRow,
  IonGrid,
  IonNote,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { documentsSharp, linkSharp } from 'ionicons/icons';
import { getPartById } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';

export default defineComponent({
  name: 'part-overview',
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
    IonLoading,
    IonIcon,
    IonMenuButton,
    IonCol,
    IonRow,
    IonGrid,
    IonNote,
  },
  props: {
    id: String,
    backButtonLabel: String,
  },
  mounted() {
    this.$nextTick(function () {
      this.loadPart();
    });
  },
  computed: {
    partId() {
      return this.id || this.$route.params.id || '';
    }
  },
  methods: {
    async loadPart() {
      this.part = null;
      if (!this.partId) {
        return;
      }
      this.loading = true;
      try {
        const p = await getPartById(this.partId as string);
        (this.part as unknown) = p;
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      this.loading = false;
    },
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const part: Ref<Part> | Ref<null> = ref(null);
    const loading = ref(false);

    return {
      t,
      showError,
      dismissError,
      documentsSharp,
      linkSharp,
      isPlatform,
      part,
      loading,
      Permission,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
loading: Lade...
part:
    new: Neues Teil
    subtitle: Teil
    attachments: Dateien
    links: Links
err:
  load: Teileinfo konnte nicht geladen werden
</i18n>
<i18n locale="en" lang="yaml">
loading: Loading...
part:
    new: 'New Part'
    subtitle: 'Part'
    attachments: 'Files'
    links: 'Links'
err:
  load: Failed to load part information
</i18n>

<style scoped>
.partPreview {
  width: 100%;
  object-fit: cover;
}

.comment {
  white-space: pre-line;
}

ion-card ion-item {
  --background: transparent;
}
</style>
