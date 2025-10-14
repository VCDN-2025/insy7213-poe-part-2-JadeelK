-- Create a view to summarize total invoice amounts per customer
CREATE VIEW CustomerInvoiceSummary AS
SELECT 
    c.CUSTOMER_ID,
    c.FIRST_NAME,
    c.SURNAME,
    COUNT(i.INVOICE_NUM) AS NumberOfInvoices,
    SUM(d.PRICE) AS TotalAmount
FROM CUSTOMER c
LEFT JOIN INVOICE i ON c.CUSTOMER_ID = i.CUSTOMER_ID
LEFT JOIN DONATION d ON i.DONATION_ID = d.DONATION_ID
GROUP BY c.CUSTOMER_ID, c.FIRST_NAME, c.SURNAME;

-- Query to show customers with total invoice amounts greater than 1000, ordered by total amount
SELECT 
    CUSTOMER_ID,
    FIRST_NAME,
    SURNAME,
    NumberOfInvoices,
    TotalAmount
FROM CustomerInvoiceSummary
WHERE TotalAmount > 1000
ORDER BY TotalAmount DESC;