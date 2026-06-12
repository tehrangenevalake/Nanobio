-- ================================================
-- PLAY Dodi — Supabase Database Setup
-- این SQL را در Supabase SQL Editor اجرا کنید
-- ================================================

-- 1. Daily Reports
CREATE TABLE IF NOT EXISTS daily_reports (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date DATE NOT NULL,
  closing_time TEXT,
  closed_by TEXT NOT NULL,
  paiement_sumup NUMERIC DEFAULT 0,
  paiement_mypos NUMERIC DEFAULT 0,
  paiement_especes NUMERIC DEFAULT 0,
  chiffre_affaire NUMERIC DEFAULT 0,
  vente_uber_eats NUMERIC DEFAULT 0,
  vente_just_eat NUMERIC DEFAULT 0,
  chiffre_total_jour NUMERIC DEFAULT 0,
  tva_8_1 NUMERIC DEFAULT 0,
  tva_2_6 NUMERIC DEFAULT 0,
  total_tva NUMERIC DEFAULT 0,
  achats_especes JSONB DEFAULT '[]',
  paiements_mypos_details JSONB DEFAULT '[]',
  paiements_ubs JSONB DEFAULT '[]',
  total_achats_especes NUMERIC DEFAULT 0,
  total_paiement_mypos_fournisseurs NUMERIC DEFAULT 0,
  total_paiement_ubs NUMERIC DEFAULT 0,
  reste_especes NUMERIC DEFAULT 0,
  caisse_depart NUMERIC DEFAULT 400,
  pourboires NUMERIC DEFAULT 0,
  solde_especes_final NUMERIC DEFAULT 0,
  solde_mypos_final NUMERIC DEFAULT 0,
  ajustement_tresorerie NUMERIC DEFAULT 0,
  notes TEXT,
  last_modified_by TEXT,
  is_sample BOOLEAN DEFAULT false,
  created_date TIMESTAMPTZ DEFAULT NOW(),
  updated_date TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Suppliers
CREATE TABLE IF NOT EXISTS suppliers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT CHECK (category IN ('especes', 'mypos', 'ubs')),
  created_date TIMESTAMPTZ DEFAULT NOW(),
  updated_date TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Treasury
CREATE TABLE IF NOT EXISTS treasuries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  person TEXT NOT NULL CHECK (person IN ('Navid', 'Saeed')),
  solde NUMERIC DEFAULT 0,
  manually_edited BOOLEAN DEFAULT false,
  manually_edited_by TEXT,
  manually_edited_date DATE,
  created_date TIMESTAMPTZ DEFAULT NOW(),
  updated_date TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Treasury Logs
CREATE TABLE IF NOT EXISTS treasury_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  person TEXT NOT NULL CHECK (person IN ('Navid', 'Saeed')),
  date DATE NOT NULL,
  montant NUMERIC NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('ajustement_caisse','retrait_banque','depot_banque','pourboire','achat','autre')),
  description TEXT,
  modified_by TEXT,
  report_id TEXT,
  created_date TIMESTAMPTZ DEFAULT NOW(),
  updated_date TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- Row Level Security — همه کاربران می‌تونن بخونن و بنویسن
-- (چون login با کد عددی هست، نه auth)
-- ================================================
ALTER TABLE daily_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE treasuries ENABLE ROW LEVEL SECURITY;
ALTER TABLE treasury_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON daily_reports FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON suppliers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON treasuries FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON treasury_logs FOR ALL USING (true) WITH CHECK (true);
