// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDE-AEchhzslGL4S4CIl-fm7rBHGz5zIPc",
  authDomain: "book-store-mern-app-17260.firebaseapp.com",
  projectId: "book-store-mern-app-17260",
  storageBucket: "book-store-mern-app-17260.firebasestorage.app",
  messagingSenderId: "194438686900",
  appId: "1:194438686900:web:ba7f6b7a7f944f2a3f4fe1",
  measurementId: "G-9WPKCQ3L7R"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);