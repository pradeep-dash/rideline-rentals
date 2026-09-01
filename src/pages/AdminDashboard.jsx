import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { LogOut, Plus, Pencil, Trash2, X, Loader2, ListChecks, CalendarDays, Tag, Star, BarChart3, Check as CheckIcon, Briefcase } from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";
import ThemeToggle from "../components/ThemeToggle.jsx";

const EMPTY_FORM = { category: "bike", name: "", price: "", unit: "/hr", tag: "", hours: "", active: true, image_url: "" };

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
    setForm({ ...l, price: String(l.price), hours: l.hours == null ? "" : String(l.hours), image_url: l.image_url || "" });
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
