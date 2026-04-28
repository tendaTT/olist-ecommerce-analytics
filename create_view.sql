SELECT 
    o.order_id,
    o.order_purchase_timestamp AS purchase_date,
    o.order_status,
    EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS delivery_days_actual,
    EXTRACT(DAY FROM (o.order_estimated_delivery_date - o.order_purchase_timestamp)) AS delivery_days_estimated,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    p.product_id,
    t.product_category_name_english AS category,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_order_item_value,
    pay.payment_type,
    pay.payment_installments   
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN (
    SELECT DISTINCT ON (order_id) order_id, payment_type, payment_installments 
    FROM order_payments
) pay ON o.order_id = pay.order_id

WHERE o.order_status = 'delivered';