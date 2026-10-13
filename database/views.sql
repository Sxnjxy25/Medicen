CREATE OR REPLACE VIEW dashboard_summary AS
SELECT
(SELECT COUNT(*) FROM medicines WHERE active IS NOT FALSE) AS total_medicines,
(SELECT COALESCE(SUM(remaining_quantity), 0) FROM stock) AS total_stock,
(SELECT COUNT(*) FROM stock WHERE expiry_date < CURRENT_DATE) AS expired,
(SELECT COALESCE(SUM(grand_total), 0) FROM sales WHERE DATE(sale_date) = CURRENT_DATE) AS today_sales;

CREATE OR REPLACE VIEW daily_sales AS
SELECT
DATE(sale_date) AS sales_date,
COUNT(*) AS total_bills,
COALESCE(SUM(grand_total), 0) AS total_amount
FROM sales
GROUP BY DATE(sale_date)
ORDER BY sales_date DESC;

CREATE OR REPLACE VIEW monthly_sales AS
SELECT
DATE_TRUNC('month', sale_date) AS month,
COALESCE(SUM(grand_total), 0) AS amount
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;

CREATE OR REPLACE VIEW low_stock AS
SELECT
m.medicine_name,
COALESCE(m.quantity, s.remaining_quantity, 0) AS remaining_quantity
FROM medicines m
LEFT JOIN stock s ON m.id = s.medicine_id
WHERE COALESCE(m.quantity, s.remaining_quantity, 0) <= COALESCE(m.minimum_stock, 10);