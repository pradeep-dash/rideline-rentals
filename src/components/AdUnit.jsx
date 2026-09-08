import React, { useEffect, useRef } from "react";
import { ADSENSE_CLIENT_ID } from "../config.js";

// A single reusable AdSense unit. Safe to mount/unmount repeatedly (e.g. when
// switching language or theme re-renders the page) — it only calls
// adsbygoogle.push() once per physical <ins> element.
export default function AdUnit({ slot, format = "auto", style, label = "Advertisement" }) {
  const pushedRef = useRef(false);

  useEffect(() => {
    if (pushedRef.current) return;
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
      pushedRef.current = true;
    } catch (e) {
      // AdSense script may not be loaded yet (e.g. ad blocker) — fail silently,
      // never break the page over an ad.
      console.warn("AdSense unit could not load:", e);
    }
  }, []);

  // Don't render anything meaningful until a real client ID is configured —
  // avoids reserving blank ad space while you're still waiting on approval.
  if (!ADSENSE_CLIENT_ID || ADSENSE_CLIENT_ID.includes("XXXX")) return null;

  return (
    <div className="w-full flex flex-col items-center my-2">
      <span className="text-[10px] font-mono tracking-widest opacity-40 mb-1">{label}</span>
      <ins
        className="adsbygoogle"
        style={style || { display: "block", width: "100%" }}
        data-ad-client={ADSENSE_CLIENT_ID}
        data-ad-slot={slot}
        data-ad-format={format}
        data-full-width-responsive="true"
      />
    </div>
  );
}

