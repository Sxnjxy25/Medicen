-- Medicine search
CREATE INDEX IF NOT EXISTS idx_medicine_name ON medicines(medicine_name);
CREATE INDEX IF NOT EXISTS idx_generic_name ON medicines(generic_name);
CREATE INDEX IF NOT EXISTS idx_manufacturer ON medicines(manufacturer);
CREATE INDEX IF NOT EXISTS idx_company ON medicines(company);
CREATE INDEX IF NOT EXISTS idx_qr_code ON medicines(qr_code);
CREATE INDEX IF NOT EXISTS idx_barcode ON medicines(barcode);

-- Stock search
CREATE INDEX IF NOT EXISTS idx_expiry ON stock(expiry_date);
CREATE INDEX IF NOT EXISTS idx_batch ON stock(batch_number);

-- Sales
CREATE INDEX IF NOT EXISTS idx_sale_date ON sales(sale_date);
