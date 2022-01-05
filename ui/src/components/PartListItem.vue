<template>
  <ion-item lines="inset" button>
    <ion-thumbnail slot="start">
      <img :src="part.getThumbnailPath()" />
    </ion-thumbnail>
    <ion-label>
      <h2>{{ part.name }}</h2>
      <p>{{ part.description }}</p>
      <ion-badge color="tertiary" class="storage" v-if="part.storage">
        {{ part.storage.name }}
      </ion-badge>
    </ion-label>
    <ion-badge slot="end" :color="part.lowStock ? 'danger' : 'medium'">
      {{ part.stockLevel }}
    </ion-badge>
  </ion-item>
</template>

<script lang="ts">
import {
  IonItem,
  IonThumbnail,
  IonLabel,
  IonBadge
} from '@ionic/vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';
import { Part } from '@/models/part';

export default defineComponent({
  name: 'PartListItem',
  components: {
    IonItem,
    IonThumbnail,
    IonLabel,
    IonBadge
  },
  props: {
    part: Part,
  },
  setup() {
    const { t } = useI18n({
      inheritLocale: true,
      useScope: 'local',
    });

    return {
      t,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
</i18n>
<i18n locale="en" lang="yaml">
</i18n>

<style scoped>
.storage {
  background-color: rgba(46, 91, 216, 0.4);
  font-weight: normal;
  font-style: italic;
}
</style>
