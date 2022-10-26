SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: cart_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.cart_state AS ENUM (
    'picking',
    'pending',
    'paid',
    'failed'
);


--
-- Name: shipping_mode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shipping_mode AS ENUM (
    'no_shipping',
    'shipping',
    'click_and_collect'
);


--
-- Name: workshop_audience; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workshop_audience AS ENUM (
    'adult',
    'child',
    'adult_and_child'
);


--
-- Name: workshop_price_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workshop_price_category AS ENUM (
    'adult',
    'child',
    'adult_and_child',
    'reduced'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id uuid NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    street character varying,
    postal_code character varying,
    city character varying NOT NULL,
    addressable_id uuid NOT NULL,
    addressable_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    latitude numeric(10,6),
    longitude numeric(10,6)
);


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: billing_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billing_details (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone_number character varying NOT NULL,
    company character varying,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workshop_event_id uuid NOT NULL,
    seats integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT false NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    price_category public.workshop_price_category DEFAULT 'adult'::public.workshop_price_category NOT NULL,
    booked_by_admin boolean DEFAULT false NOT NULL,
    email character varying,
    first_name character varying,
    last_name character varying,
    phone_number character varying
);


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cartable_id uuid NOT NULL,
    cartable_type character varying NOT NULL,
    cart_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    paid_at timestamp without time zone,
    user_id uuid,
    state public.cart_state DEFAULT 'picking'::public.cart_state NOT NULL,
    transaction_id character varying,
    reference integer,
    shipping_mode public.shipping_mode DEFAULT 'no_shipping'::public.shipping_mode NOT NULL
);


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coupons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token character varying NOT NULL,
    couponable_id uuid NOT NULL,
    couponable_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active boolean DEFAULT false NOT NULL
);


--
-- Name: creator_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creator_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone_number character varying NOT NULL,
    workshop_category character varying NOT NULL,
    city character varying NOT NULL,
    website character varying NOT NULL,
    message text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: creator_docs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creator_docs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    creator_id uuid NOT NULL,
    statut character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    document_type character varying
);


--
-- Name: creators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creators (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone_number character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    website character varying,
    facebook character varying,
    instagram character varying,
    bio text,
    company character varying,
    click_and_collect boolean DEFAULT false NOT NULL,
    legal_statut character varying,
    tva boolean,
    tva_num character varying,
    siret character varying,
    approved boolean
);


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    amount_cents integer NOT NULL,
    voucher_id uuid NOT NULL,
    cart_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp without time zone,
    performed_at timestamp without time zone,
    finished_at timestamp without time zone,
    error text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: shipment_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_lines (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipment_id uuid NOT NULL,
    shippable_id uuid NOT NULL,
    shippable_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cart_id uuid NOT NULL,
    shipped boolean DEFAULT false NOT NULL,
    token character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    click_and_collect boolean DEFAULT false NOT NULL
);


--
-- Name: specific_workshop_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specific_workshop_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone_number character varying NOT NULL,
    workshop_category character varying NOT NULL,
    seats character varying NOT NULL,
    message text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    newsletter_member boolean DEFAULT false NOT NULL,
    birthday date NOT NULL,
    mangopay_id character varying,
    address_id uuid
);


--
-- Name: vouchers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vouchers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    amount_cents integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "from" character varying NOT NULL,
    "to" character varying NOT NULL,
    message text,
    workshop_id uuid,
    percentage boolean DEFAULT false NOT NULL,
    campaign boolean DEFAULT false NOT NULL,
    valid_until timestamp without time zone,
    minimum_amount_cents integer,
    max_uses integer,
    max_uses_by_user integer,
    user_id uuid,
    monoproduct boolean,
    notgiftcards boolean
);


--
-- Name: workshop_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    color character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: workshop_durations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_durations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hours integer NOT NULL,
    minutes integer NOT NULL,
    workshop_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: workshop_event_reminders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_event_reminders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    workshop_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: workshop_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    workshop_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    seats_left integer DEFAULT 0 NOT NULL,
    canceled_at timestamp without time zone,
    canceled boolean
);


--
-- Name: workshop_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshop_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying DEFAULT 'EUR'::character varying NOT NULL,
    workshop_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    category public.workshop_price_category DEFAULT 'adult'::public.workshop_price_category NOT NULL,
    seats integer DEFAULT 1 NOT NULL
);


--
-- Name: workshops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshops (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    goal text NOT NULL,
    description text NOT NULL,
    more text,
    audience public.workshop_audience NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    category_id uuid NOT NULL,
    seats integer NOT NULL,
    showcased boolean DEFAULT false NOT NULL,
    creator_id uuid,
    visible boolean DEFAULT false NOT NULL,
    giftable boolean DEFAULT true NOT NULL,
    hide_end_time boolean DEFAULT false NOT NULL,
    online boolean DEFAULT false NOT NULL,
    shipment boolean DEFAULT false NOT NULL,
    zone_id uuid,
    statut character varying DEFAULT 'Soumis'::character varying,
    crop_x character varying,
    crop_y character varying,
    crop_width character varying,
    crop_height character varying
);


--
-- Name: zones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: billing_details billing_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_details
    ADD CONSTRAINT billing_details_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: creator_contacts creator_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creator_contacts
    ADD CONSTRAINT creator_contacts_pkey PRIMARY KEY (id);


--
-- Name: creator_docs creator_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creator_docs
    ADD CONSTRAINT creator_docs_pkey PRIMARY KEY (id);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shipment_lines shipment_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_lines
    ADD CONSTRAINT shipment_lines_pkey PRIMARY KEY (id);


--
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- Name: specific_workshop_contacts specific_workshop_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specific_workshop_contacts
    ADD CONSTRAINT specific_workshop_contacts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (id);


--
-- Name: workshop_categories workshop_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_categories
    ADD CONSTRAINT workshop_categories_pkey PRIMARY KEY (id);


--
-- Name: workshop_durations workshop_durations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_durations
    ADD CONSTRAINT workshop_durations_pkey PRIMARY KEY (id);


--
-- Name: workshop_event_reminders workshop_event_reminders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_event_reminders
    ADD CONSTRAINT workshop_event_reminders_pkey PRIMARY KEY (id);


--
-- Name: workshop_events workshop_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_events
    ADD CONSTRAINT workshop_events_pkey PRIMARY KEY (id);


--
-- Name: workshop_prices workshop_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_prices
    ADD CONSTRAINT workshop_prices_pkey PRIMARY KEY (id);


--
-- Name: workshops workshops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops
    ADD CONSTRAINT workshops_pkey PRIMARY KEY (id);


--
-- Name: zones zones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_addresses_on_addressable_id_and_addressable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_addressable_id_and_addressable_type ON public.addresses USING btree (addressable_id, addressable_type);


--
-- Name: index_addresses_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_latitude_and_longitude ON public.addresses USING btree (latitude, longitude);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_billing_details_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_billing_details_on_user_id ON public.billing_details USING btree (user_id);


--
-- Name: index_bookings_on_workshop_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_workshop_event_id ON public.bookings USING btree (workshop_event_id);


--
-- Name: index_cart_items_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_cart_id ON public.cart_items USING btree (cart_id);


--
-- Name: index_cart_items_on_cart_id_and_cartable_id_and_cartable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cart_items_on_cart_id_and_cartable_id_and_cartable_type ON public.cart_items USING btree (cart_id, cartable_id, cartable_type);


--
-- Name: index_cart_items_on_cartable_id_and_cartable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_cartable_id_and_cartable_type ON public.cart_items USING btree (cartable_id, cartable_type);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_user_id ON public.carts USING btree (user_id);


--
-- Name: index_coupons_on_couponable_id_and_couponable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coupons_on_couponable_id_and_couponable_type ON public.coupons USING btree (couponable_id, couponable_type);


--
-- Name: index_coupons_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_coupons_on_token ON public.coupons USING btree (token);


--
-- Name: index_creator_docs_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creator_docs_on_creator_id ON public.creator_docs USING btree (creator_id);


--
-- Name: index_creators_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_creators_on_email ON public.creators USING btree (email);


--
-- Name: index_creators_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_creators_on_reset_password_token ON public.creators USING btree (reset_password_token);


--
-- Name: index_discounts_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discounts_on_cart_id ON public.discounts USING btree (cart_id);


--
-- Name: index_discounts_on_voucher_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discounts_on_voucher_id ON public.discounts USING btree (voucher_id);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_cron_key_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at ON public.good_jobs USING btree (cron_key, created_at);


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_shipment_lines_on_shipment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipment_lines_on_shipment_id ON public.shipment_lines USING btree (shipment_id);


--
-- Name: index_shipment_lines_on_shippable_id_and_shippable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipment_lines_on_shippable_id_and_shippable_type ON public.shipment_lines USING btree (shippable_id, shippable_type);


--
-- Name: index_shipments_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipments_on_cart_id ON public.shipments USING btree (cart_id);


--
-- Name: index_shipments_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_shipments_on_token ON public.shipments USING btree (token);


--
-- Name: index_users_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_address_id ON public.users USING btree (address_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_mangopay_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_mangopay_id ON public.users USING btree (mangopay_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_vouchers_on_amount_cents; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vouchers_on_amount_cents ON public.vouchers USING btree (amount_cents);


--
-- Name: index_vouchers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vouchers_on_user_id ON public.vouchers USING btree (user_id);


--
-- Name: index_vouchers_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vouchers_on_workshop_id ON public.vouchers USING btree (workshop_id);


--
-- Name: index_workshop_durations_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshop_durations_on_workshop_id ON public.workshop_durations USING btree (workshop_id);


--
-- Name: index_workshop_event_reminders_on_email_and_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_workshop_event_reminders_on_email_and_workshop_id ON public.workshop_event_reminders USING btree (email, workshop_id);


--
-- Name: index_workshop_event_reminders_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshop_event_reminders_on_workshop_id ON public.workshop_event_reminders USING btree (workshop_id);


--
-- Name: index_workshop_events_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshop_events_on_workshop_id ON public.workshop_events USING btree (workshop_id);


--
-- Name: index_workshop_prices_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshop_prices_on_workshop_id ON public.workshop_prices USING btree (workshop_id);


--
-- Name: index_workshops_on_audience; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshops_on_audience ON public.workshops USING btree (audience);


--
-- Name: index_workshops_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshops_on_category_id ON public.workshops USING btree (category_id);


--
-- Name: index_workshops_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshops_on_creator_id ON public.workshops USING btree (creator_id);


--
-- Name: index_workshops_on_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workshops_on_zone_id ON public.workshops USING btree (zone_id);


--
-- Name: workshop_durations fk_rails_3ef0dc2524; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_durations
    ADD CONSTRAINT fk_rails_3ef0dc2524 FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: vouchers fk_rails_43745b73bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT fk_rails_43745b73bf FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: creator_docs fk_rails_48dca414ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creator_docs
    ADD CONSTRAINT fk_rails_48dca414ff FOREIGN KEY (creator_id) REFERENCES public.creators(id);


--
-- Name: discounts fk_rails_639176d558; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT fk_rails_639176d558 FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: billing_details fk_rails_64f49a61ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billing_details
    ADD CONSTRAINT fk_rails_64f49a61ad FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: cart_items fk_rails_6cdb1f0139; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_6cdb1f0139 FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: workshops fk_rails_7c7e90f444; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops
    ADD CONSTRAINT fk_rails_7c7e90f444 FOREIGN KEY (category_id) REFERENCES public.workshop_categories(id);


--
-- Name: workshops fk_rails_9e5763e889; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops
    ADD CONSTRAINT fk_rails_9e5763e889 FOREIGN KEY (creator_id) REFERENCES public.creators(id);


--
-- Name: workshop_events fk_rails_a9b249ffc3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_events
    ADD CONSTRAINT fk_rails_a9b249ffc3 FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: shipment_lines fk_rails_cd6f139686; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_lines
    ADD CONSTRAINT fk_rails_cd6f139686 FOREIGN KEY (shipment_id) REFERENCES public.shipments(id);


--
-- Name: bookings fk_rails_cd8dd8f389; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_cd8dd8f389 FOREIGN KEY (workshop_event_id) REFERENCES public.workshop_events(id);


--
-- Name: workshop_prices fk_rails_d51aee28dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_prices
    ADD CONSTRAINT fk_rails_d51aee28dd FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: discounts fk_rails_f07bda2813; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT fk_rails_f07bda2813 FOREIGN KEY (voucher_id) REFERENCES public.vouchers(id);


--
-- Name: workshop_event_reminders fk_rails_f881288800; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshop_event_reminders
    ADD CONSTRAINT fk_rails_f881288800 FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200827131926'),
('20200827132627'),
('20200827132900'),
('20200827150030'),
('20200827151326'),
('20200827151427'),
('20200827152700'),
('20200827152804'),
('20200827160756'),
('20200827160934'),
('20200827162815'),
('20200827163054'),
('20200828112140'),
('20200828114029'),
('20200828114203'),
('20200828123652'),
('20200828153237'),
('20201002063646'),
('20201002063743'),
('20201006145010'),
('20201008152405'),
('20201008152410'),
('20201017111744'),
('20201017112821'),
('20201029192529'),
('20201031162206'),
('20201031165359'),
('20201031170410'),
('20201031170628'),
('20201103163037'),
('20201103163600'),
('20201104163022'),
('20201104163146'),
('20201110142123'),
('20201112144139'),
('20201112154744'),
('20201115200003'),
('20201115200046'),
('20201115200201'),
('20201118083524'),
('20201118121217'),
('20201118123534'),
('20201118142833'),
('20201120080727'),
('20201120080811'),
('20201120080851'),
('20201120090313'),
('20201120155721'),
('20201120201721'),
('20201120210829'),
('20201122223059'),
('20201122223614'),
('20201123095123'),
('20201123194558'),
('20201124120948'),
('20201124121405'),
('20201124121545'),
('20201124144051'),
('20201125161117'),
('20201130081932'),
('20201201132349'),
('20201207161332'),
('20201210090423'),
('20210115133011'),
('20210115154810'),
('20210115155324'),
('20210122154014'),
('20210125100100'),
('20210125101932'),
('20210125105314'),
('20210125135653'),
('20210125135824'),
('20210225145009'),
('20210225145412'),
('20210226102407'),
('20210304090425'),
('20210304090456'),
('20210401071026'),
('20210528135646'),
('20210616225220'),
('20210623011147'),
('20210623120706'),
('20210818154845'),
('20210820163049'),
('20210820163050'),
('20210826152200'),
('20210826160238'),
('20210829231732'),
('20210915225214'),
('20211105232930'),
('20211126125138'),
('20220127194223'),
('20220127194832');
('20220128075245');


