<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ part ? part.name : "" }}</ion-title>
        <ion-buttons slot="end">
          <ion-button @click="showOptions()">
            <ion-icon
              slot="icon-only"
              :ios="ellipsisHorizontal"
              :md="ellipsisVertical"
            ></ion-icon>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-modal
      :is-open="searchModalOpen"
      @onDidDismiss="handleSearchCancel"
      keyboard-close
    >
      <storage-search-view
        :selectOnly="true"
        :enableQR="true"
        @storageSelected="handleSelect"
        @cancelled="handleSearchCancel"
        @scanQr="handleScanRequest"
      ></storage-search-view>
    </ion-modal>
    <ion-modal
      :is-open="qrModalIsOpen"
      @onDidDismiss="handleScanCancel"
      keyboard-close
    >
      <scan-view
        @scanCancel="handleScanCancel"
        @scanResult="handleScanResult"
      ></scan-view>
    </ion-modal>
    <ion-content fullscreen>
      <ion-grid :fixed="true">
        <ion-row>
          <ion-col size="12" size-sm="8" size-md="6" size-xl="5">
            <ion-card v-if="!loading && part">
              <img :src="part.getThumbnailPath()" class="partPreview" />
              <ion-card-header>
                <ion-card-subtitle color="primary">
                  {{ part.storage.name }}
                </ion-card-subtitle>
                <ion-card-title>
                  {{ part.name }}
                </ion-card-title>
                <p>
                  {{ part.description }}
                </p>
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
import { getPartById, movePart } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { LinkInfo, LinkType } from '@/models/link';
import { Part } from '@/models/part';
import { Permission } from '@/models/user';
import StorageSearchView from '@/views/StorageSearch.vue';
import ScanView from '@/components/QRScanner.vue';
import {
  actionSheetController,
  IonBackButton,
  IonButton,
  IonButtons,
  IonCard,
  IonCardContent,
  IonCardHeader,
  IonCardSubtitle,
  IonCardTitle,
  IonCol,
  IonContent,
  IonGrid,
  IonHeader,
  IonIcon,
  IonItem,
  IonLabel,
  IonLoading,
  IonMenuButton,
  IonModal,
  IonNote,
  IonPage,
  IonRow,
  IonTitle,
  IonToolbar,
  isPlatform,
  toastController
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { documentsSharp, ellipsisHorizontal, ellipsisVertical, enterOutline, linkSharp, qrCode } from 'ionicons/icons';

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
    IonLoading,
    IonIcon,
    IonMenuButton,
    IonCol,
    IonRow,
    IonGrid,
    IonNote,
    IonButton,
    IonModal,
    StorageSearchView,
    ScanView,
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
    async showOptions() {
      const sheet = await actionSheetController.create({
        header: this.t('actions.title'),
        buttons: [
          {
            text: this.t('actions.move'),
            icon: enterOutline,
            handler: () => {
              this.searchModalOpen = true;
              this.qrModalIsOpen = false;
            }
          },
          {
            text: this.t('actions.moveQR'),
            icon: qrCode,
            handler: () => {
              this.searchModalOpen = false;
              this.qrModalIsOpen = true;
            }
          }
        ],
      });
      await sheet.present();
    },
    handleSearchCancel() {
      this.searchModalOpen = false;
    },
    async handleSelect(selectedTarget: string) {
      this.searchModalOpen = false;
      this.qrModalIsOpen = false;
      if (this.part == null) {
        return;
      }
      const part = (this.part as Part);
      try {
        await movePart(part.id, selectedTarget);
        const toast = await toastController.create({
          message: this.t('msg.partMoved'),
          position: 'bottom',
          icon: enterOutline,
          color: 'success',
          duration: 1000,
        });
        await toast.present();
        await this.loadPart();
      } catch (err) {
        this.showError(String(err), 'err.movePartFailed');
      }
    },
    handleScanRequest() {
      this.searchModalOpen = false;
      this.qrModalIsOpen = true;
    },
    handleScanCancel() {
      this.qrModalIsOpen = false;
    },
    async handleScanResult(link: LinkInfo) {
      this.qrModalIsOpen = false;
      if (link.targetType != LinkType.StorageLocation) {
        this.showError(this.t('err.wrongType'))
        return;
      }
      this.handleSelect(link.link);
    },
  },

  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const part: Ref<Part> | Ref<null> = ref(null);
    const loading = ref(false);

    const searchModalOpen = ref(false);
    const qrModalIsOpen = ref(false);

    return {
      t,
      showError,
      dismissError,
      isPlatform,
      part,
      loading,
      Permission,
      searchModalOpen,
      qrModalIsOpen,
      // Icons
      documentsSharp,
      linkSharp,
      ellipsisHorizontal,
      ellipsisVertical,
      enterOutline,
      qrCode,
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
actions:
  title: Actions
  move: Teil umziehen...
  moveQR: Teil umziehen (via Code)...
msg:
  partMoved: Teil erfolgreich umgezogen
btn:
  dismiss: Schließen
err:
  load: Teileinfo konnte nicht geladen werden
  movePartFailed: Teileumzug fehlgeschlagen
  wrongType: Der gescannte Link verweist nicht auf einen Lagerort
</i18n>
<i18n locale="en" lang="yaml">
loading: Loading...
part:
    new: 'New Part'
    subtitle: 'Part'
    attachments: 'Files'
    links: 'Links'
actions:
  title: Actions
  move: Move part...
  moveQR: Move part (via code)...
msg:
  partMoved: Part moved successfully
btn:
  dismiss: Dismiss
err:
  load: Failed to load part information
  movePartFailed: Failed to move part
  wrongType: Scanned link does not point to a storage location
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
