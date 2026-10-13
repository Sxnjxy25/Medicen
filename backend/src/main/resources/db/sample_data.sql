-- ============================================================================
-- Seed Sample Data for MediStock Pharmacy & Medicals
-- ============================================================================

-- 1. Seed Racks
INSERT INTO racks (rack_name, shelf_number, box_number, description) VALUES
('Rack A', 1, 10, 'General Medicines - Row 1'),
('Rack A', 2, 12, 'General Medicines - Row 2'),
('Rack B', 1, 5, 'Antibiotics Shelf'),
('Rack B', 2, 8, 'Painkillers and Analgesics'),
('Rack C', 1, 15, 'Syrups and Liquid Formulations'),
('Rack D', 1, 3, 'Refrigerated Items / Insulin');

-- 2. Seed Suppliers
INSERT INTO suppliers (supplier_name, contact_person, phone, email, address, gst_number) VALUES
('PharmaCorp India', 'Rajesh Kumar', '9876543210', 'contact@pharmacorp.in', '12, Industrial Area, Phase-I, New Delhi', '07AAAAA1111A1Z1'),
('MedLife Supplies', 'Dr. Priya Patel', '8765432109', 'sales@medlifesupplies.com', '45, Health Plaza, Ashram Road, Ahmedabad', '24BBBBB2222B2Z2'),
('HealthPharma Ltd', 'Amit Sharma', '7654321098', 'info@healthpharma.com', '78, Pharmacy Street, Bandra West, Mumbai', '27CCCCC3333C3Z3'),
('CureWell Distributors', 'Neha Singh', '6543210987', 'orders@curewelldist.com', '101, Medical Colony, T. Nagar, Chennai', '33DDDDD4444D4Z4');

-- 3. Seed Medicines
INSERT INTO medicines (medicine_code, qr_code, barcode, medicine_name, generic_name, manufacturer, company, category, unit, purchase_price, selling_price, gst_percentage, gst, rack_id, minimum_stock, prescription_required, active, quantity, image_url, status) VALUES
('MED-001', 'QR_PARA_500', '8901030700012', 'Paracetamol 500mg', 'Paracetamol', 'Cipla Ltd', 'Cipla Ltd', 'Analgesic', 'Tablet', 1.20, 2.00, 5.00, 5.00, 'Rack A-2', 100, FALSE, TRUE, 950, NULL, TRUE),
('MED-002', 'QR_AMOX_250', '8901030700029', 'Amoxicillin 250mg', 'Amoxicillin', 'GSK India', 'GSK India', 'Antibiotic', 'Capsule', 4.50, 6.50, 12.00, 12.00, 'Rack B-1', 50, TRUE, TRUE, 480, NULL, TRUE),
('MED-003', 'QR_IBU_400', '8901030700036', 'Ibuprofen 400mg', 'Ibuprofen', 'Abbott Labs', 'Abbott Labs', 'NSAID', 'Tablet', 2.10, 3.20, 12.00, 12.00, 'Rack B-2', 50, FALSE, TRUE, 750, NULL, TRUE),
('MED-004', 'QR_MET_500', '8901030700043', 'Metformin 500mg', 'Metformin Hydrochloride', 'Sun Pharma', 'Sun Pharma', 'Antidiabetic', 'Tablet', 3.00, 4.50, 8.00, 8.00, 'Rack A-1', 40, TRUE, TRUE, 580, NULL, TRUE),
('MED-005', 'QR_OME_20', '8901030700050', 'Omeprazole 20mg', 'Omeprazole', 'Dr. Reddys', 'Dr. Reddys', 'Antacid', 'Capsule', 2.50, 3.80, 5.00, 5.00, 'Rack C-1', 60, FALSE, TRUE, 390, NULL, TRUE),
('MED-006', 'QR_CET_10', '8901030700067', 'Cetirizine 10mg', 'Cetirizine Dihydrochloride', 'Cipla Ltd', 'Cipla Ltd', 'Antihistamine', 'Tablet', 0.80, 1.50, 5.00, 5.00, 'Rack A-1', 100, FALSE, TRUE, 1150, NULL, TRUE),
('MED-007', 'QR_ASP_75', '8901030700074', 'Aspirin 75mg', 'Acetylsalicylic Acid', 'Bayer India', 'Bayer India', 'Antiplatelet', 'Tablet', 1.00, 1.80, 5.00, 5.00, 'Rack A-2', 30, FALSE, TRUE, 20, NULL, TRUE),
('MED-008', 'QR_AZI_500', '8901030700081', 'Azithromycin 500mg', 'Azithromycin', 'Pfizer Ltd', 'Pfizer Ltd', 'Antibiotic', 'Tablet', 12.00, 18.00, 12.00, 12.00, 'Rack B-1', 30, TRUE, TRUE, 180, NULL, TRUE),
('MED-009', 'QR_ATOR_10', '8901030700098', 'Atorvastatin 10mg', 'Atorvastatin Calcium', 'Sun Pharma', 'Sun Pharma', 'Statin', 'Tablet', 5.50, 8.00, 12.00, 12.00, 'Rack A-2', 40, TRUE, TRUE, 290, NULL, TRUE),
('MED-010', 'QR_INS_100', '8901030700104', 'Lantus Insulin 100IU', 'Insulin Glargine', 'Sanofi India', 'Sanofi India', 'Hormone', 'Injection', 320.00, 410.00, 5.00, 5.00, 'Rack D-1', 10, TRUE, TRUE, 42, NULL, TRUE);

-- 4. Seed Purchases
INSERT INTO purchases (supplier_id, supplier, invoice_number, purchase_date, items, total_amount, status) VALUES
(1, 'PharmaCorp India', 'PO-2026-001', '2026-06-15', 'Paracetamol 500mg x1000, Amoxicillin 250mg x500', 15000.00, 'Delivered'),
(2, 'MedLife Supplies', 'PO-2026-002', '2026-07-01', 'Ibuprofen 400mg x800, Metformin 500mg x600, Omeprazole 20mg x400', 34500.00, 'Delivered'),
(3, 'HealthPharma Ltd', 'PO-2026-003', '2026-07-10', 'Cetirizine 10mg x1200, Aspirin 75mg x300, Azithromycin 500mg x200', 8900.00, 'Delivered');

-- 5. Seed Stocks (Link medicines and purchases)
INSERT INTO stock (medicine_id, purchase_id, batch_number, manufacture_date, expiry_date, quantity, remaining_quantity) VALUES
(1, 1, 'B-PARA-001', '2025-10-01', '2027-10-01', 1000, 950),
(2, 1, 'B-AMOX-001', '2025-11-01', '2027-05-01', 500, 480),
(3, 2, 'B-IBU-102', '2026-01-01', '2028-01-01', 800, 750),
(4, 2, 'B-MET-203', '2025-12-01', '2027-12-01', 600, 580),
(5, 2, 'B-OME-304', '2026-02-01', '2028-02-01', 400, 390),
(6, 3, 'B-CET-405', '2026-03-01', '2028-03-01', 1200, 1150),
(7, 3, 'B-ASP-506', '2025-08-01', '2026-08-15', 300, 20),
(8, 3, 'B-AZI-607', '2026-04-01', '2027-10-01', 200, 180),
(9, 3, 'B-ATOR-708', '2026-02-01', '2028-02-01', 300, 290),
(10, 2, 'B-INS-809', '2026-05-01', '2027-05-01', 50, 42);

-- 6. Seed Customers
INSERT INTO customers (customer_name, phone) VALUES
('Rahul Sharma', '9988776655'),
('Priya Patel', '9876543211'),
('Amit Singh', '9765432112'),
('Sneha Verma', '9654321123'),
('Vikram Joshi', '9543211234');

-- 7. Seed Sales
INSERT INTO sales (invoice_number, customer_id, customer_name, user_id, sale_date, subtotal, total_amount, discount, gst, grand_total, payment_mode) VALUES
('INV-1001', 1, 'Rahul Sharma', 2, '2026-07-15 10:30:00', 38.00, 40.00, 2.00, 2.00, 40.00, 'Cash'),
('INV-1002', 2, 'Priya Patel', 2, '2026-07-16 14:15:00', 125.00, 130.00, 5.00, 15.60, 140.60, 'UPI'),
('INV-1003', 3, 'Amit Singh', 2, '2026-07-17 11:00:00', 12.80, 12.80, 0.00, 1.54, 14.34, 'Card'),
('INV-1004', 4, 'Sneha Verma', 2, '2026-07-18 09:45:00', 170.00, 180.00, 10.00, 21.60, 191.60, 'Cash');

-- 8. Seed Sale Items
INSERT INTO sale_items (sale_id, medicine_id, stock_id, medicine_name, quantity, price, subtotal) VALUES
(1, 1, 1, 'Paracetamol 500mg', 20, 2.00, 40.00),
(2, 2, 2, 'Amoxicillin 250mg', 20, 6.50, 130.00),
(3, 3, 3, 'Ibuprofen 400mg', 4, 3.20, 12.80),
(4, 8, 8, 'Azithromycin 500mg', 10, 18.00, 180.00);

-- 9. Seed Payments
INSERT INTO payments (sale_id, payment_type, amount, transaction_id, payment_date) VALUES
(1, 'Cash', 40.00, NULL, '2026-07-15 10:30:00'),
(2, 'UPI', 140.60, 'TXN987654321', '2026-07-16 14:15:00'),
(3, 'Card', 14.34, 'TXN123456789', '2026-07-17 11:00:00'),
(4, 'Cash', 191.60, NULL, '2026-07-18 09:45:00');

-- 10. Seed Notifications
INSERT INTO notifications (medicine_id, notification_type, message, status, created_at) VALUES
(7, 'EXPIRY_ALERT', 'Aspirin 75mg (Batch: B-ASP-506) is expiring soon on 2026-08-15!', FALSE, '2026-07-15 00:00:00'),
(7, 'LOW_STOCK', 'Aspirin 75mg is low in stock (Current: 20 units, Minimum: 30 units).', FALSE, '2026-07-18 09:45:00'),
(10, 'LOW_STOCK', 'Lantus Insulin 100IU is below its minimum stock threshold.', FALSE, '2026-07-18 09:45:00');
