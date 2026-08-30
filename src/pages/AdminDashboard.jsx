import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { LogOut, Plus, Pencil, Trash2, X, Loader2, ListChecks, CalendarDays } from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { COLORS, BUSINESS } from "../config.js";

const EMPTY_FORM = { category: "bike", name: "", price: "", unit: "/hr", tag: "", hours: "", active: true };

export default function AdminDashboard() {
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
        <button onClick={logout} className="flex items-center gap-2 px-3 py-2 rounded-md text-sm" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}`, color: COLORS.muted }}>
          <LogOut size={14} /> Log out
        </button>
      </header>

      <div className="px-6 pt-5">
        <div className="flex p-1 rounded-md mb-6 w-fit" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
          {[
            { id: "listings", label: "Listings", icon: ListChecks },
            { id: "bookings", label: "Bookings", icon: CalendarDays },
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

      <div className="px-6 pb-16">{tab === "listings" ? <ListingsTab /> : <BookingsTab />}</div>
    </div>
  );
}

function ListingsTab() {
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
    setForm({ ...l, price: String(l.price), hours: l.hours == null ? "" : String(l.hours) });
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
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);

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

  async function cancel(id) {
    await supabase.from("bookings").update({ status: "cancelled" }).eq("id", id);
    load();
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
                <td className="px-3 py-2 font-mono">{b.customer_phone}</td>
                <td className="px-3 py-2 font-mono" style={{ color: COLORS.accent }}>{b.code}</td>
                <td className="px-3 py-2 capitalize">{b.status}</td>
                <td className="px-3 py-2">
                  {b.status === "confirmed" && (
                    <button onClick={() => cancel(b.id)} className="text-xs font-mono px-2 py-1 rounded" style={{ background: COLORS.surface2, color: COLORS.danger }}>
                      Cancel
                    </button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
