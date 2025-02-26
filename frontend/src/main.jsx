import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './App.jsx';
import './index.css';
import { RouterProvider } from 'react-router-dom';
import router from './routers/router.jsx';
import 'sweetalert2/dist/sweetalert2.min.css';  // Import SweetAlert2 CSS for styling
import { Provider } from 'react-redux';
import { store } from './redux/store.js';

// Render the application with Redux and Router
createRoot(document.getElementById('root')).render(
  <Provider store={store}>
    <RouterProvider router={router} />
  </Provider>
);
