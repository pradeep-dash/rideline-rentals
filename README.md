# RideLine Rentals — MVP

A vehicle booking app (bikes, cars, buses, sightseeing tours) with a real
database, no-double-booking guarantees, and a password-protected admin panel.

## Stack
- **Frontend:** React + Vite, React Router, Tailwind (via CDN, no build step needed)
- **Backend:** Supabase (Postgres database + auth) — free tier is enough for an MVP
- **Hosting:** Vercel (recommended — free, zero-config for Vite apps)

---

## 1. Set up Supabase (~5 minutes)

1. Go to [supabase.com](https://supabase.com) → create a free account → **New project**.
2. Once it's created, open **SQL Editor** → **New query**.
3. Paste the entire contents of `supabase/schema.sql` and click **Run**.
   This creates the `listings` and `bookings` tables, sets up security rules
   so customers can never see each other's phone numbers or double-book a
   slot, and seeds your current fleet (bikes, cars, buses, tours).
4. Create your admin login: **Authentication** → **Users** → **Add user**.
   Enter an email and password — this is what you'll use to log into `/admin`.
5. Get your API keys: **Project Settings** → **API**. Copy the **Project URL**
   and the **anon public** key.

## 2. Configure the app

```bash
cp .env.example .env
```

Open `.env` and paste in your Project URL and anon key:

```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-public-key
```

Then edit `src/config.js` with your real business details (WhatsApp number,
Instagram, Facebook, location).

## 3. Run it locally

```bash
npm install
npm run dev
```

Open the URL it prints (usually `http://localhost:5173`). Book a test slot,
then log in at `http://localhost:5173/admin/login` with the admin user you
created in step 1.4 to see it appear under the Bookings tab.

## 4. Deploy (Vercel)

1. Push this folder to a GitHub repo.
2. Go to [vercel.com](https://vercel.com) → **Add New Project** → import the repo.
3. Vercel auto-detects Vite. Before deploying, add your environment variables
   under **Environment Variables**: `VITE_SUPABASE_URL` and
   `VITE_SUPABASE_ANON_KEY` (same values as your `.env`).
4. Click **Deploy**. You'll get a live URL (e.g. `rideline.vercel.app`) —
   add a custom domain later from the Vercel dashboard if you have one.

Your customer app is now live at the root URL, and your admin panel at
`/admin/login`.

---

## How it works

- **No double-booking:** the database itself rejects two bookings for the
  same vehicle/tour + date + time slot (a unique constraint), not just the
  UI — so it holds even if two people book at the exact same second.
- **Privacy:** customers checking availability only ever see which slots are
  taken, never other customers' names or phone numbers. Only your logged-in
  admin account can see full booking details.
- **WhatsApp handoff:** after booking, the customer gets a "Confirm via
  WhatsApp" button that opens a chat to your number with all the booking
  details pre-filled — no messaging API needed.

## Managing your fleet

Log into `/admin` to add, edit, hide, or delete bikes/cars/buses/tours, and
to view or cancel bookings. No code changes needed for day-to-day updates.

## Reasonable next steps (not included in this MVP)

- Vehicle photos (Supabase Storage is a natural fit)
- SMS/email confirmations (e.g. via Twilio or Resend) instead of relying on
  the customer to tap "Confirm via WhatsApp"
- Online payment/deposit collection (Razorpay/Stripe)
- Multiple admin accounts with different permission levels
