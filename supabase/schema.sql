-- RideLine Rentals — MVP schema
-- Run this once in Supabase: Project → SQL Editor → New query → paste → Run

create extension if not exists pgcrypto;

-- ---------- Tables ----------

create table if not exists listings (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('bike','car','bus','tour')),
  name text not null,
  price numeric not null,
  unit text not null default '/hr',
  tag text,
  hours integer,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references listings(id) on delete cascade,
  booking_date date not null,
  slot_time text not null,
  customer_name text not null,
  customer_phone text not null,
  code text not null,
  status text not null default 'confirmed' check (status in ('confirmed','cancelled')),
  created_at timestamptz not null default now(),
  -- This is what actually stops double-booking: two rows can't share the
  -- same vehicle/tour + date + time slot.
  unique (listing_id, booking_date, slot_time)
);

-- Public, PII-free view so the booking screen can grey out taken slots
-- without exposing any customer's name/phone to other visitors.
create or replace view taken_slots as
  select listing_id, booking_date, slot_time
  from bookings
  where status = 'confirmed';

-- ---------- Row Level Security ----------

alter table listings enable row level security;
alter table bookings enable row level security;

-- Listings: the public booking page can only see active listings.
create policy "Public can view active listings"
  on listings for select
  using (active = true);

-- Listings: logged-in admin can see everything (incl. inactive) and manage them.
create policy "Admins can view all listings"
  on listings for select
  to authenticated
  using (true);

create policy "Admins can insert listings"
  on listings for insert
  to authenticated
  with check (true);

create policy "Admins can update listings"
  on listings for update
  to authenticated
  using (true);

create policy "Admins can delete listings"
  on listings for delete
  to authenticated
  using (true);

-- Bookings: anyone (including anonymous customers) can create a booking.
create policy "Anyone can create a booking"
  on bookings for insert
  to anon, authenticated
  with check (true);

-- Bookings: only the logged-in admin can read/update/delete raw booking rows
-- (customer names & phone numbers stay private — the taken_slots view above
-- is what the public app uses to check availability).
create policy "Admins can view all bookings"
  on bookings for select
  to authenticated
  using (true);

create policy "Admins can update bookings"
  on bookings for update
  to authenticated
  using (true);

create policy "Admins can delete bookings"
  on bookings for delete
  to authenticated
  using (true);

grant select on taken_slots to anon, authenticated;

-- ---------- Seed data (your current fleet — edit anytime from /admin) ----------

insert into listings (category, name, price, unit, tag, hours) values
('bike', 'Royal Enfield Classic 350', 400, '/hr', 'Cruiser', null),
('bike', 'Yamaha FZ-S', 250, '/hr', 'Sport', null),
('bike', 'Honda Activa', 150, '/hr', 'Scooter', null),
('car', 'Maruti Swift Dzire', 1500, '/hr', 'Sedan', null),
('car', 'Hyundai Creta', 2200, '/hr', 'SUV', null),
('car', 'Toyota Innova Crysta', 3200, '/hr', 'MPV', null),
('bus', 'Tempo Traveller', 4500, '/day', '12-Seater', null),
('bus', 'Mini Bus', 7500, '/day', '20-Seater', null),
('bus', 'Luxury Coach', 12000, '/day', '35-Seater', null),
('tour', 'Temple City Trail — Lingaraj, Mukteshwar & Rajarani', 899, '/person', 'Half-day', 4),
('tour', 'Udayagiri-Khandagiri Caves & Dhauli Peace Pagoda', 799, '/person', 'Half-day', 4),
('tour', 'Nandankanan Zoological Park & Botanical Garden', 699, '/person', 'Half-day', 5),
('tour', 'Konark Sun Temple & Puri Beach Day Trip', 1499, '/person', 'Full-day', 10),
('tour', 'Bhubaneswar City Highlights + Chilika Lake', 1799, '/person', 'Full-day', 12);
