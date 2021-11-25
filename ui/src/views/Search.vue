<template>
  <ion-page>
    <ion-nav :root="SearchComponent"></ion-nav>
  </ion-page>
</template>

<script lang="ts">
import {
  IonNav,
  IonPage,
} from '@ionic/vue';
import SearchComponent from '@/components/Search.vue';
import { defineComponent } from '@vue/runtime-core';
import { useI18n } from 'vue-i18n';

export default defineComponent({
  name: 'SearchView',
  components: {
    IonPage,
    IonNav,
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
      SearchComponent,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
</i18n>
<i18n locale="en" lang="yaml">
</i18n>

<style scoped>
</style>
