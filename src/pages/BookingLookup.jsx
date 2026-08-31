import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Search, Loader2, ArrowLeft } from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { useTheme } from "../ThemeContext.jsx";
import { BUSINESS } from "../config.js";

export default function BookingLookup() {
  const { colors } = useTheme();
  const [phone, setPhone] = useState("");
  const [code, setCode] = useState("");
  const [results, setResults] = useState(null);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);

  async function search(e) {
    e.preventDefault();
    setLoading(true);
    setSearched(true);
    const { data } = await supabase.rpc("lookup_booking", { p_phone: phone.trim(), p_code: code.trim() });
    setResults(data || []);
    setLoading(false);
  }

  return (
    <div className="min-h-screen font-body px-5 py-8" style={{ background: colors.bg, color: colors.text }}>
      <div className="max-w-md mx-auto">
        <Link to="/" className="flex items-center gap-1.5 text-sm mb-6" style={{ color: colors.muted }}>
          <ArrowLeft size={15} /> Back to {BUSINESS.name}
        </Link>

        <h1 className="font-display text-4xl mb-2">CHECK YOUR BOOKING</h1>
        <p className="text-sm mb-6" style={{ color: colors.muted }}>
          Enter the phone number and booking code you used when booking.
        </p>

        <form onSubmit={search} className="space-y-3 mb-6">
          <input
            placeholder="Phone number"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className="w-full px-3 py-2.5 rounded-lg text-sm"
            style={{ background: colors.surface2, border: `1px solid ${colors.border}`, color: colors.text }}
          />
          <input
            placeholder="Booking code"
            value={code}
            onChange={(e) => setCode(e.target.value)}
            className="w-full px-3 py-2.5 rounded-lg text-sm"
            style={{ background: colors.surface2, border: `1px solid ${colors.border}`, color: colors.text }}
          />
          <button
            type="submit"
            disabled={loading || !phone.trim() || !code.trim()}
            className="w-full py-3 rounded-lg font-semibold flex items-center justify-center gap-2"
            style={{ background: colors.accent, color: colors.bg }}
          >
            {loading ? <Loader2 className="animate-spin" size={16} /> : <><Search size={16} /> Check</>}
          </button>
        </form>

        {searched && !loading && (
          <>
            {results && results.length > 0 ? (
              <div className="space-y-3">
                {results.map((r, i) => (
                  <div key={i} className="rounded-xl p-4" style={{ background: colors.surface, border: `1px solid ${colors.border}` }}>
                    <div className="flex items-center justify-between mb-2">
                      <span className="font-semibold text-sm">{r.listing_name}</span>
                      <span
                        className="text-xs font-mono px-2 py-0.5 rounded-full capitalize"
                        style={{ background: r.status === "cancelled" ? "rgba(242,107,107,0.15)" : "rgba(37,211,102,0.15)", color: r.status === "cancelled" ? colors.danger : colors.whatsapp }}
                      >
                        {r.status}
                      </span>
                    </div>
                    <p className="text-xs font-mono" style={{ color: colors.muted }}>
                      {r.booking_date} · {r.slot_time}
                    </p>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm" style={{ color: colors.muted }}>
                No booking found with that phone number and code — double-check and try again.
              </p>
            )}
          </>
        )}
      </div>
    </div>
  );
}
