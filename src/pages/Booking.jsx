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
} from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS, SLOTS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";

const CATEGORIES = [
  { key: "bike", label: "Bikes", icon: Bike, tint: "rgba(245,183,0,0.16)" },
  { key: "car", label: "Cars", icon: Car, tint: "rgba(37,211,102,0.14)" },
  { key: "bus", label: "Buses", icon: Bus, tint: "rgba(122,110,245,0.16)" },
  { key: "tour", label: "Tours", icon: Landmark, tint: "rgba(245,110,110,0.14)" },
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

export default function Booking() {
  const { colors: COLORS } = useTheme();
  const [allListings, setAllListings] = useState({ bike: [], car: [], bus: [], tour: [] });
  const [loadingListings, setLoadingListings] = useState(true);
  const [search, setSearch] = useState("");

  const [selected, setSelected] = useState(null); // { category, listingId }
  const days = useMemo(() => nextDays(7), []);
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

  const panelRef = useRef(null);

  useEffect(() => {
    (async () => {
      setLoadingListings(true);
      const { data } = await supabase.from("listings").select("*").eq("active", true).order("price", { ascending: true });
      const grouped = { bike: [], car: [], bus: [], tour: [] };
      (data || []).forEach((l) => {
        if (grouped[l.category]) grouped[l.category].push(l);
      });
      setAllListings(grouped);
      setLoadingListings(false);
    })();
  }, []);

  const listing = selected ? allListings[selected.category]?.find((l) => l.id === selected.listingId) : null;

  useEffect(() => {
    if (!selected) return;
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
  }, [selected, date]);

  useEffect(() => {
    if (selected && panelRef.current) {
      panelRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [selected]);

  function chooseListing(category, listingId) {
    setError("");
    setTicket(null);
    setSelected({ category, listingId });
  }

  const canConfirm = listing && slot && name.trim() && phone.trim().length >= 7 && email.trim().includes("@") && !submitting;

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
      customer_email: email.trim(),
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
      email: email.trim(),
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
    setSelected(null);
    setSlot(null);
    setName("");
    setPhone("");
    setEmail("");
  }

  const term = search.trim().toLowerCase();
  const matches = (l) => !term || l.name.toLowerCase().includes(term);

  return (
    <div className="font-body min-h-screen w-full" style={{ color: COLORS.text }}>
      {/* Navbar with search */}
      <header
        className="flex items-center gap-3 px-5 py-4 sticky top-0 z-20"
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
        <div className="relative flex-1 max-w-md">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search bikes, cars, tours..."
            className="w-full pl-9 pr-3 py-2.5 rounded-full text-sm"
            style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
          />
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-xs font-mono shrink-0" style={{ color: COLORS.muted }}>
          <MapPin size={13} />
          {BUSINESS.location}
        </div>
        <ThemeToggle />
      </header>

      {/* Hero */}
      <section className="relative px-5 pt-10 pb-8 text-center">
        <div
          className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full mb-4 font-mono text-[10px] tracking-[0.2em]"
          style={{ background: COLORS.accentSoft, color: COLORS.accent, border: `1px solid rgba(245,183,0,0.25)` }}
        >
          <span className="w-1.5 h-1.5 rounded-full" style={{ background: COLORS.accent }} />
          RENTALS &amp; BHUBANESWAR SIGHTSEEING
        </div>
        <h1 className="font-display text-5xl sm:text-7xl leading-none">
          BOOK YOUR <span style={{ color: COLORS.accent }}>RIDE</span>
        </h1>
        <p className="mt-3 text-base" style={{ color: COLORS.muted }}>
          Browse bikes, cars, buses and tours below — pick one and lock in your slot.
        </p>
        <nav className="flex justify-center gap-2 flex-wrap mt-6">
          {CATEGORIES.map((c) => (
            <a
              key={c.key}
              href={`#${c.key}`}
              className="flex items-center gap-1.5 px-4 py-2 rounded-full text-sm font-semibold"
              style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
            >
              <c.icon size={14} color={COLORS.accent} />
              {c.label}
            </a>
          ))}
        </nav>
      </section>

      {/* Booking panel — appears once a listing is chosen */}
      {selected && (
        <div ref={panelRef} style={{ scrollMarginTop: "72px" }} className="px-5 pb-2">
          {ticket ? (
            <TicketView ticket={ticket} waLink={waLink()} onReset={resetFlow} colors={COLORS} business={BUSINESS} />
          ) : (
            <div
              className="max-w-xl mx-auto rounded-2xl p-5"
              style={{ background: `linear-gradient(160deg, ${COLORS.surface}, ${COLORS.surface2})`, border: `1px solid ${COLORS.accent}`, boxShadow: `0 12px 32px ${COLORS.glow}` }}
            >
              <div className="flex items-center justify-between mb-4">
                <div>
                  <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>BOOKING</p>
                  <p className="font-semibold">{listing ? listing.name : "..."}</p>
                </div>
                <button onClick={() => setSelected(null)} className="p-2 rounded-full" style={{ background: COLORS.surface2 }}>
                  <X size={16} color={COLORS.muted} />
                </button>
              </div>

              <p className="font-mono text-xs tracking-widest mb-2" style={{ color: COLORS.muted }}>SELECT DATE</p>
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
                {selected.category === "tour" ? "SELECT PICKUP TIME" : "SELECT TIME"}
              </p>
              <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 mb-5">
                {loadingSlots
                  ? Array.from({ length: 6 }).map((_, i) => <div key={i} className="h-10 rounded-lg animate-pulse" style={{ background: COLORS.surface2 }} />)
                  : SLOTS.map((s) => {
                      const isBooked = takenSlots.includes(s);
                      const active = slot === s;
                      return (
                        <button
                          key={s}
                          disabled={isBooked}
                          onClick={() => setSlot(s)}
                          className="font-mono text-sm py-2.5 rounded-lg flex items-center justify-center gap-1.5"
                          style={{
                            background: isBooked ? "transparent" : active ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
                            border: `1px solid ${isBooked ? COLORS.border : active ? "transparent" : COLORS.border}`,
                            color: isBooked ? COLORS.muted : active ? COLORS.bg : COLORS.text,
                            opacity: isBooked ? 0.4 : 1,
                            textDecoration: isBooked ? "line-through" : "none",
                          }}
                        >
                          <Clock size={12} />
                          {s}
                        </button>
                      );
                    })}
              </div>

              <div className="grid sm:grid-cols-2 gap-3 mb-3">
                <div className="relative">
                  <User size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder="Full name" value={name} onChange={(e) => setName(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
                <div className="relative">
                  <Phone size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                  <input placeholder="Phone number" value={phone} onChange={(e) => setPhone(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
                </div>
              </div>
              <div className="relative mb-4">
                <Mail size={15} className="absolute left-3 top-1/2 -translate-y-1/2" color={COLORS.muted} />
                <input type="email" placeholder="Email address" value={email} onChange={(e) => setEmail(e.target.value)} className="w-full pl-9 pr-3 py-2.5 rounded-lg text-sm" style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }} />
              </div>
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
                {submitting ? <Loader2 className="animate-spin" size={18} /> : <>Confirm Booking <ChevronRight size={18} /></>}
              </button>
            </div>
          )}
        </div>
      )}

      {/* Category sections with photo cards */}
      <main className="pb-16">
        {loadingListings ? (
          <div className="flex justify-center py-16">
            <Loader2 className="animate-spin" style={{ color: COLORS.accent }} size={28} />
          </div>
        ) : (
          CATEGORIES.map((cat) => {
            const items = allListings[cat.key].filter(matches);
            if (term && items.length === 0) return null;
            return (
              <section key={cat.key} id={cat.key} className="pt-10 px-5" style={{ scrollMarginTop: "72px" }}>
                <div className="flex items-center gap-2 mb-4 max-w-5xl mx-auto">
                  <cat.icon size={20} color={COLORS.accent} />
                  <h2 className="font-display text-2xl">{cat.label}</h2>
                </div>
                {items.length === 0 ? (
                  <p className="text-sm max-w-5xl mx-auto" style={{ color: COLORS.muted }}>No {cat.label.toLowerCase()} available right now.</p>
                ) : (
                  <div className="flex gap-4 overflow-x-auto pb-3 max-w-5xl mx-auto sm:flex-wrap sm:overflow-visible">
                    {items.map((l) => (
                      <PhotoCard
                        key={l.id}
                        listing={l}
                        category={cat}
                        selected={selected && selected.listingId === l.id}
                        onBook={() => chooseListing(cat.key, l.id)}
                      />
                    ))}
                  </div>
                )}
              </section>
            );
          })
        )}
      </main>

      {/* Footer */}
      <footer className="px-6 py-10 flex flex-col items-center gap-5" style={{ borderTop: `1px solid ${COLORS.border}` }}>
        <p className="font-mono text-xs tracking-widest" style={{ color: COLORS.muted }}>QUESTIONS? REACH US DIRECTLY</p>
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
        <a href="/admin/login" className="text-xs font-mono opacity-40" style={{ color: COLORS.muted }}>admin</a>
      </footer>
    </div>
  );
}

function PhotoCard({ listing, category, selected, onBook }) {
  const Icon = category.icon;
  return (
    <div
      className="shrink-0 w-52 sm:w-56 rounded-2xl overflow-hidden flex flex-col"
      style={{ background: COLORS.surface, border: `1px solid ${selected ? COLORS.accent : COLORS.border}`, boxShadow: selected ? `0 8px 24px ${COLORS.glow}` : "0 2px 8px rgba(0,0,0,0.15)" }}
    >
      <div className="h-32 relative flex items-center justify-center overflow-hidden" style={{ background: listing.image_url ? "none" : `linear-gradient(135deg, ${category.tint}, ${COLORS.surface2})` }}>
        {listing.image_url ? (
          <img src={listing.image_url} alt={listing.name} className="w-full h-full object-cover" />
        ) : (
          <>
            <div className="absolute inset-0" style={{ opacity: 0.14 }}>
              <Icon size={26} color={COLORS.text} style={{ position: "absolute", top: 8, left: 10, transform: "rotate(-12deg)" }} />
              <Icon size={22} color={COLORS.text} style={{ position: "absolute", bottom: 10, left: 46, transform: "rotate(8deg)" }} />
              <Icon size={30} color={COLORS.text} style={{ position: "absolute", top: 18, right: 14, transform: "rotate(15deg)" }} />
              <Icon size={20} color={COLORS.text} style={{ position: "absolute", bottom: 14, right: 50, transform: "rotate(-10deg)" }} />
            </div>
            <Icon size={38} color={COLORS.accent} style={{ position: "relative", filter: `drop-shadow(0 2px 8px ${COLORS.glow})` }} />
          </>
        )}
        <span className="absolute top-2 right-2 font-mono text-[10px] px-2 py-1 rounded-full" style={{ background: "rgba(20,24,28,0.75)", color: COLORS.text, backdropFilter: "blur(4px)" }}>
          {listing.tag}{listing.hours ? ` · ${listing.hours}h` : ""}
        </span>
      </div>
      <div className="p-3.5 flex flex-col flex-1">
        <p className="font-semibold text-sm leading-tight mb-1.5 line-clamp-2">{listing.name}</p>
        <p className="font-mono text-sm mb-3">
          <span style={{ color: COLORS.accent }}>₹{listing.price}</span>
          <span style={{ color: COLORS.muted }}>{listing.unit}</span>
        </p>
        <button
          onClick={onBook}
          className="mt-auto w-full py-2 rounded-lg text-sm font-semibold"
          style={{
            background: selected ? `linear-gradient(135deg, ${COLORS.accent}, ${COLORS.accentBright})` : COLORS.surface2,
            color: selected ? COLORS.bg : COLORS.text,
            border: selected ? "none" : `1px solid ${COLORS.border}`,
          }}
        >
          {selected ? "Selected" : "Book"}
        </button>
      </div>
    </div>
  );
}

function TicketView({ ticket, waLink, onReset, colors, business }) {
  return (
    <div className="max-w-md mx-auto animate-fade-up">
      <div className="rounded-3xl overflow-hidden mx-auto" style={{ background: `linear-gradient(160deg, ${colors.surface}, ${colors.surface2})`, border: `1px solid ${colors.border}`, boxShadow: `0 20px 50px rgba(0,0,0,0.4)` }}>
        <div className="p-6 flex items-center gap-3" style={{ background: `linear-gradient(135deg, rgba(245,183,0,0.18), rgba(245,183,0,0.04))` }}>
          <div className="w-9 h-9 rounded-full flex items-center justify-center" style={{ background: `linear-gradient(135deg, ${colors.accent}, ${colors.accentBright})`, boxShadow: `0 4px 14px ${colors.glow}` }}>
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
