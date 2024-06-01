import { initializeApp } from 'firebase/app';
import { getMessaging, getToken, deleteToken } from "firebase/messaging";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
    apiKey: "AIzaSyD5OZIdQ9NsovaHbDVsx3f_WxpizJzqSxs",
    authDomain: "gamingepochs.firebaseapp.com",
    projectId: "gamingepochs",
    storageBucket: "gamingepochs.appspot.com",
    messagingSenderId: "779623346293",
    appId: "1:779623346293:web:5853654b593c84c1f4c83c",
    measurementId: "G-Q6N7XZ8206"
};

const app = initializeApp(firebaseConfig);
const fcmAnalytics = getAnalytics(app);
const fcmMessaging = getMessaging(app);

globalThis.getFcmToken = async () => {
    console.log("getFcmToken");
    console.log(fcmMessaging)
    try {
        let data = await getToken(fcmMessaging, { vapidKey: "BE3PkZ0hWksA0lWNSPskbHMimsCR7cyHh__uCr3DQUW4vKctwHnbDinMi9BEwdwNnLU7gX-T7JJPqFCzUhwAO8Q" });
        console.log(data);
        return data;
    } catch (e) {
        console.warn(e);
    }
};

globalThis.deleteFcmToken = async (token) => {
    return await deleteToken(fcmMessaging);
};
