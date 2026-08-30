import React, { useState, useEffect, useMemo } from "react";
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
} from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS, SLOTS, COLORS } from "../config.js";

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

export default function Booking() {
  const [type, setType] = useState("bike");
  const [listings, setListings] = useState([]);
  const [listingId, setListingId] = useState(null);
  const days = useMemo(() => nextDays(7), []);
  const [date, setDate] = useState(dateKey(days[0]));
  const [takenSlots, setTakenSlots] = useState([]);
  const [slot, setSlot] = useState(null);
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [loadingListings, setLoadingListings] = useState(true);
  const [loadingSlots, setLoadingSlots] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [ticket, setTicket] = useState(null);
  const [error, setError] = useState("");

  const listing = listings.find((l) => l.id === listingId) || null;

  useEffect(() => {
    let cancelled = false;
    (async () => {
      setLoadingListings(true);
      setError("");
      const { data, error: err } = await supabase
        .from("listings")
        .select("*")
        .eq("category", type)
        .eq("active", true)
        .order("price", { ascending: true });
      if (cancelled) return;
      if (err) {
        setError("Couldn't load listings — check your connection and try again.");
        setListings([]);
      } else {
        setListings(data || []);
        setListingId(data && data.length ? data[0].id : null);
      }
      setLoadingListings(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [type]);

  useEffect(() => {
    if (!listingId) {
      setTakenSlots([]);
      return;
    }
    let cancelled = false;
    (async () => {
      setLoadingSlots(true);
      setSlot(null);
      const { data, error: err } = await supabase
        .from("taken_slots")
        .select("slot_time")
        .eq("listing_id", listingId)
        .eq("booking_date", date);
      if (cancelled) return;
      if (!err) setTakenSlots((data || []).map((r) => r.slot_time));
      setLoadingSlots(false);
    })();
    return () => {
      cancelled = true;
    };
  }, [listingId, date]);

  const canConfirm = listing && slot && name.trim() && phone.trim().length >= 7 && !submitting;

  async function confirmBooking() {
    if (!listing || !slot) return;
    setError("");
    setSubmitting(true);
    const code = Math.random().toString(36).slice(2, 7).toUpperCase();

    const { error: err } = await supabase.from("bookings").insert({
      listing_id: listing.id,
      booking_date: date,
      slot_time: slot,
      customer_name: name.trim(),
      customer_phone: phone.trim(),
      code,
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
      price: listing.price,
      unit: listing.unit,
      tag: listing.tag,
      hours: listing.hours,
      code,
    });
    setSubmitting(false);
  }

  function waLink() {
    if (!ticket) return "#";
    const label = ticket.type === "tour" ? "Tour" : "Vehicle";
    const durationLine =
      ticket.type === "tour" && ticket.hours ? `%0ADuration: ${ticket.tag} (${ticket.hours} hrs)` : "";
    const msg = `Hi ${BUSINESS.name}! I'd like to confirm my booking:%0A%0A${label}: ${ticket.vehicle}%0ADate: ${ticket.date}%0ATime: ${ticket.slot}${durationLine}%0AName: ${ticket.name}%0APhone: ${ticket.phone}%0ABooking code: ${ticket.code}`;
    return `https://wa.me/${BUSINESS.whatsapp}?text=${msg}`;
  }

  function resetFlow() {
    setTicket(null);
    setSlot(null);
    setName("");
    setPhone("");
  }

  const categoryIcon = (t, size = 16) =>
    t === "bike" ? <Bike size={size} /> : t === "car" ? <Car size={size} /> : t === "bus" ? <Bus size={size} /> : <Landmark size={size} />;

  return (
    <div className="font-body min-h-screen w-full" style={{ color: COLORS.text }}>
      {/* Header */}
      <header
        className="flex items-center justify-between px-6 py-4 sticky top-0 z-20"
        style={{ background: "rgba(20,24,28,0.72)", backdropFilter: "blur(14px)", borderBottom: `1px solid ${COLORS.border}` }}
      >
        <div className="flex items-center gap-2.5">
          <div
            className="w-9 h-9 rounded-xl flex items-center justify-center"
            style={{ background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 4px 16px ${COLORS.glow}` }}
          >
            <Car size={18} color={COLORS.bg} strokeWidth={2.5} />
          </div>
          <span className="font-display text-2xl tracking-wide">{BUSINESS.name.toUpperCase()}</span>
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-sm font-mono" style={{ color: COLORS.muted }}>
          <MapPin size={14} />
          {BUSINESS.location}
        </div>
      </header>

      {/* Hero */}
      <section className="relative px-6 pt-12 pb-8 max-w-3xl mx-auto text-center overflow-hidden">
        <div
          className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full mb-5 font-mono text-[10px] tracking-[0.2em]"
          style={{ background: COLORS.accentSoft, color: COLORS.accent, border: `1px solid rgba(245,183,0,0.25)` }}
        >
          <span className="w-1.5 h-1.5 rounded-full" style={{ background: COLORS.accent }} />
          RENTALS &amp; BHUBANESWAR SIGHTSEEING
        </div>
        <h1 className="font-display text-6xl sm:text-8xl leading-none">
          {type === "tour" ? (
            <>EXPLORE <span style={{ color: COLORS.accent }}>BHUBANESWAR</span></>
          ) : (
            <>BOOK YOUR <span style={{ color: COLORS.accent }}>RIDE</span></>
          )}
        </h1>
        <p className="mt-4 text-base sm:text-lg" style={{ color: COLORS.muted }}>
          {type === "tour"
            ? "Pick a sightseeing package, choose a date, and we'll lock in your seat."
            : "Pick a bike, car, or bus, choose a slot, and we'll lock it in."}
        </p>
      </section>

      {ticket ? (
        <TicketView ticket={ticket} waLink={waLink()} onReset={resetFlow} colors={COLORS} business={BUSINESS} />
      ) : (
        <main className="px-5 sm:px-6 pb-20 max-w-3xl mx-auto">
          {/* Category pills */}
          <div
            className="flex p-1.5 rounded-full mb-8 mx-auto w-fit gap-1"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, boxShadow: "inset 0 1px 2px rgba(0,0,0,0.3)" }}
          >
            {["bike", "car", "bus", "tour"].map((t) => (
              <button
                key={t}
                onClick={() => setType(t)}
                className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-all duration-200"
                style={
                  type === t
                    ? { background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, color: COLORS.bg, boxShadow: `0 6px 18px ${COLORS.glow}` }
                    : { background: "transparent", color: COLORS.muted }
                }
              >
                {categoryIcon(t)}
                {t === "bike" ? "Bikes" : t === "car" ? "Cars" : t === "bus" ? "Buses" : "Tours"}
              </button>
            ))}
          </div>

          {loadingListings ? (
            <div className="flex justify-center py-16">
              <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={28} />
            </div>
          ) : listings.length === 0 ? (
            <p className="text-center py-16" style={{ color: COLORS.muted }}>
              No {type}s available right now — check back soon.
            </p>
          ) : (
            <>
              {/* Vehicle / package cards */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-10 animate-fade-up">
                {listings.map((v) => {
                  const active = listingId === v.id;
                  return (
                    <button
                      key={v.id}
                      onClick={() => setListingId(v.id)}
                      className="text-left p-4 rounded-2xl transition-all duration-200 active:scale-[0.98]"
                      style={{
                        background: active
                          ? `linear-gradient(160deg, rgba(245,183,0,0.14), rgba(245,183,0,0.04))`
                          : `linear-gradient(160deg, ${COLORS.surface}, ${COLORS.surface2})`,
                        border: `1px solid ${active ? COLORS.accent : COLORS.border}`,
                        boxShadow: active ? `0 8px 28px ${COLORS.glow}` : "0 2px 8px rgba(0,0,0,0.15)",
                      }}
                    >
                      <div className="flex items-center justify-between mb-4">
                        <div
                          className="w-10 h-10 rounded-full flex items-center justify-center"
                          style={{ background: active ? COLORS.accentSoft : COLORS.surface2, border: `1px solid ${active ? "rgba(245,183,0,0.3)" : COLORS.border}` }}
                        >
                          {React.cloneElement(categoryIcon(type, 18), { color: COLORS.accent })}
                        </div>
                        <span
                          className="font-mono text-[10px] px-2 py-1 rounded-full"
                          style={{ background: COLORS.surface2, color: COLORS.muted, border: `1px solid ${COLORS.border}` }}
                        >
                          {v.tag}
                          {v.hours ? ` · ${v.hours}h` : ""}
                        </span>
                      </div>
                      <p className="font-semibold text-sm leading-tight mb-2">{v.name}</p>
                      <p className="font-mono text-base">
                        <span style={{ color: COLORS.accent }}>₹{v.price}</span>
                        <span style={{ color: COLORS.muted }}>{v.unit}</span>
                      </p>
                    </button>
                  );
                })}
              </div>

              {/* Date picker */}
              <p className="font-mono text-xs tracking-widest mb-3 flex items-center gap-2" style={{ color: COLORS.muted }}>
                <span className="w-1 h-1 rounded-full" style={{ background: COLORS.accent }} /> SELECT DATE
              </p>
              <div className="flex gap-2 overflow-x-auto pb-2 mb-8 -mx-1 px-1">
                {days.map((d) => {
                  const key = dateKey(d);
                  const active = date === key;
                  return (
                    <button
                      key={key}
                      onClick={() => setDate(key)}
                      className="flex flex-col items-center justify-center rounded-2xl px-4 py-2.5 min-w-[60px] shrink-0 transition-all duration-200 active:scale-[0.96]"
                      style={
                        active
                          ? { background: `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`, boxShadow: `0 6px 18px ${COLORS.glow}` }
                          : { background: COLORS.surface, border: `1px solid ${COLORS.border}` }
                      }
                    >
                      <span className="font-mono text-[10px]" style={{ color: active ? COLORS.bg : COLORS.muted }}>
                        {dayLabel(d)}
                      </span>
                      <span className="font-display text-2xl leading-none mt-0.5" style={{ color: active ? COLORS.bg : COLORS.text }}>
                        {d.getDate()}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Time slots */}
              <p className="font-mono text-xs tracking-widest mb-3 flex items-center gap-2" style={{ color: COLORS.muted }}>
                <span className="w-1 h-1 rounded-full" style={{ background: COLORS.accent }} />
                {type === "tour" ? "SELECT PICKUP TIME" : "SELECT TIME"}
              </p>
              <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 mb-8">
                {loadingSlots
                  ? Array.from({ length: 6 }).map((_, i) => (
                      <div key={i} className="h-11 rounded-xl animate-pulse" style={{ background: COLORS.surface }} />
                    ))
                  : SLOTS.map((s) => {
                      const isBooked = takenSlots.includes(s);
                      const active = slot === s;
                      return (
                        <button
                          key={s}
                          disabled={isBooked}
                          onClick={() => setSlot(s)}
                          className="font-mono text-sm py-3 rounded-xl flex items-center justify-center gap-1.5 transition-all duration-200 active:scale-[0.96]"
                          style={{
                            background: isBooked
                              ? "transparent"
                              : active
                              ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})`
                              : COLORS.surface,
                            border: `1px solid ${isBooked ? COLORS.border : active ? "transparent" : COLORS.border}`,
                            color: isBooked ? COLORS.muted : active ? COLORS.bg : COLORS.text,
                            opacity: isBooked ? 0.4 : 1,
                            textDecoration: isBooked ? "line-through" : "none",
                            cursor: isBooked ? "not-allowed" : "pointer",
                            boxShadow: active ? `0 6px 16px ${COLORS.glow}` : "none",
                          }}
                        >
                          <Clock size={12} />
                          {s}
                        </button>
                      );
                    })}
              </div>

              {/* Details form */}
              <div
                className="rounded-2xl p-5 mb-5"
                style={{ background: `linear-gradient(160deg, ${COLORS.surface}, ${COLORS.surface2})`, border: `1px solid ${COLORS.border}`, boxShadow: "0 4px 16px rgba(0,0,0,0.2)" }}
              >
                <p className="font-mono text-xs tracking-widest mb-4 flex items-center gap-2" style={{ color: COLORS.muted }}>
                  <span className="w-1 h-1 rounded-full" style={{ background: COLORS.accent }} /> YOUR DETAILS
                </p>
                <div className="grid sm:grid-cols-2 gap-3">
                  <div className="relative">
                    <User size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                    <input
                      placeholder="Full name"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      className="font-body w-full pl-9 pr-3 py-3 rounded-xl text-sm transition-all"
                      style={{ background: COLORS.bg, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    />
                  </div>
                  <div className="relative">
                    <Phone size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                    <input
                      placeholder="Phone number"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      className="font-body w-full pl-9 pr-3 py-3 rounded-xl text-sm transition-all"
                      style={{ background: COLORS.bg, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                    />
                  </div>
                </div>
                {error && (
                  <p className="text-xs mt-3 flex items-center gap-1.5" style={{ color: COLORS.danger }}>
                    {error}
                  </p>
                )}
              </div>

              <button
                disabled={!canConfirm}
                onClick={confirmBooking}
                className="w-full py-4 rounded-xl font-semibold flex items-center justify-center gap-2 transition-all duration-200 active:scale-[0.98]"
                style={{
                  background: canConfirm ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface,
                  color: canConfirm ? COLORS.bg : COLORS.muted,
                  boxShadow: canConfirm ? `0 10px 30px ${COLORS.glow}` : "none",
                  cursor: canConfirm ? "pointer" : "not-allowed",
                }}
              >
                {submitting ? (
                  <Loader2 className="animate-spin" size={18} />
                ) : (
                  <>
                    Confirm Booking <ChevronRight size={18} />
                  </>
                )}
              </button>
            </>
          )}
        </main>
      )}

      {/* Footer */}
      <footer className="px-6 py-10 flex flex-col items-center gap-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>
          QUESTIONS? REACH US DIRECTLY
        </p>
        <div className="flex gap-3 flex-wrap justify-center">
          <a
            href={`https://wa.me/${BUSINESS.whatsapp}`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-transform active:scale-95"
            style={{ background: COLORS.whatsapp, color: "#0B1A0F", boxShadow: "0 6px 18px rgba(37,211,102,0.3)" }}
          >
            <MessageCircle size={16} /> WhatsApp
          </a>
          <a
            href={`https://instagram.com/${BUSINESS.instagram}`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-transform active:scale-95"
            style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
          >
            <Instagram size={16} /> Instagram
          </a>
          <a
            href={`https://facebook.com/${BUSINESS.facebook}`}
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold transition-transform active:scale-95"
            style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
          >
            <Facebook size={16} /> Facebook
          </a>
        </div>
        <a href="/admin/login" className="text-xs font-mono opacity-40" style={{ color: COLORS.muted }}>
          admin
        </a>
      </footer>
    </div>
  );
}

function TicketView({ ticket, waLink, onReset, colors, business }) {
  return (
    <main className="px-6 pb-20 max-w-md mx-auto animate-fade-up">
      <div
        className="rounded-3xl overflow-hidden mx-auto"
        style={{ background: `linear-gradient(160deg, ${colors.surface}, ${colors.surface2})`, border: `1px solid ${colors.border}`, boxShadow: `0 20px 50px rgba(0,0,0,0.4)` }}
      >
        <div className="p-6 flex items-center gap-3" style={{ background: `linear-gradient(135deg, rgba(245,183,0,0.18), rgba(245,183,0,0.04))` }}>
          <div
            className="w-9 h-9 rounded-full flex items-center justify-center"
            style={{ background: `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})`, boxShadow: `0 4px 14px ${colors.glow}` }}
          >
            <Check size={18} color={colors.bg} strokeWidth={3} />
          </div>
          <span className="font-display text-3xl">{ticket.type === "tour" ? "SEAT RESERVED" : "SLOT RESERVED"}</span>
        </div>
        <div className="px-6 py-5 font-mono text-sm space-y-3" style={{ color: colors.text }}>
          <Row label={ticket.type === "tour" ? "PACKAGE" : "VEHICLE"} value={ticket.vehicle} colors={colors} />
          <Row label="DATE" value={ticket.date} colors={colors} />
          <Row label="TIME" value={ticket.slot} colors={colors} />
          <Row label="RATE" value={`₹${ticket.price}${ticket.unit || "/hr"}`} colors={colors} />
          {ticket.type === "tour" && ticket.hours && <Row label="DURATION" value={`${ticket.tag} · ${ticket.hours} hrs`} colors={colors} />}
          <Row label="NAME" value={ticket.name} colors={colors} />
          <Row label="PHONE" value={ticket.phone} colors={colors} />
        </div>
        <div className="relative h-0 border-t border-dashed" style={{ borderColor: colors.border }}>
          <div className="absolute -left-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
          <div className="absolute -right-3 -top-3 w-6 h-6 rounded-full" style={{ background: colors.bg }} />
        </div>
        <div className="px-6 py-5 flex items-center justify-between">
          <span className="text-xs font-mono" style={{ color: colors.muted }}>
            CODE
          </span>
          <span className="font-display text-3xl tracking-[0.15em]" style={{ color: colors.accent }}>
            {ticket.code}
          </span>
        </div>
      </div>
      <p className="text-center text-sm mt-6" style={{ color: colors.muted }}>
        Send this to {business.name} on WhatsApp to finalize pickup details.
      </p>
      <a
        href={waLink}
        target="_blank"
        rel="noreferrer"
        className="w-full mt-4 py-4 rounded-xl font-semibold flex items-center justify-center gap-2 transition-transform active:scale-[0.98]"
        style={{ background: colors.whatsapp, color: "#0B1A0F", boxShadow: "0 10px 30px rgba(37,211,102,0.3)" }}
      >
        <MessageCircle size={18} /> Confirm via WhatsApp
      </a>
      <button
        onClick={onReset}
        className="w-full mt-3 py-3.5 rounded-xl text-sm font-medium transition-transform active:scale-[0.98]"
        style={{ background: "transparent", border: `1px solid ${colors.border}`, color: colors.muted }}
      >
        Book another slot
      </button>
    </main>
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
