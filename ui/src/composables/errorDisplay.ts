import { toastController } from '@ionic/vue';
import { useI18n } from 'vue-i18n';

export function errorDisplay() {
    let toast: any = null;

    const { t } = useI18n({
        inheritLocale: true,
        useScope: 'local'
    });

    const dismissError = async () => {
        if (toast != null) {
            await toast.dismiss();
        }
    }

    const showError = async (message: string, title?: string) => {
        if (toast != null) {
            dismissError();
        }
        toast = await toastController.create({
            message: t(message),
            position: 'middle',
            color: 'danger',
            buttons: [
                {
                    text: t('btn.dismiss'),
                }
            ],
            header: title ? t(title) : undefined,
        });
        await toast.present();
        await toast.onDidDismiss();
        toast = null;
    }

    return {
        showError,
        dismissError,
        t,
    }
}
