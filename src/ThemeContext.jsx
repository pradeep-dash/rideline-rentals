import React, { createContext, useContext, useEffect, useState, useMemo } from "react";
import { DARK_COLORS, LIGHT_COLORS } from "./config.js";

const ThemeContext = createContext(null);

function getSystemPref() {
  if (typeof window !== "undefined" && window.matchMedia) {
    return window.matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark";
  }
  return "dark";
}

export function ThemeProvider({ children }) {
  const [mode, setMode] = useState(() => {
    try {
      return localStorage.getItem("rideline-theme") || "system";
    } catch {
      return "system";
    }
  });
  const [systemPref, setSystemPref] = useState(getSystemPref());

  useEffect(() => {
    const mq = window.matchMedia("(prefers-color-scheme: light)");
    const handler = () => setSystemPref(mq.matches ? "light" : "dark");
    mq.addEventListener("change", handler);
    return () => mq.removeEventListener("change", handler);
  }, []);

  useEffect(() => {
    try {
      localStorage.setItem("rideline-theme", mode);
    } catch {
      // ignore storage errors
    }
  }, [mode]);

  const resolved = mode === "system" ? systemPref : mode;

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", resolved);
  }, [resolved]);

  const colors = resolved === "light" ? LIGHT_COLORS : DARK_COLORS;

  const value = useMemo(() => ({ mode, setMode, resolved, colors }), [mode, resolved, colors]);

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>;
}

export function useTheme() {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error("useTheme must be used within a ThemeProvider");
  return ctx;
}
