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

  // Load listings whenever the category tab changes
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

  // Load taken slots whenever the selected listing or date changes
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
        // unique constraint hit — someone else took this slot first
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

  return (
    <div className="font-body min-h-screen w-full" style={{ background: COLORS.bg, color: COLORS.text }}>
      <header className="flex items-center justify-between px-6 py-5 border-b" style={{ borderColor: COLORS.border }}>
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-sm flex items-center justify-center" style={{ background: COLORS.accent }}>
            <Car size={18} color={COLORS.bg} strokeWidth={2.5} />
          </div>
          <span className="font-display text-2xl tracking-wide">{BUSINESS.name.toUpperCase()}</span>
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-sm font-mono" style={{ color: COLORS.muted }}>
          <MapPin size={14} />
          {BUSINESS.location}
        </div>
      </header>

      <section className="px-6 pt-10 pb-6 max-w-3xl mx-auto text-center">
        <p className="font-mono text-xs tracking-[0.25em]" style={{ color: COLORS.accent }}>
          RENTALS &amp; BHUBANESWAR SIGHTSEEING
        </p>
        <h1 className="font-display text-6xl sm:text-7xl leading-none mt-2">
          {type === "tour" ? "EXPLORE BHUBANESWAR" : "BOOK YOUR RIDE"}
        </h1>
        <p className="mt-3" style={{ color: COLORS.muted }}>
          {type === "tour"
            ? "Pick a sightseeing package, choose a date, and we'll lock in your seat."
            : "Pick a bike, car, or bus, choose a slot, and we'll lock it in."}
        </p>
      </section>

      {ticket ? (
        <TicketView ticket={ticket} waLink={waLink()} onReset={resetFlow} colors={COLORS} business={BUSINESS} />
      ) : (
        <main className="px-6 pb-16 max-w-3xl mx-auto">
          <div className="flex p-1 rounded-md mb-6 mx-auto w-fit" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
            {["bike", "car", "bus", "tour"].map((t) => (
              <button
                key={t}
                onClick={() => setType(t)}
                className="flex items-center gap-2 px-5 py-2 rounded text-sm font-semibold transition-colors"
                style={{ background: type === t ? COLORS.accent : "transparent", color: type === t ? COLORS.bg : COLORS.muted }}
              >
                {t === "bike" ? <Bike size={16} /> : t === "car" ? <Car size={16} /> : t === "bus" ? <Bus size={16} /> : <Landmark size={16} />}
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
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-8">
                {listings.map((v) => (
                  <button
                    key={v.id}
                    onClick={() => setListingId(v.id)}
                    className="text-left p-4 rounded-lg transition-all"
                    style={{
                      background: listingId === v.id ? COLORS.accentSoft : COLORS.surface,
                      border: `1px solid ${listingId === v.id ? COLORS.accent : COLORS.border}`,
                    }}
                  >
                    <div className="flex items-center justify-between mb-3">
                      {type === "bike" ? (
                        <Bike size={20} color={COLORS.accent} />
                      ) : type === "car" ? (
                        <Car size={20} color={COLORS.accent} />
                      ) : type === "bus" ? (
                        <Bus size={20} color={COLORS.accent} />
                      ) : (
                        <Landmark size={20} color={COLORS.accent} />
                      )}
                      <span className="font-mono text-[10px] px-1.5 py-0.5 rounded" style={{ background: COLORS.surface2, color: COLORS.muted }}>
                        {v.tag}
                        {v.hours ? ` · ${v.hours} hrs` : ""}
                      </span>
                    </div>
                    <p className="font-semibold text-sm leading-tight">{v.name}</p>
                    <p className="font-mono text-sm mt-1.5" style={{ color: COLORS.accent }}>
                      ₹{v.price}
                      <span style={{ color: COLORS.muted }}>{v.unit}</span>
                    </p>
                  </button>
                ))}
              </div>

              <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>
                SELECT DATE
              </p>
              <div className="flex gap-2 overflow-x-auto pb-2 mb-6">
                {days.map((d) => {
                  const key = dateKey(d);
                  const active = date === key;
                  return (
                    <button
                      key={key}
                      onClick={() => setDate(key)}
                      className="flex flex-col items-center justify-center rounded-md px-3 py-2 min-w-[56px] shrink-0"
                      style={{ background: active ? COLORS.accent : COLORS.surface, border: `1px solid ${active ? COLORS.accent : COLORS.border}` }}
                    >
                      <span className="font-mono text-[10px]" style={{ color: active ? COLORS.bg : COLORS.muted }}>
                        {dayLabel(d)}
                      </span>
                      <span className="font-display text-xl leading-none" style={{ color: active ? COLORS.bg : COLORS.text }}>
                        {d.getDate()}
                      </span>
                    </button>
                  );
                })}
              </div>

              <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>
                {type === "tour" ? "SELECT PICKUP TIME" : "SELECT TIME"}
              </p>
              <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 mb-8">
                {loadingSlots
                  ? Array.from({ length: 6 }).map((_, i) => (
                      <div key={i} className="h-10 rounded-md animate-pulse" style={{ background: COLORS.surface }} />
                    ))
                  : SLOTS.map((s) => {
                      const isBooked = takenSlots.includes(s);
                      const active = slot === s;
                      return (
                        <button
                          key={s}
                          disabled={isBooked}
                          onClick={() => setSlot(s)}
                          className="font-mono text-sm py-2.5 rounded-md flex items-center justify-center gap-1.5"
                          style={{
                            background: isBooked ? "transparent" : active ? COLORS.accent : COLORS.surface,
                            border: `1px solid ${isBooked ? COLORS.border : active ? COLORS.accent : COLORS.border}`,
                            color: isBooked ? COLORS.muted : active ? COLORS.bg : COLORS.text,
                            opacity: isBooked ? 0.4 : 1,
                            textDecoration: isBooked ? "line-through" : "none",
                            cursor: isBooked ? "not-allowed" : "pointer",
                          }}
                        >
                          <Clock size={12} />
                          {s}
                        </button>
                      );
                    })}
              </div>

              <div className="rounded-lg p-5 mb-4" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
                <p className="font-mono text-xs tracking-widest mb-3" style={{ color: COLORS.muted }}>
                  YOUR DETAILS
                </p>
                <div className="grid sm:grid-cols-2 gap-3">
                  <input
                    placeholder="Full name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="font-body px-3 py-2.5 rounded-md text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                  <input
                    placeholder="Phone number"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="font-body px-3 py-2.5 rounded-md text-sm"
                    style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
                  />
                </div>
                {error && (
                  <p className="text-xs mt-2" style={{ color: COLORS.danger }}>
                    {error}
                  </p>
                )}
              </div>

              <button
                disabled={!canConfirm}
                onClick={confirmBooking}
                className="w-full py-3.5 rounded-md font-semibold flex items-center justify-center gap-2 transition-opacity"
                style={{ background: COLORS.accent, color: COLORS.bg, opacity: canConfirm ? 1 : 0.4, cursor: canConfirm ? "pointer" : "not-allowed" }}
              >
                {submitting ? <Loader2 className="animate-spin" size={18} /> : <>Confirm Booking <ChevronRight size={18} /></>}
              </button>
            </>
          )}
        </main>
      )}

      <footer className="px-6 py-8 border-t flex flex-col items-center gap-4" style={{ borderColor: COLORS.border }}>
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>
          QUESTIONS? REACH US DIRECTLY
        </p>
        <div className="flex gap-3">
          <a href={`https://wa.me/${BUSINESS.whatsapp}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-semibold" style={{ background: COLORS.whatsapp, color: "#0B1A0F" }}>
            <MessageCircle size={16} /> WhatsApp
          </a>
          <a href={`https://instagram.com/${BUSINESS.instagram}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Instagram size={16} /> Instagram
          </a>
          <a href={`https://facebook.com/${BUSINESS.facebook}`} target="_blank" rel="noreferrer" className="flex items-center gap-2 px-4 py-2 rounded-md text-sm font-semibold" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}>
            <Facebook size={16} /> Facebook
          </a>
        </div>
        <a href="/admin/login" className="text-xs font-mono" style={{ color: COLORS.border }}>
          admin
        </a>
      </footer>
    </div>
  );
}

function TicketView({ ticket, waLink, onReset, colors, business }) {
  return (
    <main className="px-6 pb-16 max-w-md mx-auto">
      <div className="rounded-lg overflow-hidden mx-auto" style={{ background: colors.surface, border: `1px solid ${colors.border}` }}>
        <div className="p-5 flex items-center gap-2" style={{ background: colors.accentSoft }}>
          <div className="w-7 h-7 rounded-full flex items-center justify-center" style={{ background: colors.accent }}>
            <Check size={16} color={colors.bg} strokeWidth={3} />
          </div>
          <span className="font-display text-2xl">{ticket.type === "tour" ? "SEAT RESERVED" : "SLOT RESERVED"}</span>
        </div>
        <div className="px-5 py-4 font-mono text-sm space-y-2.5" style={{ color: colors.text }}>
          <Row label={ticket.type === "tour" ? "PACKAGE" : "VEHICLE"} value={ticket.vehicle} colors={colors} />
          <Row label="DATE" value={ticket.date} colors={colors} />
          <Row label="TIME" value={ticket.slot} colors={colors} />
          <Row label="RATE" value={`₹${ticket.price}${ticket.unit || "/hr"}`} colors={colors} />
          {ticket.type === "tour" && ticket.hours && <Row label="DURATION" value={`${ticket.tag} · ${ticket.hours} hrs`} colors={colors} />}
          <Row label="NAME" value={ticket.name} colors={colors} />
          <Row label="PHONE" value={ticket.phone} colors={colors} />
        </div>
        <div className="relative h-0 border-t border-dashed" style={{ borderColor: colors.border }}>
          <div className="absolute -left-2.5 -top-2.5 w-5 h-5 rounded-full" style={{ background: colors.bg }} />
          <div className="absolute -right-2.5 -top-2.5 w-5 h-5 rounded-full" style={{ background: colors.bg }} />
        </div>
        <div className="px-5 py-4 flex items-center justify-between">
          <span className="text-xs font-mono" style={{ color: colors.muted }}>CODE</span>
          <span className="font-display text-2xl tracking-widest" style={{ color: colors.accent }}>{ticket.code}</span>
        </div>
      </div>
      <p className="text-center text-sm mt-5" style={{ color: colors.muted }}>
        Send this to {business.name} on WhatsApp to finalize pickup details.
      </p>
      <a href={waLink} target="_blank" rel="noreferrer" className="w-full mt-4 py-3.5 rounded-md font-semibold flex items-center justify-center gap-2" style={{ background: colors.whatsapp, color: "#0B1A0F" }}>
        <MessageCircle size={18} /> Confirm via WhatsApp
      </a>
      <button onClick={onReset} className="w-full mt-3 py-3 rounded-md text-sm font-medium" style={{ background: "transparent", border: `1px solid ${colors.border}`, color: colors.muted }}>
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
