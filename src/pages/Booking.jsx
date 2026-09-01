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
} from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS, SLOTS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";
import LanguageToggle from "../components/LanguageToggle.jsx";
import { useLanguage, t } from "../i18n.js";

// Tours lead — vehicle rental is a supporting service, not the headline.
const CATEGORIES = [
  { key: "tour", labelKey: "tours", icon: Landmark, tint: "rgba(245,110,110,0.14)" },
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

  const [allListings, setAllListings] = useState({ bike: [], car: [], bus: [], tour: [] });
  const [reviewStats, setReviewStats] = useState({});
  const [loadingListings, setLoadingListings] = useState(true);
  const [search, setSearch] = useState("");
  const [sortOrder, setSortOrder] = useState("default");

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

  useEffect(() => {
    (async () => {
      setLoadingListings(true);
      const [{ data: listingsData }, { data: statsData }] = await Promise.all([
        supabase.from("listings").select("*").eq("active", true).order("price", { ascending: true }),
        supabase.from("review_stats").select("*"),
      ]);
      const grouped = { bike: [], car: [], bus: [], tour: [] };
      (listingsData || []).forEach((l) => {
        if (grouped[l.category]) grouped[l.category].push(l);
      });
      setAllListings(grouped);
      const statsMap = {};
      (statsData || []).forEach((s) => {
        statsMap[s.listing_id] = s;
      });
      setReviewStats(statsMap);
      setLoadingListings(false);
    })();
  }, []);

  const listing = selected ? allListings[selected.category]?.find((l) => l.id === selected.listingId) : null;
  const isMultiDayEligible = listing && listing.category !== "tour";

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
      <section className="relative px-5 pt-10 pb-8 text-center">
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

      {/* Services overview */}
      <section className="px-5 pb-10 max-w-5xl mx-auto">
        <p className="font-mono text-xs tracking-widest mb-4 text-center" style={{ color: COLORS.muted }}>{tr("ourServices")}</p>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <a
            href="#tour"
            className="flex flex-col gap-2 p-4 rounded-2xl"
            style={{ background: `linear-gradient(160deg, ${COLORS.accentSoft}, ${COLORS.surface})`, border: `1px solid ${COLORS.accent}` }}
          >
            <Landmark size={22} color={COLORS.accent} />
            <p className="font-semibold text-sm leading-tight">{tr("serviceToursTitle")}</p>
            <p className="text-xs" style={{ color: COLORS.muted }}>{tr("serviceToursDesc")}</p>
          </a>
          <a
            href="#bike"
            className="flex flex-col gap-2 p-4 rounded-2xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Car size={22} color={COLORS.accent} />
            <p className="font-semibold text-sm leading-tight">{tr("serviceRentalTitle")}</p>
            <p className="text-xs" style={{ color: COLORS.muted }}>{tr("serviceRentalDesc")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like help planning a custom trip.`}
            target="_blank"
            rel="noreferrer"
            className="flex flex-col gap-2 p-4 rounded-2xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Compass size={22} color={COLORS.accent} />
            <p className="font-semibold text-sm leading-tight">{tr("serviceCustomTitle")}</p>
            <p className="text-xs" style={{ color: COLORS.muted }}>{tr("serviceCustomDesc")}</p>
          </a>
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}?text=Hi! I'd like to enquire about group/corporate travel.`}
            target="_blank"
            rel="noreferrer"
            className="flex flex-col gap-2 p-4 rounded-2xl"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}
          >
            <Users size={22} color={COLORS.accent} />
            <p className="font-semibold text-sm leading-tight">{tr("serviceGroupTitle")}</p>
            <p className="text-xs" style={{ color: COLORS.muted }}>{tr("serviceGroupDesc")}</p>
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

            {CATEGORIES.map((cat) => {
              const items = sortListings(allListings[cat.key].filter(matches));
              if (term && items.length === 0) return null;
              const isFirstVehicleSection = cat.key === "bike";
              return (
                <React.Fragment key={cat.key}>
                  {isFirstVehicleSection && (
                    <div className="pt-10 px-5 max-w-5xl mx-auto text-center" style={{ borderTop: `1px solid ${COLORS.border}`, marginTop: "1rem" }}>
                      <p className="font-mono text-xs tracking-widest mb-1" style={{ color: COLORS.accent }}>{tr("vehicleRentalHeading")}</p>
                      <p className="text-sm" style={{ color: COLORS.muted }}>{tr("vehicleRentalSubtitle")}</p>
                    </div>
                  )}
                  <section id={cat.key} className="pt-8 px-5" style={{ scrollMarginTop: "72px" }}>
                    <div className="flex items-center gap-2 mb-4 max-w-5xl mx-auto">
                      <cat.icon size={20} color={COLORS.accent} />
                      <h2 className="font-display text-2xl">{tr(cat.labelKey)}</h2>
                    </div>
                    {items.length === 0 ? (
                      <p className="text-sm max-w-5xl mx-auto" style={{ color: COLORS.muted }}>No {tr(cat.labelKey).toLowerCase()} available right now.</p>
                    ) : (
                      <div className="flex gap-4 overflow-x-auto pb-3 max-w-5xl mx-auto sm:flex-wrap sm:overflow-visible">
                        {items.map((l) => (
                          <PhotoCard
                            key={l.id}
                            listing={l}
                            category={cat}
                            colors={COLORS}
                            stats={reviewStats[l.id]}
                            bookLabel={tr("book")}
                            selectedLabel={tr("selected")}
                            selected={selected && selected.listingId === l.id}
                            onBook={() => chooseListing(cat.key, l.id)}
                          />
                        ))}
                      </div>
                    )}
                  </section>
                </React.Fragment>
              );
            })}
          </>
        )}
      </main>

      {/* Footer */}
      <footer className="px-6 py-10 flex flex-col items-center gap-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>{tr("questionsReachUs")}</p>
        <div className="flex gap-3 flex-wrap justify-center">
          <a href={`https://wa.me/${BUSINESS.whatsapp}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.whatsapp, color: "#0B1A0F", boxShadow: "0 6px 18px rgba(37,211,102,0.3)" }}>
            <MessageCircle size={16} /> WhatsApp
          </a>
          <a href={`https://instagram.com/${BUSINESS.instagram}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Instagram size={16} /> Instagram
          </a>
          <a href={`https://facebook.com/${BUSINESS.facebook}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Facebook size={16} /> Facebook
          </a>
        </div>
        <a href="/lookup" className="flex items-center gap-1.5 text-xs font-mono" style={{ color: COLORS.muted }}>
          <ClipboardList size={13} /> {tr("checkBooking")}
        </a>
        <a href="/admin/login" className="text-xs font-mono opacity-40" style={{ color: COLORS.muted }}>{tr("admin")}</a>
      </footer>
    </div>
  );
}

function PhotoCard({ listing, category, colors, stats, bookLabel, selectedLabel, selected, onBook }) {
  const Icon = category.icon;
  return (
    <div
      className="shrink-0 w-52 sm:w-56 rounded-2xl overflow-hidden flex flex-col"
      style={{ background: colors.surface, border: `1px solid ${selected ? colors.accent : colors.border}`, boxShadow: selected ? `0 8px 24px ${colors.glow}` : "0 2px 8px rgba(0,0,0,0.15)" }}
    >
      <div className="h-32 relative flex items-center justify-center overflow-hidden" style={{ background: `linear-gradient(135deg, ${category.tint}, ${colors.surface2})` }}>
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
        <span className="absolute top-2 right-2 font-mono text-[10px] px-2 py-1 rounded-full z-10" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
        {stats && stats.review_count > 0 && (
          <span className="absolute bottom-2 left-2 font-mono text-[10px] px-2 py-1 rounded-full z-10 flex items-center gap-1" style={{ background: "rgba(20,24,28,0.75)", color: "#F2F0EA", backdropFilter: "blur(4px)" }}>
            <Star size={10} fill={colors.accent} color={colors.accent} /> {stats.avg_rating} ({stats.review_count})
          </span>
        )}
      </div>
      <div className="p-3.5 flex flex-col flex-1">
        <p className="font-semibold text-sm leading-tight mb-1.5 line-clamp-2" style={{ color: colors.text }}>{listing.name}</p>
        <p className="font-mono text-sm mb-3">
          <span style={{ color: colors.accent }}>₹{listing.price}</span>
          <span style={{ color: colors.muted }}>{listing.unit}</span>
        </p>
        <button
          onClick={onBook}
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
