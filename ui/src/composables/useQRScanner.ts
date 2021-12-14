//import { ref, onMounted, watch } from 'vue';
import { Camera, CameraResultType, CameraSource, Photo } from '@capacitor/camera';

export function useQRScanner() {
    const takePhoto = async () => {
        const photo = await Camera.getPhoto({
            resultType: CameraResultType.Uri,
            source: CameraSource.Camera,
            quality: 100,
        });
    };
    const scanCode = async () => {
        return await takePhoto();
    };
    return {
        takePhoto,
        scanCode,
    };
}
