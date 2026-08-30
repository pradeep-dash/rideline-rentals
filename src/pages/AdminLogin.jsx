import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { LogIn, Loader2 } from "lucide-react";
import { supabase } from "../supabaseClient.js";
import { BUSINESS } from "../config.js";
import { useTheme } from "../ThemeContext.jsx";

export default function AdminLogin() {
  const { colors: COLORS } = useTheme();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleSubmit(e) {
    e.preventDefault();
    setError("");
    setLoading(true);
    const { error: err } = await supabase.auth.signInWithPassword({ email, password });
    setLoading(false);
    if (err) {
      setError("Invalid email or password.");
      return;
    }
    navigate("/admin");
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-6" style={{ background: COLORS.bg, color: COLORS.text }}>
      <form onSubmit={handleSubmit} className="w-full max-w-sm p-6 rounded-lg" style={{ background: COLORS.surface, border: `1px solid ${COLORS.border}` }}>
        <p className="font-mono text-xs tracking-widest mb-1" style={{ color: COLORS.accent }}>
          {BUSINESS.name.toUpperCase()}
        </p>
        <h1 className="font-display text-4xl mb-6">ADMIN LOGIN</h1>

        <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>EMAIL</label>
        <input
          type="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full mb-4 px-3 py-2.5 rounded-md text-sm"
          style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
        />

        <label className="block font-mono text-xs mb-1.5" style={{ color: COLORS.muted }}>PASSWORD</label>
        <input
          type="password"
          required
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full mb-4 px-3 py-2.5 rounded-md text-sm"
          style={{ background: COLORS.surface2, border: `1px solid ${COLORS.border}`, color: COLORS.text }}
        />

        {error && <p className="text-xs mb-4" style={{ color: COLORS.danger }}>{error}</p>}

        <button
          type="submit"
          disabled={loading}
          className="w-full py-3 rounded-md font-semibold flex items-center justify-center gap-2"
          style={{ background: COLORS.accent, color: COLORS.bg }}
        >
          {loading ? <Loader2 className="animate-spin" size={18} /> : <><LogIn size={16} /> Log in</>}
        </button>

        <p className="text-xs mt-4" style={{ color: COLORS.muted }}>
          Create your admin login in Supabase: Authentication → Users → Add user.
        </p>
      </form>
    </div>
  );
}
