DROP SCHEMA IF EXISTS restaurant CASCADE;

CREATE SCHEMA restaurant;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS restaurant.restaurants CASCADE;

CREATE TABLE restaurant.restaurants (
    id UUID NOT NULL,
    name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    active BOOLEAN NOT NULL,
    CONSTRAINT pk_restaurants PRIMARY KEY (id)
);

DROP TYPE IF EXISTS type_approval_status;
CREATE TYPE type_approval_status AS ENUM ('APPROVED', 'REJECTED');

DROP TABLE IF EXISTS restaurant.order_approval CASCADE;

CREATE TABLE restaurant.order_approval (
    id UUID NOT NULL,
    restaurant_id UUID NOT NULL,
    order_id UUID NOT NULL,
    status type_approval_status NOT NULL,
    CONSTRAINT pk_order_approval PRIMARY KEY (id)
);

DROP TABLE IF EXISTS restaurant.products CASCADE;

CREATE TABLE restaurant.products (
    id UUID NOT NULL,
    name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    available BOOLEAN NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (id)
);

DROP TABLE IF EXISTS restaurant.restaurant_product CASCADE;

CREATE TABLE restaurant.restaurant_product (
    id UUID NOT NULL,
    restaurant_id UUID NOT NULL,
    product_id UUID NOT NULL,
    CONSTRAINT pk_restaurant_product PRIMARY KEY (id)
);

ALTER TABLE restaurant.restaurant_product
ADD CONSTRAINT fk_restaurant_product_restaurants FOREIGN KEY (restaurant_id)
REFERENCES restaurant.restaurants (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE RESTRICT
NOT VALID;

ALTER TABLE restaurant.restaurant_product
ADD CONSTRAINT fk_restaurant_product_products FOREIGN KEY (product_id)
REFERENCES restaurant.products (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE RESTRICT
NOT VALID;

DROP TYPE IF EXISTS type_outbox_status;
CREATE TYPE type_outbox_status AS ENUM ('STARTED', 'COMPLETED', 'FAILED');

DROP TABLE IF EXISTS restaurant.order_outbox CASCADE;

CREATE TABLE restaurant.order_outbox (
    id UUID NOT NULL,
    saga_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    processed_at TIMESTAMP WITH TIME ZONE,
    type CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    payload JSONB NOT NULL,
    outbox_status type_outbox_status NOT NULL,
    approval_status type_approval_status NOT NULL,
    version INTEGER NOT NULL,
    CONSTRAINT pk_order_outbox PRIMARY KEY (id)
);

CREATE INDEX "idx_order_outbox_type_approval_status"
ON "restaurant".order_outbox
(type, approval_status);

CREATE UNIQUE INDEX "uniq_order_outbox_type_saga_id_approval_status_outbox_status"
ON "restaurant".order_outbox
(type, saga_id, approval_status, outbox_status);

DROP MATERIALIZED VIEW IF EXISTS restaurant.mv_restaurant_product;

CREATE MATERIALIZED VIEW restaurant.mv_restaurant_product
TABLESPACE pg_default
AS
 SELECT r.id AS restaurant_id,
    r.name AS restaurant_name,
    r.active AS restaurant_active,
    p.id AS product_id,
    p.name AS product_name,
    p.price AS product_price,
    p.available AS product_available
   FROM restaurant.restaurants r,
    restaurant.products p,
    restaurant.restaurant_product rp
  WHERE r.id = rp.restaurant_id AND p.id = rp.product_id
WITH DATA;

REFRESH MATERIALIZED VIEW restaurant.mv_restaurant_product;

DROP FUNCTION IF EXISTS restaurant.fn_mv_refresh_restaurant_product;

CREATE OR REPLACE FUNCTION restaurant.fn_mv_refresh_restaurant_product()
RETURNS TRIGGER
AS '
BEGIN
    REFRESH MATERIALIZED VIEW restaurant.mv_restaurant_product;
    return null;
END;
'  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_mv_refresh_restaurant_product ON restaurant.restaurant_product;

CREATE TRIGGER trg_mv_refresh_restaurant_product
AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
ON restaurant.restaurant_product FOR EACH STATEMENT
EXECUTE PROCEDURE restaurant.fn_mv_refresh_restaurant_product();