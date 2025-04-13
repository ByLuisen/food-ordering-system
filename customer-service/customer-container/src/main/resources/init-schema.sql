DROP SCHEMA IF EXISTS customer CASCADE;

CREATE SCHEMA customer;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS customer.customers CASCADE;

CREATE TABLE customer.customers (
    id UUID NOT NULL,
    username CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    first_name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    last_name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);

DROP MATERIALIZED VIEW IF EXISTS customer.mv_customer_order;

CREATE MATERIALIZED VIEW customer.mv_customer_order
TABLESPACE pg_default
AS
 SELECT id, username, first_name, last_name
 FROM customer.customers
WITH DATA;

REFRESH MATERIALIZED VIEW customer.mv_customer_order;

DROP FUNCTION IF EXISTS customer.fn_mv_refresh_customer_order;

CREATE OR REPLACE FUNCTION customer.fn_mv_refresh_customer_order()
RETURNS TRIGGER
AS '
BEGIN
    REFRESH MATERIALIZED VIEW customer.mv_customer_order;
    return null;
END;
'  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trig_mv_refresh_customer_order ON customer.customers;

CREATE TRIGGER trig_mv_refresh_customer_order
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON customer.customers FOR EACH STATEMENT
EXECUTE PROCEDURE customer.fn_mv_refresh_customer_order();