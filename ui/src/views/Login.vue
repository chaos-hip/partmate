<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>PartMATE | Login</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="true">
      <ion-card style="max-width: 450px">
        <ion-card-content>
          <form>
            <ion-item>
              <ion-label position="fixed">Benutzer</ion-label>
              <ion-input autofocus clear-input required></ion-input>
            </ion-item>
            <ion-item>
              <ion-label position="fixed">Passwort</ion-label>
              <ion-input
                clear-input
                enterkeyhint="send"
                required
                type="password"
              ></ion-input>
            </ion-item>
            <ion-item>
              <ion-button slot="end" color="primary">Login</ion-button>
            </ion-item>
          </form>
        </ion-card-content>
      </ion-card>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { IonButtons, IonContent, IonHeader, IonMenuButton, IonPage, IonTitle, IonToolbar, IonCard, IonCardContent, IonButton, IonItem, IonLabel, IonInput } from '@ionic/vue';

export default {
  name: 'Folder',
  components: {
    IonButtons,
    IonContent,
    IonHeader,
    IonMenuButton,
    IonPage,
    IonTitle,
    IonToolbar,
    IonCard,
    IonCardContent,
    IonButton,
    IonItem,
    IonLabel,
    IonInput,
  }
}
</script>

<style scoped>
</style>
