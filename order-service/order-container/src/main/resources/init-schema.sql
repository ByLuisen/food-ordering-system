DROP SCHEMA IF EXISTS "order" CASCADE;

CREATE SCHEMA "order";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TYPE IF EXISTS type_order_status;
CREATE TYPE type_order_status AS ENUM ('PENDING', 'PAID', 'APPROVED', 'CANCELLED', 'CANCELLING');

DROP TABLE IF EXISTS "order".orders CASCADE;

CREATE TABLE "order".orders (
    id UUID NOT NULL,
    customer_id UUID NOT NULL,
    restaurant_id UUID NOT NULL,
    tracking_id UUID NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    order_status type_order_status NOT NULL,
    failure_messages CHARACTER VARYING COLLATE pg_catalog."default",
    CONSTRAINT pk_orders PRIMARY KEY (id)
);

DROP TABLE IF EXISTS "order".order_items CASCADE;

CREATE TABLE "order".order_items (
    id UUID NOT NULL,
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    quantity INTEGER NOT NULL,
    sub_total NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_order_items_id_order_id PRIMARY KEY (id, order_id)
);

ALTER TABLE "order".order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id)
    REFERENCES "order".orders (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    NOT VALID;

DROP TABLE IF EXISTS "order".order_address CASCADE;

CREATE TABLE "order".order_address (
    id UUID NOT NULL,
    order_id UUID NOT NULL,
    street CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    postal_code CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    city CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_order_address_id_order_id PRIMARY KEY (id, order_id),
    CONSTRAINT uniq_order_address_order_id UNIQUE (order_id)
);

ALTER TABLE "order".order_address
    ADD CONSTRAINT fk_order_address_orders FOREIGN KEY (order_id)
    REFERENCES "order".orders (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    NOT VALID;

DROP TYPE IF EXISTS type_saga_status;
CREATE TYPE type_saga_status AS ENUM ('STARTED', 'FAILED', 'SUCCEEDED', 'PROCESSING', 'COMPENSATING', 'COMPENSATED');

DROP TYPE IF EXISTS type_outbox_status;
CREATE TYPE type_outbox_status AS ENUM ('STARTED', 'COMPLETED', 'FAILED');

DROP TABLE IF EXISTS "order".payment_outbox CASCADE;

CREATE TABLE "order".payment_outbox (
    id UUID NOT NULL,
    saga_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    processed_at TIMESTAMP WITH TIME ZONE,
    type CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    payload JSONB NOT NULL,
    outbox_status type_outbox_status NOT NULL,
    saga_status type_saga_status NOT NULL,
    order_status type_order_status NOT NULL,
    version INTEGER NOT NULL,
    CONSTRAINT pk_payment_outbox PRIMARY KEY (id)
);

CREATE INDEX "idx_payment_outbox_type_outbox_status_saga_status"
ON "order".payment_outbox
(type, outbox_status, saga_status);

--CREATE UNIQUE INDEX "uniq_payment_outbox_type_saga_id_saga_status"
--ON "order".payment_outbox
--(type, saga_id, saga_status);

DROP TABLE IF EXISTS "order".restaurant_approval_outbox CASCADE;

CREATE TABLE "order".restaurant_approval_outbox (
    id UUID NOT NULL,
    saga_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    processed_at TIMESTAMP WITH TIME ZONE,
    type CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    payload JSONB NOT NULL,
    outbox_status type_outbox_status NOT NULL,
    saga_status type_saga_status NOT NULL,
    order_status type_order_status NOT NULL,
    version INTEGER NOT NULL,
    CONSTRAINT pk_restaurant_approval_outbox PRIMARY KEY (id)
);

CREATE INDEX "idx_restaurant_approval_outbox_type_outbox_status_saga_status"
ON "order".restaurant_approval_outbox
(type, outbox_status, saga_status);

--CREATE UNIQUE INDEX "uniq_restaurant_approval_outbox_type_saga_id_saga_status"
--ON "order".restaurant_approval_outbox
--(type, saga_id, saga_status);

DROP TABLE IF EXISTS "order".customers CASCADE;

CREATE TABLE "order".customers (
    id UUID NOT NULL,
    username CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    first_name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    last_name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);