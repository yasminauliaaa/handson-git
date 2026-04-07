
SELECT * FROM "Finance";


SELECT * FROM "Finance" 
ORDER BY "Sales" DESC 
LIMIT 5;


SELECT * FROM "Finance" 
WHERE "Country" = 'Canada';

SELECT SUM("Profit") AS total_keuntungan 
FROM "Finance";

SELECT *
FROM "Finance"
WHERE 
    "Sales" IS NULL
    OR "Profit" IS NULL;

SELECT 
    "Segment", "Country", "Product", "Date",
    COUNT(*)
FROM "Finance"
GROUP BY "Segment", "Country", "Product", "Date"
HAVING COUNT(*) > 1;

SELECT *
FROM "Finance"
WHERE "Profit" > "Sales";

ALTER TABLE "Finance"
ADD COLUMN "Gross Margin" NUMERIC;
UPDATE "Finance"
SET "Gross Margin" = ("Sales" - "COGS") / "Sales";

SELECT *
FROM "Finance"

ALTER TABLE "Finance"
ADD COLUMN "Revenue Contribution" NUMERIC;
UPDATE "Finance"
SET "Revenue Contribution" = "Sales" / (
    SELECT SUM("Sales") FROM "Finance"
);

SELECT *
FROM "Finance"

ALTER TABLE "Finance"
ADD COLUMN "Profit Margin" NUMERIC;
UPDATE "Finance"
SET "Profit Margin" = "Profit" / "Sales";

------------------------------------------

ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Gross Margin" NUMERIC;
UPDATE "Finance"
SET "Gross Margin" = ROUND(("Sales" - "COGS") / NULLIF("Sales", 0), 2);

ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Revenue Contribution" NUMERIC;
UPDATE "Finance"
SET "Revenue Contribution" = ROUND(
    "Sales" / NULLIF((SELECT SUM("Sales") FROM "Finance"), 0),
    4  -- sengaja 4 desimal karena nilainya sangat kecil (0.00xx)
);

ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Profit Margin" NUMERIC;
UPDATE "Finance"
SET "Profit Margin" = ROUND("Profit" / NULLIF("Sales", 0), 2);

-- ============================================
-- KOLOM TAMBAHAN REKOMENDASI
-- ============================================

-- 1. Discount Rate: seberapa besar diskon dari gross sales
ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Discount Rate" NUMERIC;
UPDATE "Finance"
SET "Discount Rate" = ROUND("Discounts" / NULLIF("GrossSales", 0), 2);

-- 2. COGS Ratio: efisiensi biaya produksi
ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "COGS Ratio" NUMERIC;
UPDATE "Finance"
SET "COGS Ratio" = ROUND("COGS" / NULLIF("Sales", 0), 2);

-- 3. Profit per Unit: profitabilitas per unit terjual
ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Profit per Unit" NUMERIC;
UPDATE "Finance"
SET "Profit per Unit" = ROUND("Profit" / NULLIF("UnitsSold", 0), 2);

-- 4. Is Profitable: flag untuk filter transaksi rugi
ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Is Profitable" BOOLEAN;
UPDATE "Finance"
SET "Is Profitable" = CASE WHEN "Profit" > 0 THEN TRUE ELSE FALSE END;

-- 5. Revenue per Unit: average selling price aktual
ALTER TABLE "Finance" ADD COLUMN IF NOT EXISTS "Revenue per Unit" NUMERIC;
UPDATE "Finance"
SET "Revenue per Unit" = ROUND("Sales" / NULLIF("UnitsSold", 0), 2);

-- Verifikasi
SELECT
    "Segment", "Country", "Product", "DiscountBand",
    "Sales", "COGS", "Profit",
    "Gross Margin",
    "Revenue Contribution",
    "Profit Margin",
    "Discount Rate",
    "COGS Ratio",
    "Profit per Unit",
    "Is Profitable",
    "Revenue per Unit"
FROM "Finance"
LIMIT 20;


