\set ON_ERROR_STOP on
-- Listing 12.1: a deterministic (unkeyed SHA-256) hash keeps records linkable and is re-identifiable by candidate lookup
CREATE TEMP TABLE shared_extract AS
SELECT encode(sha256(convert_to(lower(c.email), 'UTF8')), 'hex') AS customer_token,
       o.order_date::date AS order_date, o.total_amount
FROM raw.customers c JOIN raw.orders o USING (customer_id)
WHERE o.order_status = 'Completed';
-- A recipient who already holds a list of candidate emails (for example, its own customers)
CREATE TEMP TABLE recipient_candidates(email text);
INSERT INTO recipient_candidates VALUES ('alice@example.com'), ('zoe@example.com');
SELECT r.email AS reidentified_as, e.order_date, e.total_amount
FROM shared_extract e
JOIN recipient_candidates r
  ON e.customer_token = encode(sha256(convert_to(lower(r.email), 'UTF8')), 'hex')
ORDER BY e.order_date;
-- Tokens still link the same person's orders across rows
SELECT customer_token = lag(customer_token) OVER (ORDER BY order_date, total_amount) AS same_as_previous,
       left(customer_token, 12) AS token_prefix, order_date, total_amount
FROM shared_extract ORDER BY order_date, total_amount;
SELECT eds_assert.expect_rows('Listing 12.1 candidate lookup', $q$
SELECT r.email, e.total_amount FROM shared_extract e
JOIN recipient_candidates r ON e.customer_token = encode(sha256(convert_to(lower(r.email), 'UTF8')), 'hex')$q$,
  $e$(alice@example.com,79.98); (alice@example.com,9.98)$e$);
