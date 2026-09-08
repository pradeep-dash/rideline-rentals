#!/bin/bash
set -e
cat > src/i18n.js <<'FILEEOF'
import React, { createContext, useContext, useState } from "react";

export const LANGUAGES = { en: "EN", hi: "हि", or: "ଓଡ଼" };

// Customer-facing strings only — the admin panel stays English since
// it's an internal tool for the business owner.
// NOTE: Hindi and especially Odia are best-effort machine translations.
// Please have a native speaker review the "or" column before fully
// trusting it on the live site.
const STRINGS = {
  tagline: {
    en: "TOURS, TRAVEL & VEHICLE RENTAL",
    hi: "टूर, यात्रा और वाहन किराया",
    or: "ଟୁର୍, ଯାତ୍ରା ଏବଂ ଗାଡ଼ି ଭଡ଼ା",
  },
  heroTitle1: { en: "DISCOVER", hi: "ओडिशा को", or: "ଓଡ଼ିଶାକୁ" },
  heroTitle2: { en: "ODISHA", hi: "खोजें", or: "ଆବିଷ୍କାର କରନ୍ତୁ" },
  heroSubtitle: {
    en: "Sightseeing tours, holiday planning, and vehicle rentals — your complete travel partner in Bhubaneswar.",
    hi: "दर्शनीय स्थलों की यात्रा, छुट्टियों की योजना, और वाहन किराया — भुवनेश्वर में आपका पूरा यात्रा साथी।",
    or: "ଦର୍ଶନୀୟ ସ୍ଥାନ ଭ୍ରମଣ, ଛୁଟି ଯୋଜନା, ଏବଂ ଗାଡ଼ି ଭଡ଼ା — ଭୁବନେଶ୍ୱରରେ ଆପଣଙ୍କର ସମ୍ପୂର୍ଣ୍ଣ ଯାତ୍ରା ସାଥୀ।",
  },
  searchPlaceholder: {
    en: "Search tours, bikes, cars...",
    hi: "टूर, बाइक, कार खोजें...",
    or: "ଟୁର୍, ବାଇକ୍, କାର୍ ଖୋଜନ୍ତୁ...",
  },

  ourServices: { en: "WHAT WE OFFER", hi: "हम क्या प्रदान करते हैं", or: "ଆମେ କ'ଣ ପ୍ରଦାନ କରୁ" },
  serviceToursTitle: { en: "Sightseeing Tours", hi: "दर्शनीय यात्राएं", or: "ଦର୍ଶନୀୟ ଭ୍ରମଣ" },
  serviceToursDesc: { en: "Guided day trips across Bhubaneswar & Odisha", hi: "भुवनेश्वर और ओडिशा में गाइडेड डे ट्रिप", or: "ଭୁବନେଶ୍ୱର ଏବଂ ଓଡ଼ିଶାରେ ଗାଇଡେଡ୍ ଡେ ଟ୍ରିପ୍" },
  serviceRentalTitle: { en: "Vehicle Rental", hi: "वाहन किराया", or: "ଗାଡ଼ି ଭଡ଼ା" },
  serviceRentalDesc: { en: "Bikes, cars & buses — hourly or multi-day", hi: "बाइक, कार और बस — घंटे या कई दिनों के लिए", or: "ବାଇକ୍, କାର୍ ଏବଂ ବସ୍ — ଘଣ୍ଟା କିମ୍ବା ଏକାଧିକ ଦିନ ପାଇଁ" },
  serviceCustomTitle: { en: "Custom Trip Planning", hi: "कस्टम यात्रा योजना", or: "କଷ୍ଟମ୍ ଯାତ୍ରା ଯୋଜନା" },
  serviceCustomDesc: { en: "Tell us your plan, we'll tailor the rest", hi: "अपनी योजना बताएं, बाकी हम संभालेंगे", or: "ଆପଣଙ୍କ ଯୋଜନା କୁହନ୍ତୁ, ବାକି ଆମେ ସମ୍ଭାଳିବୁ" },
  serviceGroupTitle: { en: "Group & Corporate Travel", hi: "समूह और कॉर्पोरेट यात्रा", or: "ଗ୍ରୁପ୍ ଏବଂ କର୍ପୋରେଟ୍ ଯାତ୍ରା" },
  serviceGroupDesc: { en: "Special rates for groups and businesses", hi: "समूहों और व्यवसायों के लिए विशेष दरें", or: "ଗ୍ରୁପ୍ ଏବଂ ବ୍ୟବସାୟ ପାଇଁ ବିଶେଷ ଦର" },
  enquireWhatsapp: { en: "Enquire on WhatsApp", hi: "WhatsApp पर पूछें", or: "WhatsApp ରେ ପଚାରନ୍ତୁ" },
  exploreTours: { en: "Explore tours", hi: "टूर देखें", or: "ଟୁର୍ ଦେଖନ୍ତୁ" },
  viewVehicles: { en: "View vehicles", hi: "वाहन देखें", or: "ଗାଡ଼ି ଦେଖନ୍ତୁ" },

  toursSectionSubtitle: {
    en: "Our main offering — guided day trips across Odisha",
    hi: "हमारी मुख्य सेवा — ओडिशा भर में गाइडेड डे ट्रिप",
    or: "ଆମର ମୁଖ୍ୟ ସେବା — ଓଡ଼ିଶା ସାରା ଗାଇଡେଡ୍ ଡେ ଟ୍ରିପ୍",
  },
  vehicleRentalHeading: { en: "ALSO AVAILABLE — VEHICLE RENTAL", hi: "यह भी उपलब्ध — वाहन किराया", or: "ଏହା ମଧ୍ୟ ଉପଲବ୍ଧ — ଗାଡ଼ି ଭଡ଼ା" },
  vehicleRentalSubtitle: {
    en: "Need your own wheels for the trip? Rent a bike, car, or bus directly below.",
    hi: "यात्रा के लिए अपनी सवारी चाहिए? नीचे से बाइक, कार या बस किराए पर लें।",
    or: "ଯାତ୍ରା ପାଇଁ ନିଜର ଗାଡ଼ି ଦରକାର? ତଳୁ ବାଇକ୍, କାର୍ କିମ୍ବା ବସ୍ ଭଡ଼ାରେ ନିଅନ୍ତୁ।",
  },

  bikes: { en: "Bikes", hi: "बाइक", or: "ବାଇକ୍" },
  cars: { en: "Cars", hi: "कार", or: "କାର୍" },
  buses: { en: "Buses", hi: "बस", or: "ବସ୍" },
  tours: { en: "Tours", hi: "टूर", or: "ଟୁର୍" },
  packages: { en: "Packages", hi: "पैकेज", or: "ପ୍ୟାକେଜ୍" },
  travels: { en: "Travels", hi: "यात्राएं", or: "ଯାତ୍ରା" },
  packagesSectionSubtitle: {
    en: "All-inclusive trips — stay, food, and sightseeing bundled together.",
    hi: "सर्व-समावेशी यात्राएं — ठहरना, खाना और घूमना सब एक साथ।",
    or: "ସର୍ବସମ୍ମିଳିତ ଯାତ୍ରା — ରହିବା, ଖାଦ୍ୟ ଏବଂ ଭ୍ରମଣ ଏକାଠି।",
  },
  travelsSectionSubtitle: {
    en: "Not sure where you want to go? Book a car or bike with a driver/rider and roam as you please.",
    hi: "पक्का नहीं कि कहाँ जाना है? ड्राइवर/राइडर के साथ कार या बाइक बुक करें और अपनी मर्ज़ी से घूमें।",
    or: "କେଉଁଠି ଯିବେ ନିଶ୍ଚିତ ନାହିଁ? ଡ୍ରାଇଭର/ରାଇଡର ସହିତ କାର୍ କିମ୍ବା ବାଇକ୍ ବୁକ୍ କରନ୍ତୁ ଏବଂ ନିଜ ମର୍ଜିରେ ବୁଲନ୍ତୁ।",
  },
  sortLabel: { en: "Sort", hi: "क्रम", or: "କ୍ରମ" },
  sortDefault: { en: "Default", hi: "डिफ़ॉल्ट", or: "ଡିଫଲ୍ଟ" },
  sortPriceLow: { en: "Price: Low to High", hi: "कीमत: कम से ज़्यादा", or: "ମୂଲ୍ୟ: କମରୁ ଅଧିକ" },
  sortPriceHigh: { en: "Price: High to Low", hi: "कीमत: ज़्यादा से कम", or: "ମୂଲ୍ୟ: ଅଧିକରୁ କମ" },
  book: { en: "Book", hi: "बुक करें", or: "ବୁକ୍ କରନ୍ତୁ" },
  selected: { en: "Selected", hi: "चयनित", or: "ମନୋନୀତ" },
  booking: { en: "BOOKING", hi: "बुकिंग", or: "ବୁକିଂ" },
  selectDate: { en: "SELECT DATE", hi: "तारीख़ चुनें", or: "ତାରିଖ ବାଛନ୍ତୁ" },
  selectTime: { en: "SELECT TIME", hi: "समय चुनें", or: "ସମୟ ବାଛନ୍ତୁ" },
  selectPickupTime: { en: "SELECT PICKUP TIME", hi: "पिकअप समय चुनें", or: "ପିକଅପ୍ ସମୟ ବାଛନ୍ତୁ" },
  multiDay: { en: "Multiple days", hi: "कई दिन", or: "ଏକାଧିକ ଦିନ" },
  startDate: { en: "Start date", hi: "शुरुआत की तारीख़", or: "ଆରମ୍ଭ ତାରିଖ" },
  endDate: { en: "End date", hi: "अंतिम तारीख़", or: "ଶେଷ ତାରିଖ" },
  totalFor: { en: "Total for", hi: "कुल", or: "ମୋଟ" },
  days: { en: "days", hi: "दिन", or: "ଦିନ" },
  fullName: { en: "Full name", hi: "पूरा नाम", or: "ପୂରା ନାମ" },
  phoneNumber: { en: "Phone number", hi: "फ़ोन नंबर", or: "ଫୋନ୍ ନମ୍ବର" },
  emailAddress: { en: "Email address", hi: "ईमेल पता", or: "ଇମେଲ୍ ଠିକଣା" },
  couponCode: { en: "Coupon code (optional)", hi: "कूपन कोड (वैकल्पिक)", or: "କୁପନ୍ କୋଡ୍ (ଇଚ୍ଛାଧୀନ)" },
  apply: { en: "Apply", hi: "लागू करें", or: "ଲାଗୁ କରନ୍ତୁ" },
  couponApplied: { en: "applied", hi: "लागू", or: "ଲାଗୁ ହୋଇଛି" },
  invalidCoupon: { en: "Invalid or expired code", hi: "अमान्य या समाप्त कोड", or: "ଅବୈଧ କିମ୍ବା ମିଆଦ ସରିଥିବା କୋଡ୍" },
  confirmBooking: { en: "Confirm Booking", hi: "बुकिंग पक्की करें", or: "ବୁକିଂ ନିଶ୍ଚିତ କରନ୍ତୁ" },
  reviews: { en: "Reviews", hi: "समीक्षाएं", or: "ସମୀକ୍ଷା" },
  leaveReview: { en: "Leave a review", hi: "समीक्षा लिखें", or: "ସମୀକ୍ଷା ଲେଖନ୍ତୁ" },
  yourName: { en: "Your name", hi: "आपका नाम", or: "ଆପଣଙ୍କ ନାମ" },
  yourReview: { en: "Your review (optional)", hi: "आपकी समीक्षा (वैकल्पिक)", or: "ଆପଣଙ୍କ ସମୀକ୍ଷା (ଇଚ୍ଛାଧୀନ)" },
  submitReview: { en: "Submit review", hi: "समीक्षा भेजें", or: "ସମୀକ୍ଷା ପଠାନ୍ତୁ" },
  reviewSubmitted: { en: "Thanks! Your review will appear after approval.", hi: "धन्यवाद! स्वीकृति के बाद आपकी समीक्षा दिखेगी।", or: "ଧନ୍ୟବାଦ! ଅନୁମୋଦନ ପରେ ଆପଣଙ୍କ ସମୀକ୍ଷା ଦେଖାଯିବ।" },
  questionsReachUs: { en: "QUESTIONS? REACH US DIRECTLY", hi: "सवाल हैं? सीधे संपर्क करें", or: "ପ୍ରଶ୍ନ ଅଛି? ସିଧାସଳଖ ଯୋଗାଯୋଗ କରନ୍ତୁ" },
  checkBooking: { en: "Check a booking", hi: "बुकिंग जांचें", or: "ବୁକିଂ ଯାଞ୍ଚ କରନ୍ତୁ" },
  admin: { en: "admin", hi: "admin", or: "admin" },

  addToTrip: { en: "Add to Trip", hi: "ट्रिप में जोड़ें", or: "ଟ୍ରିପ୍ ରେ ଯୋଡ଼ନ୍ତୁ" },
  addedToTrip: { en: "Added", hi: "जोड़ा गया", or: "ଯୋଡ଼ାଗଲା" },
  myTrip: { en: "My Trip", hi: "मेरी ट्रिप", or: "ମୋ ଟ୍ରିପ୍" },
  tripEmpty: { en: "Your trip list is empty. Tap \"Add to Trip\" on anything you like.", hi: "आपकी ट्रिप सूची खाली है। जो पसंद है उस पर \"ट्रिप में जोड़ें\" दबाएं।", or: "ଆପଣଙ୍କ ଟ୍ରିପ୍ ତାଲିକା ଖାଲି। ପସନ୍ଦର ଜିନିଷରେ \"ଟ୍ରିପ୍ ରେ ଯୋଡ଼ନ୍ତୁ\" ଦବାନ୍ତୁ।" },
  removeFromTrip: { en: "Remove", hi: "हटाएं", or: "ହଟାନ୍ତୁ" },
  sendTripRequest: { en: "Send Trip Request", hi: "ट्रिप अनुरोध भेजें", or: "ଟ୍ରିପ୍ ଅନୁରୋଧ ପଠାନ୍ତୁ" },
  tripRequestSent: { en: "Sent! We'll reach out on WhatsApp to plan the details.", hi: "भेज दिया! हम विवरण तय करने के लिए WhatsApp पर संपर्क करेंगे।", or: "ପଠାଗଲା! ବିବରଣୀ ଯୋଜନା କରିବାକୁ ଆମେ WhatsApp ରେ ଯୋଗାଯୋଗ କରିବୁ।" },
  popular: { en: "Popular", hi: "लोकप्रिय", or: "ଲୋକପ୍ରିୟ" },
  cancellationPolicy: {
    en: "Free cancellation up to 24 hours before your slot.",
    hi: "अपने स्लॉट से 24 घंटे पहले तक मुफ़्त रद्दीकरण।",
    or: "ଆପଣଙ୍କ ସ୍ଲଟ୍ ପୂର୍ବରୁ 24 ଘଣ୍ଟା ପର୍ଯ୍ୟନ୍ତ ମାଗଣା ବାତିଲ୍।",
  },
  viewAll: { en: "View all", hi: "सभी देखें", or: "ସବୁ ଦେଖନ୍ତୁ" },
  showLess: { en: "Show less", hi: "कम दिखाएं", or: "କମ୍ ଦେଖାନ୍ତୁ" },
  aboutThisTour: { en: "About this tour", hi: "इस टूर के बारे में", or: "ଏହି ଟୁର୍ ବିଷୟରେ" },
  whatToKnow: { en: "What to know before you go", hi: "जाने से पहले जान लें", or: "ଯିବା ପୂର୍ବରୁ ଜାଣନ୍ତୁ" },
  bookNow: { en: "Book Now", hi: "अभी बुक करें", or: "ବର୍ତ୍ତମାନ ବୁକ୍ କରନ୍ତୁ" },
};

export function t(key, lang) {
  return STRINGS[key]?.[lang] || STRINGS[key]?.en || key;
}

const LanguageContext = createContext(null);

export function LanguageProvider({ children }) {
  const [lang, setLang] = useState(() => {
    try {
      return localStorage.getItem("rideline-lang") || "en";
    } catch {
      return "en";
    }
  });

  function changeLang(newLang) {
    setLang(newLang);
    try {
      localStorage.setItem("rideline-lang", newLang);
    } catch {
      // ignore storage errors
    }
  }

  return React.createElement(LanguageContext.Provider, { value: { lang, setLang: changeLang } }, children);
}

export function useLanguage() {
  const ctx = useContext(LanguageContext);
  if (!ctx) throw new Error("useLanguage must be used within a LanguageProvider");
  return ctx;
}

FILEEOF

cat > src/pages/Booking.jsx <<'FILEEOF'
import React, { useState, useEffect, useMemo, useRef } from "react";
import {
  Bike,
  Car,
  Bus,
  Landmark,
  Instagram,
  Facebook,
  MessageCircle,
  Check,
  Clock,
  MapPin,
  ChevronRight,
  Loader2,
  User,
  Phone,
  Mail,
  Search,
  X,
  Star,
  Tag,
  CalendarRange,
  ClipboardList,
  Compass,
  Users,
  Briefcase,
  Plus,
  Trash2,
  ShieldCheck,
  Package,
  Route,
} from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS, SLOTS, CANCELLATION_POLICY_HOURS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";
import LanguageToggle from "../components/LanguageToggle.jsx";
import { useLanguage, t } from "../i18n.js";

// Tours lead — vehicle rental is a supporting service, not the headline.
const TOUR_CATEGORY = { key: "tour", labelKey: "tours", icon: Landmark, tint: "rgba(245,110,110,0.14)" };
const PACKAGE_CATEGORY = { key: "package", labelKey: "packages", icon: Package, tint: "rgba(122,200,245,0.14)" };
const TRAVEL_CATEGORY = { key: "travel", labelKey: "travels", icon: Route, tint: "rgba(180,140,245,0.14)" };
const VEHICLE_CATEGORIES = [
  { key: "bike", labelKey: "bikes", icon: Bike, tint: "rgba(245,183,0,0.16)" },
  { key: "car", labelKey: "cars", icon: Car, tint: "rgba(37,211,102,0.14)" },
  { key: "bus", labelKey: "buses", icon: Bus, tint: "rgba(122,110,245,0.16)" },
];


function nextDays(n) {
  const out = [];
  const today = new Date();
  for (let i = 0; i < n; i++) {
    const d = new Date(today);
    d.setDate(today.getDate() + i);
    out.push(d);
  }
  return out;
}
function dateKey(d) {
  return d.toISOString().slice(0, 10);
}
function dayLabel(d) {
  return d.toLocaleDateString("en-US", { weekday: "short" }).toUpperCase();
}
function isPastSlot(dateStr, slotTime) {
  const now = new Date();
  if (dateStr !== dateKey(now)) return false; // only today's date can have "past" slots
  const [h, m] = slotTime.split(":").map(Number);
  const slotDate = new Date();
  slotDate.setHours(h, m, 0, 0);
  return slotDate <= now;
}
function daysBetweenInclusive(startStr, endStr) {
  const out = [];
  const start = new Date(startStr);
  const end = new Date(endStr);
  if (end < start) return out;
  const cur = new Date(start);
  while (cur <= end) {
    out.push(dateKey(cur));
    cur.setDate(cur.getDate() + 1);
  }
  return out;
}

export default function Booking() {
  const { colors: COLORS } = useTheme();
  const { lang } = useLanguage();
  const tr = (key) => t(key, lang);

  const [allListings, setAllListings] = useState({ bike: [], car: [], bus: [], tour: [], package: [], travel: [] });
  const [reviewStats, setReviewStats] = useState({});
  const [bookingCounts, setBookingCounts] = useState({});
  const [loadingListings, setLoadingListings] = useState(true);
  const [search, setSearch] = useState("");
  const [sortOrder, setSortOrder] = useState("default");
  const [expandedCats, setExpandedCats] = useState({}); // { bike: true } once "View all" tapped
  const [detailListing, setDetailListing] = useState(null); // { listing, category } for the tour popup

  function toggleExpanded(catKey) {
    setExpandedCats((prev) => ({ ...prev, [catKey]: !prev[catKey] }));
  }

  // Trip Builder — a lightweight "save for a combined enquiry" list,
  // separate from actually booking a specific slot.
  const [myTrip, setMyTrip] = useState(() => {
    try {
      return JSON.parse(localStorage.getItem("rideline-trip") || "[]");
    } catch {
      return [];
    }
  });
  const [tripPanelOpen, setTripPanelOpen] = useState(false);
  const [tripForm, setTripForm] = useState({ name: "", phone: "", email: "" });
  const [tripSubmitting, setTripSubmitting] = useState(false);
  const [tripSent, setTripSent] = useState(false);

  useEffect(() => {
    try {
      localStorage.setItem("rideline-trip", JSON.stringify(myTrip));
    } catch {
      // ignore storage errors
    }
  }, [myTrip]);

  const [selected, setSelected] = useState(null); // { category, listingId }
  const days = useMemo(() => nextDays(14), []);
  const [date, setDate] = useState(dateKey(days[0]));
  const [takenSlots, setTakenSlots] = useState([]);
  const [slot, setSlot] = useState(null);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [email, setEmail] = useState("");
  const [loadingSlots, setLoadingSlots] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [ticket, setTicket] = useState(null);
  const [error, setError] = useState("");

  // Multi-day (bus /day listings only)
  const [multiDay, setMultiDay] = useState(false);
  const [rangeStart, setRangeStart] = useState(dateKey(days[0]));
  const [rangeEnd, setRangeEnd] = useState(dateKey(days[0]));

  // Coupons
  const [couponInput, setCouponInput] = useState("");
  const [couponApplied, setCouponApplied] = useState(null); // { code, discount_percent }
  const [couponChecking, setCouponChecking] = useState(false);
  const [couponError, setCouponError] = useState("");

  // Reviews
  const [panelReviews, setPanelReviews] = useState([]);
  const [reviewForm, setReviewForm] = useState({ name: "", rating: 5, comment: "" });
  const [reviewSubmitting, setReviewSubmitting] = useState(false);
  const [reviewDone, setReviewDone] = useState(false);

  const panelRef = useRef(null);

  // Tour carousel — tracks which large hero card is in view for the dot indicator
  const tourScrollRef = useRef(null);
  const [activeTourIndex, setActiveTourIndex] = useState(0);
  function handleTourScroll() {
    const el = tourScrollRef.current;
    if (!el || !el.firstElementChild) return;
    const cardWidth = el.firstElementChild.offsetWidth + 16; // gap-4 = 16px
    const idx = Math.round(el.scrollLeft / cardWidth);
    setActiveTourIndex(idx);
  }

  // Package carousel — same pattern as tours
  const packageScrollRef = useRef(null);
  const [activePackageIndex, setActivePackageIndex] = useState(0);
  function handlePackageScroll() {
    const el = packageScrollRef.current;
    if (!el || !el.firstElementChild) return;
    const cardWidth = el.firstElementChild.offsetWidth + 16;
    const idx = Math.round(el.scrollLeft / cardWidth);
    setActivePackageIndex(idx);
  }

  useEffect(() => {
    (async () => {
      setLoadingListings(true);
      const [{ data: listingsData }, { data: statsData }, { data: countsData }] = await Promise.all([
        supabase.from("listings").select("*").eq("active", true).order("price", { ascending: true }),
        supabase.from("review_stats").select("*"),
        supabase.from("listing_booking_counts").select("*"),
      ]);
      const grouped = { bike: [], car: [], bus: [], tour: [], package: [], travel: [] };
      (listingsData || []).forEach((l) => {
        if (grouped[l.category]) grouped[l.category].push(l);
      });
      setAllListings(grouped);
      const statsMap = {};
      (statsData || []).forEach((s) => {
        statsMap[s.listing_id] = s;
      });
      setReviewStats(statsMap);
      const countsMap = {};
      (countsData || []).forEach((c) => {
        countsMap[c.listing_id] = c.booking_count;
      });
      setBookingCounts(countsMap);
      setLoadingListings(false);
    })();
  }, []);

  const listing = selected ? allListings[selected.category]?.find((l) => l.id === selected.listingId) : null;
  const isMultiDayEligible = listing && listing.category !== "tour" && listing.category !== "package";

  useEffect(() => {
    if (!selected || multiDay) return;
    let cancelled = false;
    (async () => {
      setLoadingSlots(true);
      setSlot(null);
      const { data, error: err } = await supabase
        .from("taken_slots")
        .select("slot_time")
        .eq("listing_id", selected.listingId)
        .eq("booking_date", date);
      if (cancelled) return;
      if (!err) setTakenSlots((data || []).map((r) => r.slot_time));
      setLoadingSlots(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [selected, date, multiDay]);

  useEffect(() => {
    if (selected && panelRef.current) {
      panelRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [selected]);

  useEffect(() => {
    if (!selected) {
      setPanelReviews([]);
      return;
    }
    (async () => {
      const { data } = await supabase
        .from("reviews")
        .select("customer_name, rating, comment, created_at")
        .eq("listing_id", selected.listingId)
        .eq("approved", true)
        .order("created_at", { ascending: false })
        .limit(10);
      setPanelReviews(data || []);
    })();
  }, [selected]);

  function chooseListing(category, listingId) {
    setError("");
    setTicket(null);
    setMultiDay(false);
    setCouponApplied(null);
    setCouponInput("");
    setCouponError("");
    setReviewDone(false);
    setSelected({ category, listingId });
  }

  function isInTrip(listingId) {
    return myTrip.some((item) => item.listingId === listingId);
  }

  function toggleTrip(listing, category) {
    setMyTrip((prev) => {
      if (prev.some((item) => item.listingId === listing.id)) {
        return prev.filter((item) => item.listingId !== listing.id);
      }
      return [...prev, { listingId: listing.id, name: listing.name, category, price: listing.price, unit: listing.unit }];
    });
  }

  function removeFromTrip(listingId) {
    setMyTrip((prev) => prev.filter((item) => item.listingId !== listingId));
  }

  async function sendTripRequest(e) {
    e.preventDefault();
    if (!tripForm.name.trim() || !tripForm.phone.trim() || myTrip.length === 0) return;
    setTripSubmitting(true);
    await supabase.from("trip_enquiries").insert({
      customer_name: tripForm.name.trim(),
      customer_phone: tripForm.phone.trim(),
      customer_email: tripForm.email.trim() || null,
      items: myTrip,
    });
    const lines = myTrip.map((item) => `- ${item.name} (₹${item.price}${item.unit})`).join("%0A");
    const msg = `Hi ${BUSINESS.name}! I'd like to plan a trip with:%0A%0A${lines}%0A%0AName: ${tripForm.name.trim()}%0APhone: ${tripForm.phone.trim()}`;
    window.open(`https://wa.me/${BUSINESS.whatsapp}?text=${msg}`, "_blank");
    setTripSubmitting(false);
    setTripSent(true);
    setMyTrip([]);
  }

  async function applyCoupon() {
    if (!couponInput.trim()) return;
    setCouponChecking(true);
    setCouponError("");
    const { data, error: err } = await supabase.rpc("validate_coupon", { p_code: couponInput.trim() });
    setCouponChecking(false);
    if (err || !data || data.length === 0) {
      setCouponError(tr("invalidCoupon"));
      setCouponApplied(null);
      return;
    }
    setCouponApplied(data[0]);
  }

  const rangeDates = multiDay ? daysBetweenInclusive(rangeStart, rangeEnd) : [];
  const rangeDays = rangeDates.length;
  const baseTotal = listing ? (multiDay ? listing.price * rangeDays : listing.price) : 0;
  const discountedTotal = couponApplied ? Math.round(baseTotal * (1 - couponApplied.discount_percent / 100)) : baseTotal;

  const canConfirm =
    listing &&
    name.trim() &&
    phone.trim().length >= 7 &&
    email.trim().includes("@") &&
    !submitting &&
    (multiDay ? rangeDays > 0 : !!slot);

  async function confirmBooking() {
    if (!listing) return;
    setError("");
    setSubmitting(true);
    const code = Math.random().toString(36).slice(2, 7).toUpperCase();

    if (multiDay) {
      if (rangeDays === 0) {
        setError("Pick a valid date range.");
        setSubmitting(false);
        return;
      }
      const groupId = crypto.randomUUID();
      const rows = rangeDates.map((d) => ({
        listing_id: listing.id,
        booking_date: d,
        slot_time: "FULL DAY",
        customer_name: name.trim(),
        customer_phone: phone.trim(),
        customer_email: email.trim(),
        code,
        booking_group_id: groupId,
        coupon_code: couponApplied?.code || null,
      }));
      const { error: err } = await supabase.from("bookings").insert(rows);
      if (err) {
        setError(err.code === "23505" ? "One or more of those days is already booked — pick a different range." : "Couldn't save your booking — please try again.");
        setSubmitting(false);
        return;
      }
      setTicket({
        vehicle: listing.name,
        type: listing.category,
        date: `${rangeStart} → ${rangeEnd}`,
        slot: `${rangeDays} ${tr("days")}`,
        name: name.trim(),
        phone: phone.trim(),
        email: email.trim(),
        price: discountedTotal,
        unit: "",
        tag: listing.tag,
        hours: null,
        code,
        multiDay: true,
      });
      setSubmitting(false);
      return;
    }

    const { error: err } = await supabase.from("bookings").insert({
      listing_id: listing.id,
      booking_date: date,
      slot_time: slot,
      customer_name: name.trim(),
      customer_phone: phone.trim(),
      customer_email: email.trim(),
      code,
      coupon_code: couponApplied?.code || null,
    });

    if (err) {
      if (err.code === "23505") {
        setError("That slot was just taken — pick another.");
        setTakenSlots((prev) => [...prev, slot]);
        setSlot(null);
      } else {
        setError("Couldn't save your booking — please try again.");
      }
      setSubmitting(false);
      return;
    }

    setTicket({
      vehicle: listing.name,
      type: listing.category,
      date,
      slot,
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      price: discountedTotal,
      unit: listing.unit,
      tag: listing.tag,
      hours: listing.hours,
      code,
      multiDay: false,
    });
    setSubmitting(false);
  }

  async function submitReview(e) {
    e.preventDefault();
    if (!reviewForm.name.trim() || !selected) return;
    setReviewSubmitting(true);
    await supabase.from("reviews").insert({
      listing_id: selected.listingId,
      customer_name: reviewForm.name.trim(),
      rating: reviewForm.rating,
      comment: reviewForm.comment.trim() || null,
    });
    setReviewSubmitting(false);
    setReviewDone(true);
    setReviewForm({ name: "", rating: 5, comment: "" });
  }

  function waLink() {
    if (!ticket) return "#";
    const label = ticket.type === "tour" ? "Tour" : "Vehicle";
    const durationLine =
      ticket.type === "tour" && ticket.hours ? `%0ADuration: ${ticket.tag} (${ticket.hours} hrs)` : "";
    const priceLine = `%0ATotal: ₹${ticket.price}${ticket.unit || ""}`;
    const msg = `Hi ${BUSINESS.name}! I'd like to confirm my booking:%0A%0A${label}: ${ticket.vehicle}%0ADate: ${ticket.date}%0ATime: ${ticket.slot}${durationLine}${priceLine}%0AName: ${ticket.name}%0APhone: ${ticket.phone}%0ABooking code: ${ticket.code}`;
    return `https://wa.me/${BUSINESS.whatsapp}?text=${msg}`;
  }

  function resetFlow() {
    setTicket(null);
    setSelected(null);
    setSlot(null);
    setName("");
    setPhone("");
    setEmail("");
    setMultiDay(false);
    setCouponApplied(null);
    setCouponInput("");
  }

  const term = search.trim().toLowerCase();
  const matches = (l) => !term || l.name.toLowerCase().includes(term);
  const sortListings = (items) => {
    if (sortOrder === "priceAsc") return [...items].sort((a, b) => a.price - b.price);
    if (sortOrder === "priceDesc") return [...items].sort((a, b) => b.price - a.price);
    return items;
  };

  const categoryIcon = (t2, size = 16) =>
    t2 === "bike" ? <Bike size={size} /> : t2 === "car" ? <Car size={size} /> : t2 === "bus" ? <Bus size={size} /> : <Landmark size={size} />;

  return (
    <div className="font-body min-h-screen w-full" style={{ color: COLORS.text }}>
      {/* Navbar */}
      <header
        className="flex items-center gap-3 px-5 py-4 sticky top-0 z-20 flex-wrap"
        style={{ background: "rgba(20,24,28,0.75)", backdropFilter: "blur(14px)", borderBottom: `1px solid ${COLORS.border}` }}
      >
        <div className="flex items-center gap-2.5 shrink-0">
          <div
            className="w-9 h-9 rounded-xl flex items-center justify-center"
            style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 4px 16px ${COLORS.glow}` }}
          >
            <Car size={18} color={COLORS.bg} strokeWidth={2.5} />
          </div>
          <span className="font-display text-xl tracking-wide hidden sm:block">{BUSINESS.name.toUpperCase()}</span>
        </div>
        <div className="relative flex-1 min-w-[140px] max-w-md">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder={tr("searchPlaceholder")}
            aria-label={tr("searchPlaceholder")}
            className="w-full pl-9 pr-3 py-2.5 rounded-full text-sm"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
          />
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-xs font-mono shrink-0" style={{ color: COLORS.muted }}>
          <MapPin size={13} />
          {BUSINESS.location}
        </div>
        <LanguageToggle />
        <ThemeToggle />
      </header>

      {/* Hero */}
      <section className="relative px-5 pt-7 pb-5 text-center">
        <div
          className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full mb-4 font-mono text-[10px] tracking-[0.2em]"
          style={{ background: COLORS.accentSoft, color: COLORS.accent, border: `1px solid rgba(245,183,0,0.25)` }}
        >
          <span className="w-1.5 h-1.5 rounded-full" style={{ background: COLORS.accent }} />
          {tr("tagline")}
        </div>
        <h1 className="font-display text-5xl sm:text-7xl leading-none">
          {tr("heroTitle1")} <span style={{ color: COLORS.accent }}>{tr("heroTitle2")}</span>
        </h1>
        <p className="mt-3 text-base" style={{ color: COLORS.muted }}>
          {tr("heroSubtitle")}
        </p>
      </section>

      {/* Services overview — compact 2x2 summary strip, not a second hero */}
      <section className="px-5 pb-7 max-w-5xl mx-auto">
        <p className="font-mono text-xs tracking-widest mb-3 text-center" style={{ color: COLORS.muted }}>{tr("ourServices")}</p>
        <div className="grid grid-cols-2 gap-2">
          <a
            href="#tour"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: `linear-gradient(160deg, ${COLORS.accentSoft}, ${COLORS.surface})`, border: `1px solid ${COLORS.accent}` }}
          >
            <Landmark size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceToursTitle")}</p>
          </a>
          <a
            href="#bike"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Car size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceRentalTitle")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like help planning a custom trip.`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Compass size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceCustomTitle")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like to enquire about group/corporate travel.`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2.5 p-2.5 rounded-xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Users size={18} color={COLORS.accent} className="shrink-0" />
            <p className="font-semibold text-xs leading-tight">{tr("serviceGroupTitle")}</p>
          </a>
        </div>
      </section>

      {/* Booking panel */}
      {selected && (
        <div ref={panelRef} style={{ scrollMarginTop: "72px" }} className="px-5 pb-2">
          {ticket ? (
            <TicketView ticket={ticket} waLink={waLink()} onReset={resetFlow} colors={COLORS} business={BUSINESS} tr={tr} />
          ) : (
            <div
              className="max-w-xl mx-auto rounded-2xl p-5"
              style={{ background: `linear-gradient(160deg, ${COLORS.surface}, ${COLORS.surface2})`, border: `1px solid ${COLORS.accent}`, boxShadow: `0 12px 32px ${COLORS.glow}` }}
            >
              <div className="flex items-center justify-between mb-4">
                <div>
                  <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>{tr("booking")}</p>
                  <p className="font-semibold">{listing ? listing.name : "..."}</p>
                </div>
                <button onClick={() => setSelected(null)} className="p-2 rounded-full" aria-label="Close" style={{ background: COLORS.surface2 }}>
                  <X size={16} color={COLORS.muted} />
                </button>
              </div>

              {isMultiDayEligible && (
                <label className="flex items-center gap-2 mb-4 text-sm cursor-pointer">
                  <input type="checkbox" checked={multiDay} onChange={(e) => setMultiDay(e.target.checked)} />
                  <CalendarRange size={14} color={COLORS.accent} />
                  {tr("multiDay")}
                </label>
              )}

              {multiDay ? (
                <>
                  <div className="grid grid-cols-2 gap-3 mb-4">
                    <div>
                      <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>{tr("startDate")}</label>
                      <input
                        type="date"
                        value={rangeStart}
                        min={dateKey(days[0])}
                        onChange={(e) => setRangeStart(e.target.value)}
                        className="w-full px-3 py-2.5 rounded-lg text-sm"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                    </div>
                    <div>
                      <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>{tr("endDate")}</label>
                      <input
                        type="date"
                        value={rangeEnd}
                        min={rangeStart}
                        onChange={(e) => setRangeEnd(e.target.value)}
                        className="w-full px-3 py-2.5 rounded-lg text-sm"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                    </div>
                  </div>
                  {rangeDays > 0 && (
                    <p className="text-sm mb-4 font-mono" style={{ color: COLORS.accent }}>
                      {tr("totalFor")} {rangeDays} {tr("days")}: ₹{discountedTotal}
                      {couponApplied && <span style={{ color: COLORS.muted }}> (₹{baseTotal} - {couponApplied.discount_percent}%)</span>}
                    </p>
                  )}
                </>
              ) : (
                <>
                  <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>{tr("selectDate")}</p>
                  <div className="flex gap-2 overflow-x-auto pb-2 mb-5">
                    {days.map((d) => {
                      const key = dateKey(d);
                      const active = date === key;
                      return (
                        <button
                          key={key}
                          onClick={() => setDate(key)}
                          className="flex flex-col items-center justify-center rounded-xl px-3.5 py-2 min-w-[56px] shrink-0"
                          style={
                            active
                              ? { background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 6px 16px ${COLORS.glow}` }
                              : { background: COLORS.surface2, border: `1px solid ${COLORS.border}` }
                          }
                        >
                          <span className="font-mono text-[10px]" style={{ color: active ? COLORS.bg : COLORS.muted }}>{dayLabel(d)}</span>
                          <span className="font-display text-xl leading-none" style={{ color: active ? COLORS.bg : COLORS.text }}>{d.getDate()}</span>
                        </button>
                      );
                    })}
                  </div>

                  <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>
                    {selected.category === "tour" ? tr("selectPickupTime") : tr("selectTime")}
                  </p>
                  <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 mb-5">
                    {loadingSlots
                      ? Array.from({ length: 6 }).map((_, i) => <div key={i} className="h-10 rounded-lg animate-pulse" style={{ background: COLORS.surface2 }} />)
                                      : SLOTS.map((s) => {
                          const isBooked = takenSlots.includes(s);
                          const isPast = isPastSlot(date, s);
                          const isDisabled = isBooked || isPast;
                          const active = slot === s;
                          return (
                            <button
                              key={s}
                              disabled={isDisabled}
                              onClick={() => setSlot(s)}
                              className="font-mono text-sm py-2.5 rounded-lg flex items-center justify-center gap-1.5"
                              style={{
                                background: isDisabled ? "transparent" : active ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
                                border: `1px solid ${isDisabled ? COLORS.border : active ? "transparent" : COLORS.border}`,
                                color: isDisabled ? COLORS.muted : active ? COLORS.bg : COLORS.text,
                                opacity: isDisabled ? 0.4 : 1,
                                textDecoration: isDisabled ? "line-through" : "none",
                                cursor: isDisabled ? "not-allowed" : "pointer",
                              }}
                            >
                              <Clock size={12} />
                              {s}
                            </button>
                          );
                        })}
                  </div>
                </>
              )}

              <div className="grid sm:grid-cols-2 gap-3 mb-3">
                <div className="relative">
                  <User size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder={tr("fullName")} aria-label={tr("fullName")} value={name} onChange={(e) => setName(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
                <div className="relative">
                  <Phone size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder={tr("phoneNumber")} aria-label={tr("phoneNumber")} value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
              </div>
              <div className="relative mb-3">
                <Mail size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                <input type="email" placeholder={tr("emailAddress")} aria-label={tr("emailAddress")} value={email} onChange={(e) => setEmail(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>

              <div className="flex gap-2 mb-4">
                <div className="relative flex-1">
                  <Tag size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input
                    placeholder={tr("couponCode")}
                    aria-label={tr("couponCode")}
                    value={couponInput}
                    onChange={(e) => setCouponInput(e.target.value)}
                    disabled={!!couponApplied}
                    className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text, opacity: couponApplied ? 0.6 : 1 }}
                  />
                </div>
                <button
                  onClick={applyCoupon}
                  disabled={couponChecking || !!couponApplied}
                  className="px-4 rounded-lg text-sm font-semibold shrink-0"
                  style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                >
                  {couponChecking ? <Loader2 className="animate-spin" size={14} /> : couponApplied ? `✓ ${couponApplied.discount_percent}%` : tr("apply")}
                </button>
              </div>
              {couponError && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{couponError}</p>}

              {error && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{error}</p>}

              <button
                disabled={!canConfirm}
                onClick={confirmBooking}
                className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                style={{
                  background: canConfirm ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
                  color: canConfirm ? COLORS.bg : COLORS.muted,
                  boxShadow: canConfirm ? `0 10px 26px ${COLORS.glow}` : "none",
                }}
              >
                {submitting ? <Loader2 className="animate-spin" size={18} /> : <>{tr("confirmBooking")} <ChevronRight size={18} /></>}
              </button>
              <p className="flex items-center justify-center gap-1.5 text-xs mt-3" style={{ color: COLORS.muted }}>
                <ShieldCheck size={12} /> {tr("cancellationPolicy")}
              </p>

              {/* Reviews */}
              <div className="mt-6 pt-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
                <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.muted }}>{tr("reviews")}</p>
                {panelReviews.length > 0 && (
                  <div className="space-y-3 mb-4 max-h-48 overflow-y-auto pr-1">
                    {panelReviews.map((r, i) => (
                      <div key={i} className="text-sm">
                        <div className="flex items-center gap-1.5">
                          {Array.from({ length: 5 }).map((_, si) => (
                            <Star key={si} size={12} fill={si < r.rating ? COLORS.accent : "none"} color={COLORS.accent} />
                          ))}
                          <span className="font-semibold text-xs ml-1">{r.customer_name}</span>
                        </div>
                        {r.comment && <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{r.comment}</p>}
                      </div>
                    ))}
                  </div>
                )}
                {reviewDone ? (
                  <p className="text-xs" style={{ color: COLORS.whatsapp }}>{tr("reviewSubmitted")}</p>
                ) : (
                  <form onSubmit={submitReview} className="space-y-2">
                    <div className="flex gap-2">
                      <input
                        placeholder={tr("yourName")}
                        aria-label={tr("yourName")}
                        value={reviewForm.name}
                        onChange={(e) => setReviewForm({ ...reviewForm, name: e.target.value })}
                        className="flex-1 px-3 py-2 rounded-lg text-xs"
                        style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                      />
                      <div className="flex items-center gap-1 px-2 rounded-lg" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}` }}>
                        {Array.from({ length: 5 }).map((_, si) => (
                          <button type="button" key={si} onClick={() => setReviewForm({ ...reviewForm, rating: si + 1 })} aria-label={`${si + 1} star`}>
                            <Star size={14} fill={si < reviewForm.rating ? COLORS.accent : "none"} color={COLORS.accent} />
                          </button>
                        ))}
                      </div>
                    </div>
                    <input
                      placeholder={tr("yourReview")}
                      aria-label={tr("yourReview")}
                      value={reviewForm.comment}
                      onChange={(e) => setReviewForm({ ...reviewForm, comment: e.target.value })}
                      className="w-full px-3 py-2 rounded-lg text-xs"
                      style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    />
                    <button
                      type="submit"
                      disabled={!reviewForm.name.trim() || reviewSubmitting}
                      className="text-xs font-semibold px-3 py-2 rounded-lg"
                      style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    >
                      {reviewSubmitting ? <Loader2 className="animate-spin" size={12} /> : tr("submitReview")}
                    </button>
                  </form>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Category sections */}
      <main className="pb-16">
        {loadingListings ? (
          <div className="flex justify-center py-16">
            <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={28} />
          </div>
        ) : (
          <>
            <div className="flex items-center justify-end gap-2 px-5 max-w-5xl mx-auto mb-1">
              <label className="font-mono text-[11px]" style={{ color: COLORS.muted }} htmlFor="sortSelect">{tr("sortLabel")}:</label>
              <select
                id="sortSelect"
                value={sortOrder}
                onChange={(e) => setSortOrder(e.target.value)}
                className="text-xs font-mono px-2 py-1.5 rounded-md"
                style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
              >
                <option value="default">{tr("sortDefault")}</option>
                <option value="priceAsc">{tr("sortPriceLow")}</option>
                <option value="priceDesc">{tr("sortPriceHigh")}</option>
              </select>
            </div>

            {/* Tours — primary offering, hero-card treatment */}
            {(() => {
              const cat = TOUR_CATEGORY;
              const items = sortListings(allListings[cat.key].filter(matches));
              if (term && items.length === 0) return null;
              return (
                <section id={cat.key} className="pt-6 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto mb-1">
                    <div className="flex items-center gap-2">
                      <cat.icon size={20} color={COLORS.accent} />
                      <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                    </div>
                    <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{tr("toursSectionSubtitle")}</p>
                  </div>
                  {items.length === 0 ? (
                    <p className="text-sm max-w-5xl mx-auto mt-3" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                  ) : (
                    <>
                      <div
                        ref={tourScrollRef}
                        onScroll={handleTourScroll}
                        className="flex gap-4 overflow-x-auto pb-1 pt-4 max-w-5xl mx-auto snap-x snap-mandatory sm:snap-none no-scrollbar"
                      >
                        {items.map((l) => (
                          <TourCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                          />
                        ))}
                      </div>
                      {items.length > 1 && (
                        <div className="flex gap-1.5 justify-center mt-3 sm:hidden" aria-hidden="true">
                          {items.map((_, i) => (
                            <span
                              key={i}
                              className="h-1.5 rounded-full transition-all"
                              style={{
                                width: i === activeTourIndex ? 16 : 6,
                                background: i === activeTourIndex ? COLORS.accent : COLORS.border,
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </>
                  )}
                </section>
              );
            })()}

            {/* Packages — all-inclusive stay + food + sightseeing bundles */}
            {(() => {
              const cat = PACKAGE_CATEGORY;
              const items = sortListings(allListings[cat.key].filter(matches));
              if (term && items.length === 0) return null;
              return (
                <section id={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto mb-1">
                    <div className="flex items-center gap-2">
                      <cat.icon size={20} color={COLORS.accent} />
                      <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                    </div>
                    <p className="text-xs mt-0.5" style={{ color: COLORS.muted }}>{tr("packagesSectionSubtitle")}</p>
                  </div>
                  {items.length === 0 ? (
                    <p className="text-sm max-w-5xl mx-auto mt-3" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                  ) : (
                    <>
                      <div
                        ref={packageScrollRef}
                        onScroll={handlePackageScroll}
                        className="flex gap-4 overflow-x-auto pb-1 pt-4 max-w-5xl mx-auto snap-x snap-mandatory sm:snap-none no-scrollbar"
                      >
                        {items.map((l) => (
                          <TourCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                          />
                        ))}
                      </div>
                      {items.length > 1 && (
                        <div className="flex gap-1.5 justify-center mt-3 sm:hidden" aria-hidden="true">
                          {items.map((_, i) => (
                            <span
                              key={i}
                              className="h-1.5 rounded-full transition-all"
                              style={{
                                width: i === activePackageIndex ? 16 : 6,
                                background: i === activePackageIndex ? COLORS.accent : COLORS.border,
                              }}
                            />
                          ))}
                        </div>
                      )}
                    </>
                  )}
                </section>
              );
            })()}

            {/* Travels — flexible chauffeur-driven roaming, not a fixed itinerary */}
            {(() => {
              const cat = TRAVEL_CATEGORY;
              const allItems = sortListings(allListings[cat.key].filter(matches));
              if (term && allItems.length === 0) return null;
              const isExpanded = !!expandedCats[cat.key];
              const items = isExpanded ? allItems : allItems.slice(0, 3);
              return (
                <section id={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                  <div className="max-w-5xl mx-auto">
                    <div className="flex items-center justify-between mb-1">
                      <div className="flex items-center gap-2">
                        <cat.icon size={20} color={COLORS.accent} />
                        <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                      </div>
                      {allItems.length > 3 && (
                        <button onClick={() => toggleExpanded(cat.key)} className="text-xs font-mono" style={{ color: COLORS.accent }}>
                          {isExpanded ? tr("showLess") : `${tr("viewAll")} (${allItems.length})`}
                        </button>
                      )}
                    </div>
                    <p className="text-xs mb-4" style={{ color: COLORS.muted }}>{tr("travelsSectionSubtitle")}</p>
                    {items.length === 0 ? (
                      <p className="text-sm" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                    ) : (
                      <div className="grid grid-cols-3 gap-2 sm:gap-3">
                        {items.map((l) => (
                          <PhotoCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookingCount={bookingCounts[l.id] || 0}
                            popularLabel={tr("popular")}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            addToTripLabel={tr("addToTrip")}
                            addedToTripLabel={tr("addedToTrip")}
                            inTrip={isInTrip(l.id)}
                            onToggleTrip={() => toggleTrip(l, cat.key)}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                            onCardClick={() => setDetailListing({ listing: l, category: cat })}
                            layout="grid"
                          />
                        ))}
                      </div>
                    )}
                  </div>
                </section>
              );
            })()}

            {/* Vehicle rental — supporting service, contained in its own panel */}
            <div className="pt-8 px-5">
              <div
                className="max-w-5xl mx-auto rounded-2xl p-4 sm:p-5"
                style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
              >
                <div className="text-center mb-5">
                  <p className="font-mono text-xs tracking-widest mb-1" style={{ color: COLORS.accent }}>{tr("vehicleRentalHeading")}</p>
                  <p className="text-sm" style={{ color: COLORS.muted }}>{tr("vehicleRentalSubtitle")}</p>
                </div>

                {VEHICLE_CATEGORIES.map((cat, i) => {
                  const allItems = sortListings(allListings[cat.key].filter(matches));
                  if (term && allItems.length === 0) return null;
                  const isExpanded = !!expandedCats[cat.key];
                  const items = isExpanded ? allItems : allItems.slice(0, 3);
                  return (
                    <section id={cat.key} key={cat.key} className={i > 0 ? "mt-6 pt-6" : ""} style={{ scrollMarginTop: "72px", borderTop: i > 0 ? `1px solid ${COLORS.border}` : "none" }}>
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center gap-2">
                          <cat.icon size={17} color={COLORS.accent} />
                          <h3 className="font-display text-lg">{tr(cat.labelKey)}</h3>
                        </div>
                        {allItems.length > 3 && (
                          <button onClick={() => toggleExpanded(cat.key)} className="text-xs font-mono" style={{ color: COLORS.accent }}>
                            {isExpanded ? tr("showLess") : `${tr("viewAll")} (${allItems.length})`}
                          </button>
                        )}
                      </div>
                      {items.length === 0 ? (
                        <p className="text-sm" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                      ) : (
                        <div className="grid grid-cols-3 gap-2 sm:gap-3">
                          {items.map((l) => (
                            <PhotoCard
                              key={l.id}
                              listing={l}
                              category={cat}
                              colors={COLORS}
                              stats={reviewStats[l.id]}
                              bookingCount={bookingCounts[l.id] || 0}
                              popularLabel={tr("popular")}
                              bookLabel={tr("book")}
                              selectedLabel={tr("selected")}
                              addToTripLabel={tr("addToTrip")}
                              addedToTripLabel={tr("addedToTrip")}
                              inTrip={isInTrip(l.id)}
                              onToggleTrip={() => toggleTrip(l, cat.key)}
                              selected={selected && selected.listingId === l.id}
                              onBook={() => chooseListing(cat.key, l.id)}
                              layout="grid"
                            />
                          ))}
                        </div>
                      )}
                    </section>
                  );
                })}
              </div>
            </div>
          </>
        )}
      </main>

      {/* Footer */}
      <footer className="px-6 py-10 flex flex-col items-center gap-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>{tr("questionsReachUs")}</p>
        <div className="flex gap-3 flex-wrap justify-center">
          <a href={`https://wa.me/${BUSINESS.whatsapp}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <MessageCircle size={16} color={COLORS.whatsapp} /> WhatsApp
          </a>
          <a href={`https://instagram.com/${BUSINESS.instagram}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Instagram size={16} color={COLORS.accent} /> Instagram
          </a>
          <a href={`https://facebook.com/${BUSINESS.facebook}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Facebook size={16} color={COLORS.accent} /> Facebook
          </a>
        </div>
        <a href="/lookup" className="flex items-center gap-1.5 text-xs font-mono" style={{ color: COLORS.muted }}>
          <ClipboardList size={13} /> {tr("checkBooking")}
        </a>
        <a href="/admin/login" className="text-xs font-mono opacity-40" style={{ color: COLORS.muted }}>{tr("admin")}</a>
      </footer>

      {/* Floating Trip Builder button */}
      {myTrip.length > 0 && !tripPanelOpen && (
        <button
          onClick={() => setTripPanelOpen(true)}
          className="fixed bottom-5 right-5 z-30 flex items-center gap-2 px-5 py-3.5 rounded-full font-semibold text-sm"
          style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg, boxShadow: `0 12px 30px ${COLORS.glow}` }}
        >
          <Briefcase size={16} /> {tr("myTrip")} ({myTrip.length})
        </button>
      )}

      {tripPanelOpen && (
        <div className="fixed inset-0 z-40 flex items-end sm:items-center justify-center p-0 sm:p-6" style={{ background: "rgba(0,0,0,0.6)" }}>
          <div
            className="w-full sm:max-w-md max-h-[85vh] overflow-y-auto rounded-t-3xl sm:rounded-3xl p-5"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-2xl flex items-center gap-2"><Briefcase size={18} color={COLORS.accent} /> {tr("myTrip")}</h2>
              <button onClick={() => { setTripPanelOpen(false); setTripSent(false); }} aria-label="Close">
                <X size={18} color={COLORS.muted} />
              </button>
            </div>

            {tripSent ? (
              <p className="text-sm py-6 text-center" style={{ color: COLORS.whatsapp }}>{tr("tripRequestSent")}</p>
            ) : myTrip.length === 0 ? (
              <p className="text-sm" style={{ color: COLORS.muted }}>{tr("tripEmpty")}</p>
            ) : (
              <>
                <div className="space-y-2 mb-5">
                  {myTrip.map((item) => (
                    <div key={item.listingId} className="flex items-center justify-between p-3 rounded-lg" style={{ background: COLORS.surface2 }}>
                      <div>
                        <p className="text-sm font-semibold">{item.name}</p>
                        <p className="font-mono text-xs" style={{ color: COLORS.muted }}>₹{item.price}{item.unit}</p>
                      </div>
                      <button onClick={() => removeFromTrip(item.listingId)} aria-label={tr("removeFromTrip")}>
                        <Trash2 size={15} color={COLORS.danger} />
                      </button>
                    </div>
                  ))}
                </div>
                <form onSubmit={sendTripRequest} className="space-y-2.5">
                  <input
                    placeholder={tr("fullName")}
                    value={tripForm.name}
                    onChange={(e) => setTripForm({ ...tripForm, name: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <input
                    placeholder={tr("phoneNumber")}
                    value={tripForm.phone}
                    onChange={(e) => setTripForm({ ...tripForm, phone: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <input
                    type="email"
                    placeholder={tr("emailAddress")}
                    value={tripForm.email}
                    onChange={(e) => setTripForm({ ...tripForm, email: e.target.value })}
                    className="w-full px-3 py-2.5 rounded-lg text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <button
                    type="submit"
                    disabled={tripSubmitting || !tripForm.name.trim() || !tripForm.phone.trim()}
                    className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                    style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg }}
                  >
                    {tripSubmitting ? <Loader2 className="animate-spin" size={16} /> : tr("sendTripRequest")}
                  </button>
                </form>
              </>
            )}
          </div>
        </div>
      )}

      {/* Tour detail popup */}
      {detailListing && (
        <div className="fixed inset-0 z-40 flex items-end sm:items-center justify-center p-0 sm:p-6" style={{ background: "rgba(0,0,0,0.6)" }} onClick={() => setDetailListing(null)}>
          <div
            className="w-full sm:max-w-lg max-h-[85vh] overflow-y-auto rounded-t-3xl sm:rounded-3xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="h-48 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${detailListing.category.tint}, ${COLORS.surface2})` }}>
              {detailListing.listing.image_url ? (
                <img src={detailListing.listing.image_url} alt={detailListing.listing.name} className="w-full h-full object-cover" />
              ) : (
                <detailListing.category.icon size={54} color={COLORS.accent} />
              )}
              <button
                onClick={() => setDetailListing(null)}
                aria-label="Close"
                className="absolute top-3 right-3 w-8 h-8 rounded-full flex items-center justify-center"
                style={{ background: "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
              >
                <X size={16} color="#F2F0EA" />
              </button>
            </div>
            <div className="p-5">
              <div className="flex items-center justify-between mb-1">
                <h2 className="font-display text-2xl leading-tight pr-3">{detailListing.listing.name}</h2>
              </div>
              <p className="font-mono text-sm mb-1">
                <span style={{ color: COLORS.accent }}>₹{detailListing.listing.price}</span>
                <span style={{ color: COLORS.muted }}>{detailListing.listing.unit}</span>
              </p>
              <p className="font-mono text-xs mb-4" style={{ color: COLORS.muted }}>
                {detailListing.listing.tag}{detailListing.listing.hours ? ` · ${detailListing.listing.hours}h` : ""}
              </p>

              {(() => {
                const localizedDescription =
                  (lang !== "en" && detailListing.listing[`description_${lang}`]) || detailListing.listing.description;
                const localizedRequirements =
                  (lang !== "en" && detailListing.listing[`requirements_${lang}`]) || detailListing.listing.requirements;
                return (
                  <>
                    {localizedDescription && (
                      <div className="mb-4">
                        <p className="font-mono text-xs tracking-widest mb-1.5" style={{ color: COLORS.muted }}>{tr("aboutThisTour")}</p>
                        <p className="text-sm leading-relaxed" style={{ color: COLORS.text }}>{localizedDescription}</p>
                      </div>
                    )}
                    {localizedRequirements && (
                      <div className="mb-4">
                        <p className="font-mono text-xs tracking-widest mb-1.5" style={{ color: COLORS.muted }}>{tr("whatToKnow")}</p>
                        <p className="text-sm leading-relaxed" style={{ color: COLORS.text }}>{localizedRequirements}</p>
                      </div>
                    )}
                  </>
                );
              })()}

              <p className="flex items-center gap-1.5 text-xs mb-5" style={{ color: COLORS.muted }}>
                <ShieldCheck size={12} /> {tr("cancellationPolicy")}
              </p>

              <button
                onClick={() => {
                  chooseListing(detailListing.category.key, detailListing.listing.id);
                  setDetailListing(null);
                }}
                className="w-full py-3.5 rounded-xl font-semibold flex items-center justify-center gap-2"
                style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg, boxShadow: `0 10px 26px ${COLORS.glow}` }}
              >
                {tr("bookNow")} <ChevronRight size={18} />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function PhotoCard({ listing, category, colors, stats, bookingCount, popularLabel, bookLabel, selectedLabel, addToTripLabel, addedToTripLabel, inTrip, onToggleTrip, selected, onBook, onCardClick, layout = "scroll" }) {
  const Icon = category.icon;
  const isPopular = bookingCount >= 3;
  const isGrid = layout === "grid";
  return (
    <div
      onClick={onCardClick}
      role={onCardClick ? "button" : undefined}
      tabIndex={onCardClick ? 0 : undefined}
      onKeyDown={onCardClick ? (e) => { if (e.key === "Enter") onCardClick(); } : undefined}
      className={`${isGrid ? "w-full" : "shrink-0 w-52 sm:w-56"} rounded-2xl overflow-hidden flex flex-col ${onCardClick ? "cursor-pointer" : ""}`}
      style={{ background: colors.surface, border: `1px solid ${selected ? colors.accent : colors.border}`, boxShadow: selected ? `0 8px 24px ${colors.glow}` : "0 2px 8px rgba(0,0,0,0.15)" }}
    >
      <div className="h-28 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${category.tint}, ${colors.surface2})` }}>
        {listing.image_url ? (
          <img src={listing.image_url} alt={listing.name} loading="lazy" decoding="async" className="w-full h-full object-cover relative z-10" />
        ) : (
          <>
            <div className="absolute inset-0" style={{ opacity: 0.14 }}>
              <Icon size={26} color={colors.text} style={{ position: "absolute", top: 8, left: 10, transform: "rotate(-12deg)" }} />
              <Icon size={22} color={colors.text} style={{ position: "absolute", bottom: 10, left: 46, transform: "rotate(8deg)" }} />
              <Icon size={30} color={colors.text} style={{ position: "absolute", top: 18, right: 14, transform: "rotate(15deg)" }} />
              <Icon size={20} color={colors.text} style={{ position: "absolute", bottom: 14, right: 50, transform: "rotate(-10deg)" }} />
            </div>
            <Icon size={38} color={colors.accent} style={{ position: "relative", filter: `drop-shadow(0 2px 8px ${colors.glow})` }} />
          </>
        )}
        <button
          onClick={(e) => { e.stopPropagation(); onToggleTrip(); }}
          aria-label={inTrip ? addedToTripLabel : addToTripLabel}
          title={inTrip ? addedToTripLabel : addToTripLabel}
          className="absolute top-2 left-2 z-10 w-7 h-7 rounded-full flex items-center justify-center"
          style={{ background: inTrip ? colors.accent : "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
        >
          {inTrip ? <Check size={14} color={colors.bg} /> : <Plus size={14} color="#F2F0EA" />}
        </button>
        <span className="absolute top-2 right-2 font-mono text-[10px] px-2 py-1 rounded-full z-10" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
        <div className="absolute bottom-2 left-2 right-2 flex items-center justify-between z-10">
          {stats && stats.review_count > 0 ? (
            <span className="font-mono text-[10px] px-2 py-1 rounded-full flex items-center gap-1" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
              <Star size={10} fill={colors.accent} color={colors.accent} /> {stats.avg_rating} ({stats.review_count})
            </span>
          ) : <span />}
          {isPopular && (
            <span className="font-mono text-[10px] px-2 py-1 rounded-full" style={{ background: colors.accent, color: colors.bg }}>
              {popularLabel}
            </span>
          )}
        </div>
      </div>
      <div className={`${isGrid ? "p-3" : "p-3.5"} flex flex-col flex-1`}>
        <p className="font-semibold text-sm leading-tight mb-1.5 line-clamp-2" style={{ color: colors.text }}>{listing.name}</p>
        <p className="font-mono text-sm mb-3">
          <span style={{ color: colors.accent }}>₹{listing.price}</span>
          <span style={{ color: colors.muted }}>{listing.unit}</span>
        </p>
        <button
          onClick={(e) => { e.stopPropagation(); onBook(); }}
          className="mt-auto w-full py-2 rounded-lg text-sm font-semibold"
          style={{
            background: selected ? `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})` : colors.surface2,
            color: selected ? colors.bg : colors.text,
            border: selected ? "none" : `1px solid ${colors.border}`,
          }}
        >
          {selected ? selectedLabel : bookLabel}
        </button>
      </div>
    </div>
  );
}

function TourCard({ listing, category, colors, stats, bookingCount, popularLabel, bookLabel, selectedLabel, addToTripLabel, addedToTripLabel, inTrip, onToggleTrip, selected, onBook, onCardClick }) {
  const Icon = category.icon;
  const isPopular = bookingCount >= 3;
  return (
    <div
      onClick={onCardClick}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => { if (e.key === "Enter") onCardClick(); }}
      className="shrink-0 rounded-2xl overflow-hidden flex flex-col snap-start cursor-pointer"
      style={{
        width: "86%",
        maxWidth: 340,
        background: colors.surface,
        border: `1px solid ${selected ? colors.accent : colors.border}`,
        boxShadow: selected ? `0 8px 24px ${colors.glow}` : "0 4px 16px rgba(0,0,0,0.18)",
      }}
    >
      <div className="h-44 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${category.tint}, ${colors.surface2})` }}>
        {listing.image_url ? (
          <img src={listing.image_url} alt={listing.name} loading="lazy" decoding="async" className="w-full h-full object-cover relative z-10" />
        ) : (
          <>
            <div className="absolute inset-0" style={{ opacity: 0.14 }}>
              <Icon size={30} color={colors.text} style={{ position: "absolute", top: 10, left: 14, transform: "rotate(-12deg)" }} />
              <Icon size={24} color={colors.text} style={{ position: "absolute", bottom: 14, left: 56, transform: "rotate(8deg)" }} />
              <Icon size={34} color={colors.text} style={{ position: "absolute", top: 22, right: 18, transform: "rotate(15deg)" }} />
              <Icon size={22} color={colors.text} style={{ position: "absolute", bottom: 18, right: 60, transform: "rotate(-10deg)" }} />
            </div>
            <Icon size={46} color={colors.accent} style={{ position: "relative", filter: `drop-shadow(0 2px 8px ${colors.glow})` }} />
          </>
        )}
        {/* Duration badge, overlaid on the photo */}
        <span className="absolute top-2.5 left-2.5 font-mono text-[10px] px-2.5 py-1 rounded-full z-10" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
        {/* Save-for-trip button, labeled */}
        <button
          onClick={(e) => { e.stopPropagation(); onToggleTrip(); }}
          aria-label={inTrip ? addedToTripLabel : addToTripLabel}
          title={inTrip ? addedToTripLabel : addToTripLabel}
          className="absolute top-2.5 right-2.5 z-10 w-8 h-8 rounded-full flex items-center justify-center"
          style={{ background: inTrip ? colors.accent : "rgba(20,24,28,0.75)", backdropFilter: "blur(4px)" }}
        >
          {inTrip ? <Check size={15} color={colors.bg} /> : <Plus size={15} color="#F2F0EA" />}
        </button>
        {isPopular && (
          <span className="absolute bottom-2.5 left-2.5 font-mono text-[10px] px-2.5 py-1 rounded-full z-10" style={{ background: colors.accent, color: colors.bg }}>
            {popularLabel}
          </span>
        )}
      </div>
      <div className="p-4 flex flex-col flex-1">
        <p className="font-semibold text-base leading-tight mb-1.5" style={{ color: colors.text }}>{listing.name}</p>
        {stats && stats.review_count > 0 && (
          <div className="flex items-center gap-1 text-xs mb-3" style={{ color: colors.muted }}>
            <Star size={12} fill={colors.accent} color={colors.accent} />
            {stats.avg_rating} · {stats.review_count} {stats.review_count === 1 ? "review" : "reviews"}
          </div>
        )}
        <div className="mt-auto flex items-center justify-between gap-3">
          <p className="font-mono text-base">
            <span style={{ color: colors.accent }}>₹{listing.price}</span>
            <span className="text-sm" style={{ color: colors.muted }}>{listing.unit}</span>
          </p>
          <button
            onClick={(e) => { e.stopPropagation(); onBook(); }}
            className="py-2 px-5 rounded-lg text-sm font-semibold shrink-0"
            style={{
              background: selected ? `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})` : colors.surface2,
              color: selected ? colors.bg : colors.text,
              border: selected ? "none" : `1px solid ${colors.border}`,
            }}
          >
            {selected ? selectedLabel : bookLabel}
          </button>
        </div>
      </div>
    </div>

  );
}

function TicketView({ ticket, waLink, onReset, colors, business, tr }) {
  return (
    <div className="max-w-md mx-auto animate-fade-up">
      <div className="rounded-3xl overflow-hidden mx-auto" style={{ background: `linear-gradient(160deg, ${colors.surface}, ${colors.surface2})`, border: `1px solid ${colors.border}`, boxShadow: `0 20px 50px rgba(0,0,0,0.4)` }}>
        <div className="p-6 flex items-center gap-3" style={{ background: `linear-gradient(135deg, rgba(245,183,0,0.18), rgba(245,183,0,0.04))` }}>
          <div className="w-9 h-9 rounded-full flex items-center justify-center" style={{ background: `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})`, boxShadow: `0 4px 14px ${colors.glow}` }}>
            <Check size={18} color={colors.bg} strokeWidth={3} />
          </div>
          <span className="font-display text-3xl">{ticket.multiDay ? "TRIP RESERVED" : ticket.type === "tour" ? "SEAT RESERVED" : "SLOT RESERVED"}</span>
        </div>
        <div className="px-6 py-5 font-mono text-sm space-y-3" style={{ color: colors.text }}>
          <Row label={ticket.type === "tour" ? "PACKAGE" : "VEHICLE"} value={ticket.vehicle} colors={colors} />
          <Row label="DATE" value={ticket.date} colors={colors} />
          <Row label={ticket.multiDay ? "DURATION" : "TIME"} value={ticket.slot} colors={colors} />
          <Row label="TOTAL" value={`₹${ticket.price}${ticket.unit || ""}`} colors={colors} />
          {ticket.type === "tour" && ticket.hours && <Row label="INFO" value={`${ticket.tag} · ${ticket.hours} hrs`} colors={colors} />}
          <Row label="NAME" value={ticket.name} colors={colors} />
          <Row label="PHONE" value={ticket.phone} colors={colors} />
          <Row label="EMAIL" value={ticket.email} colors={colors} />
        </div>
        <div className="relative h-0 border-t border-dashed" style={{ borderColor: colors.border }}>
          <div className="absolute -left-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
          <div className="absolute -right-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
        </div>
        <div className="px-6 py-5 flex items-center justify-between">
          <span className="text-xs font-mono" style={{ color: colors.muted }}>CODE</span>
          <span className="font-display text-3xl tracking-[0.15em]" style={{ color: colors.accent }}>{ticket.code}</span>
        </div>
        <div className="flex justify-center pb-6">
          <div className="p-2 rounded-xl" style={{ background: "#fff" }}>
            <img
              src={`https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=${encodeURIComponent(`${business.name} booking ${ticket.code}`)}`}
              alt="Booking QR code"
              width="140"
              height="140"
              loading="lazy"
            />
          </div>
        </div>
      </div>
      <p className="text-center text-sm mt-6" style={{ color: colors.muted }}>Send this to {business.name} on WhatsApp to finalize pickup details.</p>
      <a href={waLink} target="_blank" rel="noreferrer" className="w-full mt-4 py-4 rounded-xl font-semibold flex items-center justify-center gap-2" style={{ background: colors.whatsapp, color: "#0B1A0F", boxShadow: "0 10px 30px rgba(37,211,102,0.3)" }}>
        <MessageCircle size={18} /> Confirm via WhatsApp
      </a>
      <button onClick={onReset} className="w-full mt-3 py-3.5 rounded-xl text-sm font-medium" style={{ background: "transparent", border: `1px solid ${colors.border}`, color: colors.muted }}>
        Book another slot
      </button>
    </div>
  );
}

function Row({ label, value, colors }) {
  return (
    <div className="flex items-center justify-between">
      <span style={{ color: colors.muted }}>{label}</span>
      <span>{value}</span>
    </div>
  );
}

FILEEOF

cat > src/pages/AdminDashboard.jsx <<'FILEEOF'
import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { LogOut, Plus, Pencil, Trash2, X, Loader2, ListChecks, CalendarDays, Tag, Star, BarChart3, Check as CheckIcon, Briefcase } from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";

const EMPTY_FORM = { category: "bike", name: "", price: "", unit: "/hr", tag: "", hours: "", active: true, image_url: "", description: "", requirements: "" };

export default function AdminDashboard() {
  const { colors: COLORS } = useTheme();
  const [session, setSession] = useState(undefined); // undefined = checking, null = logged out
  const [tab, setTab] = useState("listings");
  const navigate = useNavigate();

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => setSession(data.session));
    const { data: sub } = supabase.auth.onAuthStateChange((_event, s) => setSession(s));
    return () => sub.subscription.unsubscribe();
  }, []);

  useEffect(() => {
    if (session === null) navigate("/admin/login");
  }, [session, navigate]);

  async function logout() {
    await supabase.auth.signOut();
    navigate("/admin/login");
  }

  if (session === undefined) {
    return (
      <div className="min-h-screen flex items-center justify-center" style={{ background: COLORS.bg }}>
        <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={28} />
      </div>
    );
  }
  if (!session) return null; // redirecting

  return (
    <div className="min-h-screen" style={{ background: COLORS.bg, color: COLORS.text }}>
      <header className="flex items-center justify-between px-6 py-5 border-b" style={{ borderColor: COLORS.border }}>
        <div>
          <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.accent }}>{BUSINESS.name.toUpperCase()}</p>
          <h1 className="font-display text-3xl leading-none">ADMIN</h1>
        </div>
        <div className="flex items-center gap-3">
          <ThemeToggle />
          <button onClick={logout} className="flex items-center gap-2 px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.muted }}>
            <LogOut size={14} /> Log out
          </button>
        </div>
      </header>

      <div className="px-6 pt-5">
        <div className="flex p-1 rounded-md mb-6 w-fit" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
          {[
            { id: "listings", label: "Listings", icon: ListChecks },
            { id: "bookings", label: "Bookings", icon: CalendarDays },
            { id: "trips", label: "Trip Requests", icon: Briefcase },
            { id: "coupons", label: "Coupons", icon: Tag },
            { id: "reviews", label: "Reviews", icon: Star },
            { id: "analytics", label: "Analytics", icon: BarChart3 },
          ].map(({ id, label, icon: Icon }) => (
            <button
              key={id}
              onClick={() => setTab(id)}
              className="flex items-center gap-2 px-5 py-2 rounded text-sm font-semibold"
              style={{ background: tab === id ? COLORS.accent : "transparent", color: tab === id ? COLORS.bg : COLORS.muted }}
            >
              <Icon size={16} /> {label}
            </button>
          ))}
        </div>
      </div>

      <div className="px-6 pb-16">
        {tab === "listings" && <ListingsTab />}
        {tab === "bookings" && <BookingsTab />}
        {tab === "trips" && <TripRequestsTab />}
        {tab === "coupons" && <CouponsTab />}
        {tab === "reviews" && <ReviewsTab />}
        {tab === "analytics" && <AnalyticsTab />}
      </div>
    </div>
  );
}

function ListingsTab() {
  const { colors: COLORS } = useTheme();
  const [listings, setListings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState(null); // null = closed, object = editing/creating
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  async function load() {
    setLoading(true);
    const { data, error: err } = await supabase.from("listings").select("*").order("category").order("price");
    if (!err) setListings(data || []);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, []);

  function openNew() {
    setForm({ ...EMPTY_FORM });
    setError("");
  }
  function openEdit(l) {
    setForm({ ...l, price: String(l.price), hours: l.hours == null ? "" : String(l.hours), image_url: l.image_url || "", description: l.description || "", requirements: l.requirements || "" });
    setError("");
  }

  async function save(e) {
    e.preventDefault();
    setSaving(true);
    setError("");
    const payload = {
      category: form.category,
      name: form.name.trim(),
      price: Number(form.price),
      unit: form.unit,
      tag: form.tag.trim(),
      hours: form.hours === "" ? null : Number(form.hours),
      active: form.active,
      image_url: form.image_url.trim() || null,
      description: form.description.trim() || null,
      requirements: form.requirements.trim() || null,
    };
    if (!payload.name || Number.isNaN(payload.price)) {
      setError("Name and a valid price are required.");
      setSaving(false);
      return;
    }

    const result = form.id
      ? await supabase.from("listings").update(payload).eq("id", form.id)
      : await supabase.from("listings").insert(payload);

    setSaving(false);
    if (result.error) {
      setError("Couldn't save — please try again.");
      return;
    }
    setForm(null);
    load();
  }

  async function remove(id) {
    if (!window.confirm("Delete this listing? This can't be undone.")) return;
    await supabase.from("listings").delete().eq("id", id);
    load();
  }

  async function toggleActive(l) {
    await supabase.from("listings").update({ active: !l.active }).eq("id", l.id);
    load();
  }

  return (
    <div className="max-w-4xl">
      <div className="flex justify-between items-center mb-4">
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>
          {listings.length} LISTING{listings.length === 1 ? "" : "S"}
        </p>
        <button onClick={openNew} className="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-semibold" style={{ background: COLORS.accent, color: COLORS.bg }}>
          <Plus size={16} /> Add listing
        </button>
      </div>

      {loading ? (
        <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />
      ) : (
        <div className="rounded-lg overflow-hidden" style={{ border: `1px solid ${COLORS.border}` }}>
          {listings.map((l) => (
            <div key={l.id} className="flex items-center justify-between px-4 py-3 border-b last:border-b-0" style={{ borderColor: COLORS.border, background: COLORS.surface, opacity: l.active ? 1 : 0.5 }}>
              <div className="min-w-0">
                <p className="text-sm font-semibold truncate">{l.name}</p>
                <p className="font-mono text-xs" style={{ color: COLORS.muted }}>
                  {l.category} · ₹{l.price}{l.unit} · {l.tag}{l.hours ? ` · ${l.hours} hrs` : ""} {!l.active && "· inactive"}
                </p>
              </div>
              <div className="flex items-center gap-2 shrink-0">
                <button onClick={() => toggleActive(l)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.muted }}>
                  {l.active ? "Hide" : "Show"}
                </button>
                <button onClick={() => openEdit(l)} className="p-2 rounded" style={{ background: COLORS.surface2 }}>
                  <Pencil size={14} color={COLORS.text} />
                </button>
                <button onClick={() => remove(l.id)} className="p-2 rounded" style={{ background: COLORS.surface2 }}>
                  <Trash2 size={14} color={COLORS.danger} />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {form && (
        <div className="fixed inset-0 flex items-center justify-center p-6" style={{ background: "rgba(0,0,0,0.6)" }}>
          <form onSubmit={save} className="w-full max-w-md p-5 rounded-lg" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-2xl">{form.id ? "EDIT LISTING" : "NEW LISTING"}</h2>
              <button type="button" onClick={() => setForm(null)}>
                <X size={18} color={COLORS.muted} />
              </button>
            </div>

            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>CATEGORY</label>
            <select
              value={form.category}
              onChange={(e) => setForm({ ...form, category: e.target.value })}
              className="w-full mb-3 px-3 py-2 rounded-md text-sm"
              style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
            >
              <option value="bike">Bike</option>
              <option value="car">Car</option>
              <option value="bus">Bus</option>
              <option value="tour">Tour</option>
              <option value="package">Package</option>
              <option value="travel">Travel</option>
            </select>

            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>NAME</label>
            <input value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} className="w-full mb-3 px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />

            <div className="grid grid-cols-2 gap-3 mb-3">
              <div>
                <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>PRICE (₹)</label>
                <input type="number" value={form.price} onChange={(e) => setForm({ ...form, price: e.target.value })} className="w-full px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>
              <div>
                <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>UNIT</label>
                <select value={form.unit} onChange={(e) => setForm({ ...form, unit: e.target.value })} className="w-full px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
                  <option value="/hr">/hr</option>
                  <option value="/day">/day</option>
                  <option value="/person">/person</option>
                </select>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 mb-3">
              <div>
                <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>TAG</label>
                <input value={form.tag} onChange={(e) => setForm({ ...form, tag: e.target.value })} placeholder="e.g. SUV, Half-day" className="w-full px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>
              <div>
                <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>HOURS (optional)</label>
                <input type="number" value={form.hours} onChange={(e) => setForm({ ...form, hours: e.target.value })} className="w-full px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>
            </div>

            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>IMAGE URL (optional)</label>
            <input
              value={form.image_url}
              onChange={(e) => setForm({ ...form, image_url: e.target.value })}
              placeholder="https://..."
              className="w-full mb-3 px-3 py-2 rounded-md text-sm"
              style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
            />
            <p className="text-xs mb-3" style={{ color: COLORS.muted }}>Leave blank to show a styled placeholder instead.</p>

            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>DESCRIPTION (shown in the tour popup)</label>
            <textarea
              value={form.description}
              onChange={(e) => setForm({ ...form, description: e.target.value })}
              placeholder="What does this tour/vehicle include? What's the experience like?"
              rows={3}
              className="w-full mb-3 px-3 py-2 rounded-md text-sm"
              style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
            />

            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>REQUIREMENTS / RULES (optional)</label>
            <textarea
              value={form.requirements}
              onChange={(e) => setForm({ ...form, requirements: e.target.value })}
              placeholder="Age limits, what to bring, fitness level, ID requirements, etc."
              rows={3}
              className="w-full mb-4 px-3 py-2 rounded-md text-sm"
              style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
            />

            <label className="flex items-center gap-2 mb-4 text-sm">
              <input type="checkbox" checked={form.active} onChange={(e) => setForm({ ...form, active: e.target.checked })} />
              Visible to customers
            </label>

            {error && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{error}</p>}

            <button type="submit" disabled={saving} className="w-full py-2.5 rounded-md font-semibold flex items-center justify-center gap-2" style={{ background: COLORS.accent, color: COLORS.bg }}>
              {saving ? <Loader2 className="animate-spin" size={16} /> : "Save"}
            </button>
          </form>
        </div>
      )}
    </div>
  );
}

function BookingsTab() {
  const { colors: COLORS } = useTheme();
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [notifyState, setNotifyState] = useState({}); // id -> "sending" | "sent" | "failed"

  async function load() {
    setLoading(true);
    const { data, error } = await supabase
      .from("bookings")
      .select("*, listings(name, category)")
      .order("booking_date", { ascending: false })
      .order("slot_time", { ascending: true });
    if (!error) setBookings(data || []);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, []);

  async function cancel(booking) {
    await supabase.from("bookings").update({ status: "cancelled" }).eq("id", booking.id);
    load();

    if (!booking.customer_email) return; // nothing to notify

    setNotifyState((s) => ({ ...s, [booking.id]: "sending" }));
    try {
      const { error } = await supabase.functions.invoke("notify-cancellation", {
        body: {
          name: booking.customer_name,
          email: booking.customer_email,
          date: booking.booking_date,
          slot: booking.slot_time,
          listingName: booking.listings?.name || "your booking",
          code: booking.code,
        },
      });
      setNotifyState((s) => ({ ...s, [booking.id]: error ? "failed" : "sent" }));
    } catch {
      setNotifyState((s) => ({ ...s, [booking.id]: "failed" }));
    }
  }

  if (loading) return <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />;

  return (
    <div className="max-w-5xl">
      <p className="font-mono text-xs tracking-widest mb-4" style={{ color: COLORS.muted }}>
        {bookings.length} BOOKING{bookings.length === 1 ? "" : "S"}
      </p>
      <div className="rounded-lg overflow-x-auto" style={{ border: `1px solid ${COLORS.border}` }}>
        <table className="w-full text-sm">
          <thead>
            <tr className="font-mono text-xs" style={{ color: COLORS.muted, background: COLORS.surface2 }}>
              <th className="text-left px-3 py-2">Date</th>
              <th className="text-left px-3 py-2">Time</th>
              <th className="text-left px-3 py-2">Item</th>
              <th className="text-left px-3 py-2">Customer</th>
              <th className="text-left px-3 py-2">Phone</th>
              <th className="text-left px-3 py-2">Email</th>
              <th className="text-left px-3 py-2">Code</th>
              <th className="text-left px-3 py-2">Status</th>
              <th className="text-left px-3 py-2"></th>
            </tr>
          </thead>
          <tbody>
            {bookings.map((b) => (
              <tr key={b.id} style={{ background: COLORS.surface, opacity: b.status === "cancelled" ? 0.5 : 1 }} className="border-t" >
                <td className="px-3 py-2 font-mono" style={{ borderColor: COLORS.border }}>{b.booking_date}</td>
                <td className="px-3 py-2 font-mono">{b.slot_time}</td>
                <td className="px-3 py-2">{b.listings?.name || "—"} <span style={{ color: COLORS.muted }}>({b.listings?.category})</span></td>
                <td className="px-3 py-2">{b.customer_name}</td>
                <td className="px-3 py-2 font-mono" style={{ fontSize: "11px" }}>{b.customer_email || "—"}</td>
                <td className="px-3 py-2 font-mono">{b.customer_phone}</td>
                <td className="px-3 py-2 font-mono" style={{ color: COLORS.accent }}>{b.code}</td>
                <td className="px-3 py-2 capitalize">{b.status}</td>
                <td className="px-3 py-2">
                  {b.status === "confirmed" && (
                    <button onClick={() => cancel(b)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.danger }}>
                      Cancel
                    </button>
                  )}
                  {notifyState[b.id] === "sending" && <span className="text-xs font-mono ml-2" style={{ color: COLORS.muted }}>notifying…</span>}
                  {notifyState[b.id] === "sent" && <span className="text-xs font-mono ml-2" style={{ color: COLORS.whatsapp }}>notified</span>}
                  {notifyState[b.id] === "failed" && <span className="text-xs font-mono ml-2" style={{ color: COLORS.danger }}>notify failed</span>}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

function CouponsTab() {
  const { colors: COLORS } = useTheme();
  const [coupons, setCoupons] = useState([]);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  async function load() {
    setLoading(true);
    const { data } = await supabase.from("coupons").select("*").order("created_at", { ascending: false });
    setCoupons(data || []);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, []);

  async function save(e) {
    e.preventDefault();
    setSaving(true);
    setError("");
    const payload = {
      code: form.code.trim().toUpperCase(),
      discount_percent: Number(form.discount_percent),
      active: form.active,
      expires_at: form.expires_at || null,
    };
    if (!payload.code || !payload.discount_percent) {
      setError("Code and discount percent are required.");
      setSaving(false);
      return;
    }
    const { error: err } = await supabase.from("coupons").insert(payload);
    setSaving(false);
    if (err) {
      setError(err.message.includes("duplicate") ? "That code already exists." : "Couldn't save — try again.");
      return;
    }
    setForm(null);
    load();
  }

  async function toggleActive(c) {
    await supabase.from("coupons").update({ active: !c.active }).eq("id", c.id);
    load();
  }

  async function remove(id) {
    if (!window.confirm("Delete this coupon?")) return;
    await supabase.from("coupons").delete().eq("id", id);
    load();
  }

  return (
    <div className="max-w-2xl">
      <div className="flex justify-between items-center mb-4">
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>{coupons.length} COUPON{coupons.length === 1 ? "" : "S"}</p>
        <button onClick={() => setForm({ code: "", discount_percent: "10", active: true, expires_at: "" })} className="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-semibold" style={{ background: COLORS.accent, color: COLORS.bg }}>
          <Plus size={16} /> Add coupon
        </button>
      </div>

      {loading ? (
        <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />
      ) : (
        <div className="rounded-lg overflow-hidden" style={{ border: `1px solid ${COLORS.border}` }}>
          {coupons.map((c) => (
            <div key={c.id} className="flex items-center justify-between px-4 py-3 border-b last:border-b-0" style={{ borderColor: COLORS.border, background: COLORS.surface, opacity: c.active ? 1 : 0.5 }}>
              <div>
                <p className="text-sm font-semibold font-mono">{c.code}</p>
                <p className="font-mono text-xs" style={{ color: COLORS.muted }}>
                  {c.discount_percent}% off {c.expires_at ? `· expires ${c.expires_at.slice(0, 10)}` : ""} {!c.active && "· inactive"}
                </p>
              </div>
              <div className="flex items-center gap-2">
                <button onClick={() => toggleActive(c)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.muted }}>
                  {c.active ? "Disable" : "Enable"}
                </button>
                <button onClick={() => remove(c.id)} className="p-2 rounded" style={{ background: COLORS.surface2 }}>
                  <Trash2 size={14} color={COLORS.danger} />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {form && (
        <div className="fixed inset-0 flex items-center justify-center p-6" style={{ background: "rgba(0,0,0,0.6)" }}>
          <form onSubmit={save} className="w-full max-w-sm p-5 rounded-lg" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-display text-2xl">NEW COUPON</h2>
              <button type="button" onClick={() => setForm(null)}><X size={18} color={COLORS.muted} /></button>
            </div>
            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>CODE</label>
            <input value={form.code} onChange={(e) => setForm({ ...form, code: e.target.value })} className="w-full mb-3 px-3 py-2 rounded-md text-sm uppercase" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>DISCOUNT %</label>
            <input type="number" value={form.discount_percent} onChange={(e) => setForm({ ...form, discount_percent: e.target.value })} className="w-full mb-3 px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
            <label className="block font-mono text-xs mb-1" style={{ color: COLORS.muted }}>EXPIRES (optional)</label>
            <input type="date" value={form.expires_at} onChange={(e) => setForm({ ...form, expires_at: e.target.value })} className="w-full mb-4 px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
            {error && <p className="text-xs mb-3" style={{ color: COLORS.danger }}>{error}</p>}
            <button type="submit" disabled={saving} className="w-full py-2.5 rounded-md font-semibold flex items-center justify-center gap-2" style={{ background: COLORS.accent, color: COLORS.bg }}>
              {saving ? <Loader2 className="animate-spin" size={16} /> : "Save"}
            </button>
          </form>
        </div>
      )}
    </div>
  );
}

function ReviewsTab() {
  const { colors: COLORS } = useTheme();
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("pending");

  async function load() {
    setLoading(true);
    let query = supabase.from("reviews").select("*, listings(name)").order("created_at", { ascending: false });
    if (filter === "pending") query = query.eq("approved", false);
    if (filter === "approved") query = query.eq("approved", true);
    const { data } = await query;
    setReviews(data || []);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, [filter]);

  async function approve(id) {
    await supabase.from("reviews").update({ approved: true }).eq("id", id);
    load();
  }
  async function remove(id) {
    if (!window.confirm("Delete this review?")) return;
    await supabase.from("reviews").delete().eq("id", id);
    load();
  }

  return (
    <div className="max-w-3xl">
      <div className="flex items-center gap-2 mb-4">
        {["pending", "approved", "all"].map((f) => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className="text-xs font-mono px-3 py-1.5 rounded-full capitalize"
            style={{ background: filter === f ? COLORS.accent : COLORS.surface2, color: filter === f ? COLORS.bg : COLORS.muted }}
          >
            {f}
          </button>
        ))}
      </div>

      {loading ? (
        <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />
      ) : reviews.length === 0 ? (
        <p className="text-sm" style={{ color: COLORS.muted }}>No reviews here.</p>
      ) : (
        <div className="space-y-3">
          {reviews.map((r) => (
            <div key={r.id} className="rounded-lg p-4" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
              <div className="flex items-center justify-between mb-1.5">
                <div className="flex items-center gap-2">
                  <span className="font-semibold text-sm">{r.customer_name}</span>
                  <span className="font-mono text-xs" style={{ color: COLORS.muted }}>{r.listings?.name}</span>
                </div>
                <div className="flex items-center gap-1">
                  {Array.from({ length: 5 }).map((_, i) => (
                    <Star key={i} size={12} fill={i < r.rating ? COLORS.accent : "none"} color={COLORS.accent} />
                  ))}
                </div>
              </div>
              {r.comment && <p className="text-sm mb-3" style={{ color: COLORS.muted }}>{r.comment}</p>}
              <div className="flex items-center gap-2">
                {!r.approved && (
                  <button onClick={() => approve(r.id)} className="text-xs font-mono px-2 py-1 rounded flex items-center gap-1" style={{ background: COLORS.surface2, color: COLORS.whatsapp }}>
                    <CheckIcon size={12} /> Approve
                  </button>
                )}
                <button onClick={() => remove(r.id)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.danger }}>
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function AnalyticsTab() {
  const { colors: COLORS } = useTheme();
  const [loading, setLoading] = useState(true);
  const [byCategory, setByCategory] = useState([]);
  const [topListings, setTopListings] = useState([]);
  const [totalBookings, setTotalBookings] = useState(0);

  useEffect(() => {
    (async () => {
      setLoading(true);
      const { data } = await supabase.from("bookings").select("listing_id, status, listings(name, category)").eq("status", "confirmed");
      const rows = data || [];
      setTotalBookings(rows.length);

      const catCounts = {};
      const listingCounts = {};
      rows.forEach((r) => {
        const cat = r.listings?.category || "unknown";
        catCounts[cat] = (catCounts[cat] || 0) + 1;
        const name = r.listings?.name || "unknown";
        listingCounts[name] = (listingCounts[name] || 0) + 1;
      });
      const catArr = Object.entries(catCounts).map(([k, v]) => ({ label: k, count: v })).sort((a, b) => b.count - a.count);
      const topArr = Object.entries(listingCounts).map(([k, v]) => ({ label: k, count: v })).sort((a, b) => b.count - a.count).slice(0, 5);
      setByCategory(catArr);
      setTopListings(topArr);
      setLoading(false);
    })();
  }, []);

  if (loading) return <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />;

  const maxCat = Math.max(1, ...byCategory.map((c) => c.count));
  const maxTop = Math.max(1, ...topListings.map((c) => c.count));

  return (
    <div className="max-w-2xl space-y-8">
      <div>
        <p className="font-mono text-xs tracking-widest mb-1" style={{ color: COLORS.muted }}>TOTAL CONFIRMED BOOKINGS</p>
        <p className="font-display text-5xl">{totalBookings}</p>
      </div>

      <div>
        <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.muted }}>BY CATEGORY</p>
        <div className="space-y-2">
          {byCategory.map((c) => (
            <div key={c.label} className="flex items-center gap-3">
              <span className="w-14 text-xs font-mono capitalize" style={{ color: COLORS.text }}>{c.label}</span>
              <div className="flex-1 h-6 rounded-md overflow-hidden" style={{ background: COLORS.surface2 }}>
                <div className="h-full rounded-md" style={{ width: `${(c.count / maxCat) * 100}%`, background: `linear-gradient(90deg, ${COLORS.accent}, ${COLORS.accentBright})` }} />
              </div>
              <span className="w-8 text-xs font-mono text-right" style={{ color: COLORS.muted }}>{c.count}</span>
            </div>
          ))}
        </div>
      </div>

      <div>
        <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.muted }}>TOP 5 LISTINGS</p>
        <div className="space-y-2">
          {topListings.map((c) => (
            <div key={c.label} className="flex items-center gap-3">
              <span className="w-32 text-xs truncate" style={{ color: COLORS.text }}>{c.label}</span>
              <div className="flex-1 h-6 rounded-md overflow-hidden" style={{ background: COLORS.surface2 }}>
                <div className="h-full rounded-md" style={{ width: `${(c.count / maxTop) * 100}%`, background: `linear-gradient(90deg, ${COLORS.accent}, ${COLORS.accentBright})` }} />
              </div>
              <span className="w-8 text-xs font-mono text-right" style={{ color: COLORS.muted }}>{c.count}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function TripRequestsTab() {
  const { colors: COLORS } = useTheme();
  const [enquiries, setEnquiries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("new");

  async function load() {
    setLoading(true);
    let query = supabase.from("trip_enquiries").select("*").order("created_at", { ascending: false });
    if (filter !== "all") query = query.eq("status", filter);
    const { data } = await query;
    setEnquiries(data || []);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, [filter]);

  async function setStatus(id, status) {
    await supabase.from("trip_enquiries").update({ status }).eq("id", id);
    load();
  }
  async function remove(id) {
    if (!window.confirm("Delete this trip request?")) return;
    await supabase.from("trip_enquiries").delete().eq("id", id);
    load();
  }

  return (
    <div className="max-w-3xl">
      <div className="flex items-center gap-2 mb-4">
        {["new", "contacted", "closed", "all"].map((f) => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className="text-xs font-mono px-3 py-1.5 rounded-full capitalize"
            style={{ background: filter === f ? COLORS.accent : COLORS.surface2, color: filter === f ? COLORS.bg : COLORS.muted }}
          >
            {f}
          </button>
        ))}
      </div>

      {loading ? (
        <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={24} />
      ) : enquiries.length === 0 ? (
        <p className="text-sm" style={{ color: COLORS.muted }}>No trip requests here.</p>
      ) : (
        <div className="space-y-3">
          {enquiries.map((eq) => (
            <div key={eq.id} className="rounded-lg p-4" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
              <div className="flex items-center justify-between mb-2">
                <div>
                  <p className="font-semibold text-sm">{eq.customer_name}</p>
                  <p className="font-mono text-xs" style={{ color: COLORS.muted }}>
                    {eq.customer_phone}{eq.customer_email ? ` · ${eq.customer_email}` : ""}
                  </p>
                </div>
                <span className="text-xs font-mono px-2 py-0.5 rounded-full capitalize" style={{ background: COLORS.surface2, color: COLORS.muted }}>{eq.status}</span>
              </div>
              <ul className="text-sm mb-3 space-y-0.5">
                {(eq.items || []).map((item, i) => (
                  <li key={i} style={{ color: COLORS.text }}>• {item.name} <span style={{ color: COLORS.muted }}>(₹{item.price}{item.unit})</span></li>
                ))}
              </ul>
              <div className="flex items-center gap-2">
                {eq.status !== "contacted" && (
                  <button onClick={() => setStatus(eq.id, "contacted")} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.text }}>
                    Mark contacted
                  </button>
                )}
                {eq.status !== "closed" && (
                  <button onClick={() => setStatus(eq.id, "closed")} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.whatsapp }}>
                    Mark closed
                  </button>
                )}
                <button onClick={() => remove(eq.id)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.danger }}>
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

FILEEOF

echo "v6 applied: Packages and Travels categories added."
