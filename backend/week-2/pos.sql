--
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE pos;
--
-- Name: pos; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE pos WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';


ALTER DATABASE pos OWNER TO postgres;

\connect pos

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    c_id integer NOT NULL,
    c_name character varying(100) NOT NULL,
    c_email character varying(255) NOT NULL,
    c_contact character varying(15),
    CONSTRAINT valid_contact_format CHECK (((c_contact)::text ~* '^\d{10}$'::text)),
    CONSTRAINT valid_email_format CHECK (((c_email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_c_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_c_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_c_id_seq OWNER TO postgres;

--
-- Name: customer_c_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_c_id_seq OWNED BY public.customer.c_id;


--
-- Name: inventoryitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventoryitem (
    item_sku integer NOT NULL,
    item_name character varying(100) NOT NULL,
    item_description text,
    item_price numeric NOT NULL,
    item_qty integer NOT NULL,
    CONSTRAINT inventoryitem_item_price_check CHECK ((item_price >= (0)::numeric)),
    CONSTRAINT inventoryitem_item_qty_check CHECK ((item_qty >= 0))
);


ALTER TABLE public.inventoryitem OWNER TO postgres;

--
-- Name: inventoryitem_item_sku_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventoryitem_item_sku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventoryitem_item_sku_seq OWNER TO postgres;

--
-- Name: inventoryitem_item_sku_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventoryitem_item_sku_seq OWNED BY public.inventoryitem.item_sku;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    s_id integer NOT NULL,
    s_name character varying(100) NOT NULL,
    s_email character varying(255) NOT NULL,
    s_isadmin boolean DEFAULT false,
    s_contact character varying(15),
    CONSTRAINT valid_contact_format CHECK (((s_contact)::text ~* '^\d{10}$'::text)),
    CONSTRAINT valid_email_format CHECK (((s_email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- Name: staff_s_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_s_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_s_id_seq OWNER TO postgres;

--
-- Name: staff_s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_s_id_seq OWNED BY public.staff.s_id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    t_id integer NOT NULL,
    c_id integer NOT NULL,
    s_id integer NOT NULL,
    t_date date NOT NULL,
    t_amount numeric NOT NULL,
    t_category character varying(50),
    CONSTRAINT transaction_t_amount_check CHECK ((t_amount >= (0)::numeric))
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_items (
    t_id integer NOT NULL,
    item_sku integer NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT transaction_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.transaction_items OWNER TO postgres;

--
-- Name: transaction_t_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_t_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_t_id_seq OWNER TO postgres;

--
-- Name: transaction_t_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_t_id_seq OWNED BY public.transaction.t_id;


--
-- Name: customer c_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN c_id SET DEFAULT nextval('public.customer_c_id_seq'::regclass);


--
-- Name: inventoryitem item_sku; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventoryitem ALTER COLUMN item_sku SET DEFAULT nextval('public.inventoryitem_item_sku_seq'::regclass);


--
-- Name: staff s_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN s_id SET DEFAULT nextval('public.staff_s_id_seq'::regclass);


--
-- Name: transaction t_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN t_id SET DEFAULT nextval('public.transaction_t_id_seq'::regclass);


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (c_id, c_name, c_email, c_contact) FROM stdin;
\.
COPY public.customer (c_id, c_name, c_email, c_contact) FROM '$$PATH$$/4891.dat';

--
-- Data for Name: inventoryitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventoryitem (item_sku, item_name, item_description, item_price, item_qty) FROM stdin;
\.
COPY public.inventoryitem (item_sku, item_name, item_description, item_price, item_qty) FROM '$$PATH$$/4893.dat';

--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff (s_id, s_name, s_email, s_isadmin, s_contact) FROM stdin;
\.
COPY public.staff (s_id, s_name, s_email, s_isadmin, s_contact) FROM '$$PATH$$/4895.dat';

--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (t_id, c_id, s_id, t_date, t_amount, t_category) FROM stdin;
\.
COPY public.transaction (t_id, c_id, s_id, t_date, t_amount, t_category) FROM '$$PATH$$/4897.dat';

--
-- Data for Name: transaction_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction_items (t_id, item_sku, quantity) FROM stdin;
\.
COPY public.transaction_items (t_id, item_sku, quantity) FROM '$$PATH$$/4898.dat';

--
-- Name: customer_c_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_c_id_seq', 4, true);


--
-- Name: inventoryitem_item_sku_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventoryitem_item_sku_seq', 6, true);


--
-- Name: staff_s_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_s_id_seq', 4, true);


--
-- Name: transaction_t_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_t_id_seq', 4, true);


--
-- Name: customer customer_c_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_c_email_key UNIQUE (c_email);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (c_id);


--
-- Name: inventoryitem inventoryitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventoryitem
    ADD CONSTRAINT inventoryitem_pkey PRIMARY KEY (item_sku);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (s_id);


--
-- Name: staff staff_s_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_s_email_key UNIQUE (s_email);


--
-- Name: transaction_items transaction_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_pkey PRIMARY KEY (t_id, item_sku);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (t_id);


--
-- Name: transaction transaction_c_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_c_id_fkey FOREIGN KEY (c_id) REFERENCES public.customer(c_id);


--
-- Name: transaction_items transaction_items_item_sku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_item_sku_fkey FOREIGN KEY (item_sku) REFERENCES public.inventoryitem(item_sku) ON DELETE CASCADE;


--
-- Name: transaction_items transaction_items_t_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_items
    ADD CONSTRAINT transaction_items_t_id_fkey FOREIGN KEY (t_id) REFERENCES public.transaction(t_id) ON DELETE CASCADE;


--
-- Name: transaction transaction_s_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_s_id_fkey FOREIGN KEY (s_id) REFERENCES public.staff(s_id);


--
-- Name: DATABASE pos; Type: ACL; Schema: -; Owner: postgres
--

GRANT CONNECT ON DATABASE pos TO admin;
GRANT CONNECT ON DATABASE pos TO staff;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO staff;


--
-- Name: TABLE customer; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer TO admin;
GRANT SELECT ON TABLE public.customer TO staff;


--
-- Name: TABLE inventoryitem; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.inventoryitem TO admin;
GRANT SELECT ON TABLE public.inventoryitem TO staff;


--
-- Name: TABLE staff; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.staff TO admin;
GRANT SELECT ON TABLE public.staff TO staff;


--
-- Name: TABLE transaction; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.transaction TO admin;
GRANT SELECT ON TABLE public.transaction TO staff;


--
-- Name: TABLE transaction_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.transaction_items TO admin;
GRANT SELECT ON TABLE public.transaction_items TO staff;


--
-- PostgreSQL database dump complete
--

