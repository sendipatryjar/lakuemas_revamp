importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBjw50aqiyQd6HkZOUkJRiYXnvHbHv9JGY",
    authDomain: "lakuemas-dev.firebaseapp.com",
    projectId: "lakuemas-dev",
    storageBucket: "lakuemas-dev.appspot.com",
    messagingSenderId: "713899172299",
    appId: "1:713899172299:web:6a91724f2f0004c076964e",
    measurementId: "G-YK9JF5NSYY"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log("onBackgroundMessage", payload);
    // const notificationTitle = payload.notification.title;
    // const notificationOptions = {
    //   body: payload.notification.body,
    // };

    // self.registration.showNotification(notificationTitle, notificationOptions);
});
