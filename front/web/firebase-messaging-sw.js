importScripts('https://www.gstatic.com/firebasejs/10.13.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyAv0DsvyZB95HdMr_LnUmBJywXraWPX7WI',
  authDomain: 'flux-6e697.firebaseapp.com',
  projectId: 'flux-6e697',
  storageBucket: 'flux-6e697.firebasestorage.app',
  messagingSenderId: '162280543292',
  appId: '1:162280543292:web:ec9cedd531cfeb269a1f39',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification?.title ?? 'Flux';
  const notificationOptions = {
    body: payload.notification?.body ?? '',
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});