DROP SCHEMA IF EXISTS payment CASCADE;

CREATE SCHEMA payment;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TYPE IF EXISTS type_payment_status;
CREATE TYPE type_payment_status AS ENUM ('COMPLETED', 'CANCELLED', 'FAILED');

DROP TABLE IF EXISTS "payment".payments CASCADE;

CREATE TABLE "payment".payments (
    id UUID NOT NULL,
    customer_id UUID NOT NULL,
    order_id UUID NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    status type_payment_status NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (id)
);

DROP TABLE IF EXISTS "payment".credit_entry CASCADE;

CREATE TABLE "payment".credit_entry (
    id UUID NOT NULL,
    customer_id UUID NOT NULL,
    total_credit_amount NUMERIC(10,2) NOT NULL,
    version INTEGER NOT NULL,
    CONSTRAINT pk_credit_entry PRIMARY KEY (id)
);

DROP TYPE IF EXISTS type_transaction;
CREATE TYPE type_transaction AS ENUM ('DEBIT', 'CREDIT');

DROP TABLE IF EXISTS "payment".credit_history CASCADE;

CREATE TABLE "payment".credit_history (
    id UUID NOT NULL,
    customer_id UUID NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    type type_transaction NOT NULL,
    CONSTRAINT pk_credit_history PRIMARY KEY (id)
);

DROP TYPE IF EXISTS type_outbox_status;
CREATE TYPE type_outbox_status AS ENUM ('STARTED', 'COMPLETED', 'FAILED');

DROP TABLE IF EXISTS "payment".order_outbox CASCADE;

CREATE TABLE "payment".order_outbox (
    id UUID NOT NULL,
    saga_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    processed_at TIMESTAMP WITH TIME ZONE,
    type CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    payload JSONB NOT NULL,
    outbox_status type_outbox_status NOT NULL,
    payment_status type_payment_status NOT NULL,
    version INTEGER NOT NULL,
    CONSTRAINT pk_order_outbox PRIMARY KEY (id)
);

CREATE INDEX "idx_order_outbox_type_payment_status"
ON "payment".order_outbox
(type, payment_status);

CREATE UNIQUE INDEX "uniq_order_outbox_type_saga_id_payment_status_outbox_status"
ON "payment".order_outbox
(type, saga_id, payment_status, outbox_status);