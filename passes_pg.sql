--
-- PostgreSQL database dump
--

\restrict V2jdgwmDJrdoaJFryXLpM651ekSmvPuYkcr4pi1oMGHV7ujLgxy72Rbf25RivfC

-- Dumped from database version 17.8 (Postgres.app)
-- Dumped by pg_dump version 17.8 (Postgres.app)

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
-- Name: access_point; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.access_point (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    building integer NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.access_point OWNER TO etterellar;

--
-- Name: access_point_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.access_point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.access_point_id_seq OWNER TO etterellar;

--
-- Name: access_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.access_point_id_seq OWNED BY public.access_point.id;


--
-- Name: department; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.department OWNER TO etterellar;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_id_seq OWNER TO etterellar;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- Name: pass; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.pass (
    id integer NOT NULL,
    visitor_id integer NOT NULL,
    qr_code character varying(20) NOT NULL,
    max_entries integer DEFAULT 1 NOT NULL,
    host_id integer NOT NULL,
    purpose character varying(200) NOT NULL,
    valid_from timestamp without time zone NOT NULL,
    valid_to timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    CONSTRAINT pass_max_entries_check CHECK ((max_entries > 0))
);


ALTER TABLE public.pass OWNER TO etterellar;

--
-- Name: pass_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.pass_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pass_id_seq OWNER TO etterellar;

--
-- Name: pass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.pass_id_seq OWNED BY public.pass.id;


--
-- Name: scan; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.scan (
    id integer NOT NULL,
    pass_id integer NOT NULL,
    access_point_id integer NOT NULL,
    direction character varying(10) NOT NULL,
    result character varying(10) NOT NULL,
    deny_reason character varying(20),
    scanned_at timestamp without time zone NOT NULL,
    synced_at timestamp without time zone,
    CONSTRAINT scan_check CHECK (((((result)::text = 'denied'::text) AND (deny_reason IS NOT NULL)) OR (((result)::text = 'allowed'::text) AND (deny_reason IS NULL)))),
    CONSTRAINT scan_direction_check CHECK (((direction)::text = ANY ((ARRAY['entry'::character varying, 'exit'::character varying])::text[]))),
    CONSTRAINT scan_result_check CHECK (((result)::text = ANY ((ARRAY['allowed'::character varying, 'denied'::character varying])::text[])))
);


ALTER TABLE public.scan OWNER TO etterellar;

--
-- Name: scan_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.scan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scan_id_seq OWNER TO etterellar;

--
-- Name: scan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.scan_id_seq OWNED BY public.scan.id;


--
-- Name: staff; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.staff (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    department_id integer NOT NULL,
    role character varying(20) NOT NULL,
    CONSTRAINT staff_role_check CHECK (((role)::text = ANY ((ARRAY['staff'::character varying, 'security'::character varying])::text[])))
);


ALTER TABLE public.staff OWNER TO etterellar;

--
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_id_seq OWNER TO etterellar;

--
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- Name: visit; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.visit (
    id integer NOT NULL,
    pass_id integer NOT NULL,
    entry_point_id integer NOT NULL,
    exit_point_id integer,
    checked_in_at timestamp without time zone NOT NULL,
    checked_out_at timestamp without time zone,
    CONSTRAINT visit_check CHECK (((checked_out_at IS NULL) OR (checked_out_at >= checked_in_at)))
);


ALTER TABLE public.visit OWNER TO etterellar;

--
-- Name: visit_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.visit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visit_id_seq OWNER TO etterellar;

--
-- Name: visit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.visit_id_seq OWNED BY public.visit.id;


--
-- Name: visitor; Type: TABLE; Schema: public; Owner: etterellar
--

CREATE TABLE public.visitor (
    id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    phone character varying(20),
    category integer NOT NULL,
    organization character varying(150)
);


ALTER TABLE public.visitor OWNER TO etterellar;

--
-- Name: visitor_id_seq; Type: SEQUENCE; Schema: public; Owner: etterellar
--

CREATE SEQUENCE public.visitor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visitor_id_seq OWNER TO etterellar;

--
-- Name: visitor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: etterellar
--

ALTER SEQUENCE public.visitor_id_seq OWNED BY public.visitor.id;


--
-- Name: access_point id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.access_point ALTER COLUMN id SET DEFAULT nextval('public.access_point_id_seq'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- Name: pass id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.pass ALTER COLUMN id SET DEFAULT nextval('public.pass_id_seq'::regclass);


--
-- Name: scan id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.scan ALTER COLUMN id SET DEFAULT nextval('public.scan_id_seq'::regclass);


--
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- Name: visit id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visit ALTER COLUMN id SET DEFAULT nextval('public.visit_id_seq'::regclass);


--
-- Name: visitor id; Type: DEFAULT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visitor ALTER COLUMN id SET DEFAULT nextval('public.visitor_id_seq'::regclass);


--
-- Data for Name: access_point; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.access_point (id, name, building, active) FROM stdin;
1	Турникет главного входа	1	t
2	Турникет корпуса Б	2	t
3	Служебный вход	1	t
4	Проходная общежития	3	t
5	Турникет корпуса В	4	f
6	Въездные ворота	1	t
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.department (id, name) FROM stdin;
1	Приёмная комиссия
2	Кафедра информатики
3	Служба безопасности
4	Научный отдел
5	Административно-хозяйственный отдел
6	Учебный отдел
\.


--
-- Data for Name: pass; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.pass (id, visitor_id, qr_code, max_entries, host_id, purpose, valid_from, valid_to, revoked_at) FROM stdin;
1	1	PASS-004173	1	1	Собеседование в приёмной комиссии	2026-08-10 09:00:00	2026-08-10 18:00:00	\N
2	1	PASS-004201	5	3	Участие в семинаре по базам данных	2026-08-12 08:00:00	2026-08-14 20:00:00	\N
3	2	PASS-004215	2	2	Подача документов	2026-08-11 09:00:00	2026-08-11 17:00:00	\N
4	3	PASS-004230	10	9	Обслуживание серверного оборудования	2026-08-01 08:00:00	2026-08-31 20:00:00	\N
5	4	PASS-004244	1	10	Переговоры по договору	2026-08-12 10:00:00	2026-08-12 15:00:00	2026-08-12 11:30:00
6	5	PASS-004258	3	4	Работа в читальном зале	2026-08-13 09:00:00	2026-08-13 21:00:00	\N
7	6	PASS-004260	1	12	Оформление документов	2026-08-09 09:00:00	2026-08-09 13:00:00	\N
8	7	PASS-004277	15	9	Монтаж вентиляции в корпусе Б	2026-07-20 07:00:00	2026-08-20 20:00:00	2026-08-05 18:00:00
9	8	PASS-004289	2	2	Экскурсия по университету	2026-08-13 10:00:00	2026-08-13 16:00:00	\N
10	9	PASS-004291	1	12	Встреча с научным руководителем	2026-08-14 09:00:00	2026-08-14 18:00:00	\N
11	2	PASS-004302	4	4	Участие в конференции	2026-08-13 08:00:00	2026-08-15 20:00:00	\N
12	5	PASS-004310	1	3	Консультация по учебному плану	2026-08-06 10:00:00	2026-08-06 14:00:00	2026-08-06 09:00:00
13	3	PASS-004321	2	10	Диагностика сетевого оборудования	2026-08-13 09:00:00	2026-08-13 19:00:00	\N
14	6	PASS-004333	1	1	Сдача отчётности	2026-07-28 09:00:00	2026-07-28 18:00:00	2026-08-28 18:00:00
\.


--
-- Data for Name: scan; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.scan (id, pass_id, access_point_id, direction, result, deny_reason, scanned_at, synced_at) FROM stdin;
1	1	1	entry	allowed	\N	2026-08-10 09:15:00	2026-08-10 09:16:00
2	1	1	exit	allowed	\N	2026-08-10 12:40:00	2026-08-10 12:41:00
3	1	3	exit	allowed	\N	2026-08-10 17:50:00	2026-08-10 17:52:00
4	2	2	entry	allowed	\N	2026-08-13 09:05:00	\N
5	3	2	exit	allowed	\N	2026-08-11 16:30:00	2026-08-11 16:35:00
6	4	3	entry	allowed	\N	2026-08-13 08:20:00	2026-08-13 08:22:00
7	5	1	entry	allowed	\N	2026-08-12 10:20:00	2026-08-12 10:22:00
8	5	1	entry	denied	revoked	2026-08-12 14:05:00	2026-08-12 14:10:00
9	5	2	entry	denied	revoked	2026-08-12 16:20:00	\N
10	8	6	entry	denied	revoked	2026-08-06 08:05:00	2026-08-06 08:10:00
11	8	6	entry	denied	revoked	2026-08-07 07:55:00	2026-08-07 08:00:00
12	8	1	entry	denied	revoked	2026-08-08 09:10:00	2026-08-08 09:12:00
13	12	1	entry	denied	revoked	2026-08-06 10:05:00	2026-08-06 10:07:00
14	10	1	entry	denied	not_started	2026-08-13 11:30:00	2026-08-13 11:32:00
15	14	1	entry	denied	expired	2026-07-29 09:40:00	2026-07-29 09:45:00
\.


--
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.staff (id, name, email, department_id, role) FROM stdin;
1	Петров Пётр Сергеевич	petrov@mephi.ru	1	staff
2	Сидорова Анна Викторовна	sidorova@mephi.ru	1	staff
3	Кузнецов Дмитрий Олегович	kuznetsov@mephi.ru	2	staff
4	Морозова Елена Ивановна	morozova@mephi.ru	2	staff
5	Волков Игорь Анатольевич	volkov@mephi.ru	2	staff
6	Никитин Сергей Павлович	nikitin@mephi.ru	3	security
7	Егорова Ольга Дмитриевна	egorova@mephi.ru	3	security
8	Тарасов Артём Юрьевич	tarasov@mephi.ru	3	security
9	Лебедев Максим Андреевич	lebedev@mephi.ru	4	staff
10	Соколова Мария Алексеевна	sokolova@mephi.ru	4	staff
11	Фёдоров Роман Витальевич	fedorov@mephi.ru	5	staff
12	Зайцева Наталья Борисовна	zaytseva@mephi.ru	6	staff
\.


--
-- Data for Name: visit; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.visit (id, pass_id, entry_point_id, exit_point_id, checked_in_at, checked_out_at) FROM stdin;
1	1	1	1	2026-08-10 09:15:00	2026-08-10 12:40:00
2	1	1	3	2026-08-10 13:30:00	2026-08-10 17:50:00
3	2	1	2	2026-08-12 08:40:00	2026-08-12 18:05:00
4	2	2	\N	2026-08-13 09:05:00	\N
5	3	1	1	2026-08-11 09:30:00	2026-08-11 11:00:00
6	3	1	1	2026-08-11 12:10:00	2026-08-11 13:45:00
7	3	2	2	2026-08-11 14:20:00	2026-08-11 16:30:00
8	4	3	3	2026-08-05 08:10:00	2026-08-05 19:00:00
9	4	3	\N	2026-08-13 08:20:00	\N
10	5	1	1	2026-08-12 10:20:00	2026-08-12 11:15:00
11	6	1	\N	2026-08-13 09:40:00	\N
12	7	1	1	2026-08-09 09:20:00	2026-08-09 12:30:00
13	8	6	6	2026-07-21 07:50:00	2026-07-21 17:10:00
14	9	1	\N	2026-08-13 10:10:00	\N
15	11	2	\N	2026-08-13 08:50:00	\N
\.


--
-- Data for Name: visitor; Type: TABLE DATA; Schema: public; Owner: etterellar
--

COPY public.visitor (id, full_name, phone, category, organization) FROM stdin;
1	Иванов Иван Иванович	+79991234567	1	\N
2	Смирнова Ольга Петровна	+79161112233	1	\N
3	Кузьмин Алексей Сергеевич	+79031234455	3	ООО «ТехноСервис»
4	Гаврилова Ирина Николаевна	+79269876543	4	\N
5	Белов Никита Артёмович	+79104445566	1	\N
6	Романова Дарья Игоревна	\N	2	\N
7	Ковалёв Станислав Юрьевич	+79052223344	3	АО «СтройМонтаж»
8	Ершова Валентина Ильинична	+79093334455	1	\N
9	Панфилов Юрий Олегович	+79771231212	4	\N
10	Дроздов Максим Валерьевич	+79217654321	1	\N
11	Соловьёва Кристина Андреевна	+79119998877	1	\N
12	Абрамов Илья Дмитриевич	\N	3	ИП Абрамов И.Д.
\.


--
-- Name: access_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.access_point_id_seq', 6, true);


--
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.department_id_seq', 6, true);


--
-- Name: pass_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.pass_id_seq', 14, true);


--
-- Name: scan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.scan_id_seq', 15, true);


--
-- Name: staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.staff_id_seq', 12, true);


--
-- Name: visit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.visit_id_seq', 15, true);


--
-- Name: visitor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: etterellar
--

SELECT pg_catalog.setval('public.visitor_id_seq', 12, true);


--
-- Name: access_point access_point_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.access_point
    ADD CONSTRAINT access_point_pkey PRIMARY KEY (id);


--
-- Name: department department_name_key; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_name_key UNIQUE (name);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: pass pass_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.pass
    ADD CONSTRAINT pass_pkey PRIMARY KEY (id);


--
-- Name: pass pass_qr_code_key; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.pass
    ADD CONSTRAINT pass_qr_code_key UNIQUE (qr_code);


--
-- Name: scan scan_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.scan
    ADD CONSTRAINT scan_pkey PRIMARY KEY (id);


--
-- Name: staff staff_email_key; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key UNIQUE (email);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- Name: visit visit_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_pkey PRIMARY KEY (id);


--
-- Name: visitor visitor_pkey; Type: CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visitor
    ADD CONSTRAINT visitor_pkey PRIMARY KEY (id);


--
-- Name: pass pass_host_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.pass
    ADD CONSTRAINT pass_host_id_fkey FOREIGN KEY (host_id) REFERENCES public.staff(id);


--
-- Name: pass pass_visitor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.pass
    ADD CONSTRAINT pass_visitor_id_fkey FOREIGN KEY (visitor_id) REFERENCES public.visitor(id);


--
-- Name: scan scan_access_point_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.scan
    ADD CONSTRAINT scan_access_point_id_fkey FOREIGN KEY (access_point_id) REFERENCES public.access_point(id);


--
-- Name: scan scan_pass_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.scan
    ADD CONSTRAINT scan_pass_id_fkey FOREIGN KEY (pass_id) REFERENCES public.pass(id);


--
-- Name: staff staff_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.department(id);


--
-- Name: visit visit_entry_point_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_entry_point_id_fkey FOREIGN KEY (entry_point_id) REFERENCES public.access_point(id);


--
-- Name: visit visit_exit_point_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_exit_point_id_fkey FOREIGN KEY (exit_point_id) REFERENCES public.access_point(id);


--
-- Name: visit visit_pass_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: etterellar
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT visit_pass_id_fkey FOREIGN KEY (pass_id) REFERENCES public.pass(id);


--
-- PostgreSQL database dump complete
--

\unrestrict V2jdgwmDJrdoaJFryXLpM651ekSmvPuYkcr4pi1oMGHV7ujLgxy72Rbf25RivfC

