import React from "react";
import { useTheme } from "../ThemeContext.jsx";
import { useLanguage, LANGUAGES } from "../i18n.js";

export default function LanguageToggle() {
  const { colors } = useTheme();
  const { lang, setLang } = useLanguage();
  return (
    <div className="flex items-center p-1 rounded-full gap-0.5" style={{ background: colors.surface2, border: `1px solid ${colors.border}` }}>
      {Object.entries(LANGUAGES).map(([code, label]) => {
        const active = lang === code;
        return (
          <button
            key={code}
            onClick={() => setLang(code)}
            className="px-2 py-1 rounded-full text-[11px] font-semibold font-mono"
            style={{ background: active ? colors.accent : "transparent", color: active ? colors.bg : colors.muted }}
            aria-label={`Language: ${label}`}
            aria-pressed={active}
          >
            {label}
          </button>
        );
      })}
    </div>
  );
}
