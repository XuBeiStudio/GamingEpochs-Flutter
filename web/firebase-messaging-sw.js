// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

const firebaseConfig = {
    apiKey: "AIzaSyD5OZIdQ9NsovaHbDVsx3f_WxpizJzqSxs",
    authDomain: "gamingepochs.firebaseapp.com",
    projectId: "gamingepochs",
    storageBucket: "gamingepochs.appspot.com",
    messagingSenderId: "779623346293",
    appId: "1:779623346293:web:5853654b593c84c1f4c83c",
    measurementId: "G-Q6N7XZ8206"
};

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp(firebaseConfig);

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const fcmMessaging = firebase.messaging();

fcmMessaging.onBackgroundMessage((payload) => {
    const notificationTitle = payload.notification.title;

    self.registration.showNotification(notificationTitle, payload.notification);
});