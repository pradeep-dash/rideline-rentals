import React from "react";
import { Sun, Moon, Monitor } from "lucide-react";
import { useTheme } from "../ThemeContext.jsx";

export default function ThemeToggle() {
  const { mode, setMode, colors } = useTheme();
  const options = [
    { key: "light", icon: Sun },
    { key: "system", icon: Monitor },
    { key: "dark", icon: Moon },
  ];
  return (
    <div className="flex items-center p-1 rounded-full gap-0.5" style={{ background: colors.surface2, border: `1px solid ${colors.border}` }}>
      {options.map((o) => {
        const active = mode === o.key;
        return (
          <button
            key={o.key}
            onClick={() => setMode(o.key)}
            className="p-1.5 rounded-full flex items-center justify-center"
            style={{ background: active ? colors.accent : "transparent" }}
            aria-label={`${o.key} theme`}
          >
            <o.icon size={13} color={active ? colors.bg : colors.muted} />
          </button>
        );
      })}
    </div>
  );
}
