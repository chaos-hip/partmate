<template>
  <ion-page>
    <ion-header :translucent="true">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button default-href="/search"></ion-back-button>
          <ion-menu-button color="primary"></ion-menu-button>
        </ion-buttons>
        <ion-title>{{ user ? user.name : "" }}</ion-title>
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
    <ion-content fullscreen>
      <ion-card v-if="!loading && user">
        <ion-card-header>
          <ion-card-title>{{ user.name }}</ion-card-title>
        </ion-card-header>
        <ion-item lines="none" v-if="can(Permission.UserGrantPermissions)">
          <ion-icon slot="start" :icon="skullOutline"></ion-icon>
          <ion-label>{{ t("user.permissions") }}</ion-label>
          <ion-note>{{ user.permissions.size }}</ion-note>
        </ion-item>
      </ion-card>
      <ion-list>
        <ion-list-header>
          <ion-label>{{ t("user.tokens") }}</ion-label>
        </ion-list-header>
        <ion-item v-if="tokens.length == 0" lines="none">{{
          t("token.none")
        }}</ion-item>
        <ion-item-sliding v-for="token in tokens" :key="token.token">
          <ion-item @click="selectedToken = token.token" detail>
            <ion-icon :icon="qrCodeOutline" slot="start"></ion-icon>
            <ion-label>
              <h2>{{ token.token }}</h2>
              <p>
                {{ getValidity(token) }}
              </p>
              <p>
                {{ getSessionLength(token) }}
              </p>
            </ion-label>
          </ion-item>
          <ion-item-options side="end">
            <ion-item-option color="danger" @click="removeToken(token.token)">
              {{ t("btn.delete") }}
            </ion-item-option>
          </ion-item-options>
        </ion-item-sliding>
      </ion-list>
      <ion-loading :is-open="loading" :message="t('loading')"></ion-loading>
      <ion-modal :is-open="selectedToken !== ''">
        <ion-toolbar>
          <ion-title>{{ t("modal.details.title") }}</ion-title>
          <ion-buttons slot="end">
            <ion-button @click="selectedToken = ''">
              {{ t("btn.cancel") }}
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
        <ion-content fullscreen>
          <ion-img
            v-if="selectedToken"
            :src="`/api/tokens/${selectedToken}/qr`"
          ></ion-img>
          <ion-button @click="setClipboard()" expand="block">
            {{ t("modal.details.button") }}
          </ion-button>
        </ion-content>
      </ion-modal>
      <ion-modal :is-open="createModalShowing">
        <ion-toolbar>
          <ion-title>{{ t("modal.new.title") }}</ion-title>
          <ion-buttons slot="end">
            <ion-button @click="createModalShowing = false">
              {{ t("btn.cancel") }}
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
        <ion-content fullscreen>
          <ion-list>
            <ion-item>
              <ion-label position="floating">
                {{ t("modal.new.field.expires") }}
              </ion-label>
              <ion-select v-model="newTokenExpires">
                <ion-select-option value="never">
                  {{ t("modal.new.field.expiry.never") }}
                </ion-select-option>
                <ion-select-option value="today">
                  {{ t("modal.new.field.expiry.today") }}
                </ion-select-option>
                <ion-select-option value="tomorrow">
                  {{ t("modal.new.field.expiry.tomorrow") }}
                </ion-select-option>
                <ion-select-option value="nextWeek">
                  {{ t("modal.new.field.expiry.nextWeek") }}
                </ion-select-option>
                <ion-select-option value="nextMonth">
                  {{ t("modal.new.field.expiry.nextMonth") }}
                </ion-select-option>
                <ion-select-option value="nextYear">
                  {{ t("modal.new.field.expiry.nextYear") }}
                </ion-select-option>
              </ion-select>
            </ion-item>
            <ion-item>
              <ion-label position="floating">
                {{ t("modal.new.field.sessionDuration") }}
              </ion-label>
              <ion-select v-model="newTokenSessionLength">
                <ion-select-option value="3600">
                  {{ t("modal.new.field.session.oneHour") }}
                </ion-select-option>
                <ion-select-option value="5200">
                  {{ t("modal.new.field.session.twoHours") }}
                </ion-select-option>
                <ion-select-option value="10800">
                  {{ t("modal.new.field.session.threeHours") }}
                </ion-select-option>
                <ion-select-option value="14400">
                  {{ t("modal.new.field.session.fourHours") }}
                </ion-select-option>
                <ion-select-option value="18000">
                  {{ t("modal.new.field.session.fiveHours") }}
                </ion-select-option>
                <ion-select-option value="28800">
                  {{ t("modal.new.field.session.eightHours") }}
                </ion-select-option>
                <ion-select-option value="43200">
                  {{ t("modal.new.field.session.twelveHours") }}
                </ion-select-option>
                <ion-select-option value="86400">
                  {{ t("modal.new.field.session.oneDay") }}
                </ion-select-option>
                <ion-select-option value="604800">
                  {{ t("modal.new.field.session.oneWeek") }}
                </ion-select-option>
              </ion-select>
            </ion-item>
          </ion-list>
          <ion-button
            expand="block"
            @click="createToken()"
            :disabled="!newTokenSessionLength || !newTokenExpires"
          >
            {{ t("modal.new.btn.create") }}
          </ion-button>
        </ion-content>
      </ion-modal>
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { Permission, User } from '@/models/user';
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
  IonItem,
  IonLabel,
  IonLoading,
  IonIcon,
  isPlatform,
  IonMenuButton,
  IonList,
  IonButton,
  IonListHeader,
  IonNote,
  IonItemSliding,
  IonModal,
  IonItemOptions,
  IonItemOption,
  actionSheetController,
  IonSelect,
  IonSelectOption,
  IonImg,
} from '@ionic/vue';
import { defineComponent, ref, Ref } from '@vue/runtime-core';
import { skullOutline, linkSharp, ellipsisHorizontal, ellipsisVertical, qrCodeOutline } from 'ionicons/icons';
import { createLoginToken, deleteLoginToken, getLoginTokensForUser, getUserByName } from '@/api';
import { errorDisplay } from '@/composables/errorDisplay';
import { LoginToken } from '@/models/loginToken';

export default defineComponent({
  name: 'UserEditor',
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
    IonItem,
    IonLabel,
    IonLoading,
    IonIcon,
    IonMenuButton,
    IonList,
    IonButton,
    IonListHeader,
    IonNote,
    IonItemSliding,
    IonModal,
    IonItemOptions,
    IonItemOption,
    IonSelect,
    IonSelectOption,
    IonImg,
  },
  props: {
    username: String,
  },
  mounted() {
    this.$nextTick(function () {
      this.reloadData();
    });
  },
  computed: {
    currentUsername() {
      return this.username || this.$route.params.name || '';
    },
    selectedTokenUrl() {
      return this.selectedToken ? `${window.location.protocol}//${window.location.host}/t/${this.selectedToken}` : '';
    },
  },
  methods: {
    currentTimestamp() {
      return (new Date()).toISOString();
    },
    can(permission: Permission) {
      if (!this.$store.state.user) {
        return false;
      }
      return this.$store.state.user.can(permission);
    },
    async reloadData() {
      this.user = null;
      this.tokens = [];
      if (!this.currentUsername) {
        return;
      }
      try {
        const u = await getUserByName(this.currentUsername as string);
        (this.user as unknown) = u;
      } catch (err) {
        this.showError(String(err), 'err.load');
      }
      await this.reloadTokens();
      this.loading = false;
    },
    async reloadTokens() {
      this.tokens = [];
      this.loading = true;
      try {
        this.tokens = await getLoginTokensForUser(this.currentUsername as string);
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
            text: this.t('actions.addToken'),
            icon: qrCodeOutline,
            handler: () => {
              this.createModalShowing = true;
              this.selectedToken = '';
            }
          }
        ],
      });
      await sheet.present();
    },
    getLength(seconds: number): string {
      if (seconds >= 3600) {
        // Hours
        const val = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const minutesPart = minutes == 0 ? '' : ` ${minutes} ${minutes == 1 ? this.t('token.minute') : this.t('token.minutes')}`;
        return `${val} ${val < 2 ? this.t('token.hour') : this.t('token.hours')} ${minutesPart}`;
      } else if (seconds >= 60) {
        // Minutes
        const val = (seconds / 60);
        return `${val} ${val < 2 ? this.t('token.minute') : this.t('token.minutes')}`;
      } else {
        // Seconds
        return `${seconds} ${seconds < 2 ? this.t('token.second') : this.t('token.seconds')}`;
      }
    },
    getSessionLength(token: LoginToken) {
      return this.t('token.sessionLength') + ' ' + this.getLength(token.sessionLength);
    },
    getValidity(token: LoginToken) {
      if (!token.expires) {
        return this.t('token.expiresNever');
      }
      const expiresIn = token.expires.getTime() - (new Date().getTime());
      if (expiresIn > 86400000) {
        // > one day
        const formatted = Intl.DateTimeFormat('de-DE', { timeStyle: 'short', dateStyle: 'medium' }).format(token.expires);
        return `${this.t('token.expiresOn')} ${formatted}`;
      } else {
        // Within the next 24 hours
        return `${this.t('token.expiresIn')} ${this.getLength(expiresIn / 1000)}`;
      }
    },
    async removeToken(token: string) {
      try {
        await deleteLoginToken(token);
      } catch (err) {
        this.showError(String(err), 'err.removeToken');
      }
      this.reloadTokens();
    },
    async createToken() {
      if (!this.user) {
        return;
      }
      let expires: Date | null = null; // Equals never
      const now = new Date();
      switch (this.newTokenExpires) {
        case "today":
          now.setHours(23, 59, 59, 999);
          expires = now;
          break;
        case "tomorrow":
          now.setHours(23, 59, 59, 999);
          now.setDate(now.getDate() + 1);
          expires = now;
          break;
        case "nextWeek":
          now.setHours(23, 59, 59, 999);
          now.setDate(now.getDate() + 7);
          expires = now;
          break;
        case "nextMonth":
          now.setHours(23, 59, 59, 999);
          now.setMonth(now.getMonth() + 1);
          expires = now;
          break;
        case "nextYear":
          now.setHours(23, 59, 59, 999);
          now.setFullYear(now.getFullYear() + 1);
          expires = now;
          break;
      }
      const sessionLength = Number.parseInt(this.newTokenSessionLength)
      try {
        await createLoginToken((this.user as User).name, expires, sessionLength);
      } catch (err) {
        this.showError(String(err), 'err.createToken');
      }
      this.reloadTokens();
      this.createModalShowing = false;
    },
    async setClipboard() {
      await navigator.clipboard.writeText(this.selectedTokenUrl);
    }
  },
  setup() {
    const { t, dismissError, showError } = errorDisplay();

    const user: Ref<User> | Ref<null> = ref(null);
    const tokens: Ref<Array<LoginToken>> = ref([]);
    const loading = ref(false);
    const createModalShowing = ref(false); // Create Token
    const selectedToken = ref("");
    const newTokenExpires = ref("today");
    const newTokenSessionLength = ref("28800");

    return {
      t,
      showError,
      dismissError,
      skullOutline,
      linkSharp,
      ellipsisHorizontal,
      ellipsisVertical,
      qrCodeOutline,
      isPlatform,
      user,
      tokens,
      loading,
      Permission,
      createModalShowing,
      selectedToken,
      newTokenExpires,
      newTokenSessionLength,
    }
  }
});
</script>

<i18n locale="de" lang="yaml">
loading: Lade...
user:
  permissions: Berechtigungen
  tokens: Login Tokens
actions:
  title: Actions
  addToken: Login token erstellen...
token:
  none: Keine Tokens vorhanden
  expiresNever: Kein Ablaufdatum
  expiresOn: Läuft ab am
  expiresIn: Läuft ab in
  sessionLength: Logout nach
  hour: Stunde
  hours: Stunden
  minute: Minute
  minutes: Minuten
  second: Sekunde
  seconds: Sekunden
modal:
  details:
    title: Token Details
    button: Link kopieren
  new:
    title: Neuer token
    field:
      expires: Token läuft ab
      expiry:
        never: Niemals
        today: Heute
        tomorrow: Morgen
        nextWeek: Nächste Woche
        nextMonth: Nächster Monat
        nextYear: Nächstes Jahr
      sessionDuration: Anmeldedauer
      session:
        oneHour: '1 Stunde'
        twoHours: '2 Stunden'
        threeHours: '3 Stunden'
        fourHours: '4 Stunden'
        fiveHours: '5 Stunden'
        eightHours: '8 Stunden'
        twelveHours: '12 Stunden'
        oneDay: 'Ein Tag'
        oneWeek: 'Eine Woche'
    btn:
      create: Token erstellen
err:
  load: Benutzer konnte nicht geladen werden
  removeToken: Token konnte nicht gelöscht werden
  createToken: Token konnte nicht erstellt werden
btn:
  dismiss: Schließen
  delete: Löschen
  cancel: Abbrechen
</i18n>
<i18n locale="en" lang="yaml">
loading: Loading...
user:
  permissions: Permissions
  tokens: Login Tokens
actions:
  title: Actions
  addToken: Create login token...
token:
  none: This user has no tokens
  expiresNever: Will not expire
  expiresOn: Expires on
  expiresIn: Expires in
  sessionLength: Logout after
  hour: Hour
  hours: Hours
  minute: Minute
  minutes: Minutes
  second: Second
  seconds: Seconds
modal:
  details:
    title: Token details
    button: Copy to clipboard
  new:
    title: New token
    field:
      expires: Token expires
      expiry:
        never: Never
        today: Today
        tomorrow: Tomorrow
        nextWeek: Next week
        nextMonth: Next month
        nextYear: Next year
      sessionDuration: Session length
      session:
        oneHour: '1 Hour'
        twoHours: '2 Hours'
        threeHours: '3 Hours'
        fourHours: '4 Hours'
        fiveHours: '5 Hours'
        eightHours: '8 Hours'
        twelveHours: '12 Hours'
        oneDay: 'One Day'
        oneWeek: 'One Week'
    btn:
      create: Create token
err:
  load: Failed to load user information
  removeToken: Failed to delete token
  createToken: Failed to create token
btn:
  dismiss: Dismiss
  delete: Delete
  cancel: Cancel
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
