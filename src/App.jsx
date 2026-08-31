import { Routes, Route } from "react-router-dom";
import Booking from "./pages/Booking.jsx";
import AdminLogin from "./pages/AdminLogin.jsx";
import AdminDashboard from "./pages/AdminDashboard.jsx";
import BookingLookup from "./pages/BookingLookup.jsx";
import { ThemeProvider } from "./ThemeContext.jsx";
import { LanguageProvider } from "./i18n.js";

export default function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <Routes>
          <Route path="/" element={<Booking />} />
          <Route path="/lookup" element={<BookingLookup />} />
          <Route path="/admin/login" element={<AdminLogin />} />
          <Route path="/admin" element={<AdminDashboard />} />
        </Routes>
      </LanguageProvider>
    </ThemeProvider>
  );
}
