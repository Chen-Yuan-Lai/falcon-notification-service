--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)

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

DROP DATABASE personal_project_test;
--
-- Name: personal_project_test; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE personal_project_test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';


\connect personal_project_test

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
-- Name: action_interval; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.action_interval AS ENUM (
    '1m',
    '5m',
    '10m',
    '30m',
    '1hr',
    '3hr',
    '24hr',
    '1w'
);


--
-- Name: alert_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.alert_status AS ENUM (
    'pending',
    'firing'
);


--
-- Name: eft; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.eft AS ENUM (
    'allow',
    'deny'
);


--
-- Name: event_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.event_status AS ENUM (
    'unhandled',
    'handled'
);


--
-- Name: filter; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.filter AS ENUM (
    'any',
    'all',
    'none'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert_histories (
    id integer NOT NULL,
    rule_id bigint NOT NULL,
    trigger_time timestamp with time zone DEFAULT now(),
    delete boolean DEFAULT false
);


--
-- Name: alert_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_histories_id_seq OWNED BY public.alert_histories.id;


--
-- Name: alert_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert_rules (
    id integer NOT NULL,
    project_id bigint NOT NULL,
    filter public.filter NOT NULL,
    action_interval public.action_interval NOT NULL,
    name character varying(127) NOT NULL,
    active boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: alert_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_tables_id_seq OWNED BY public.alert_rules.id;


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.channels (
    id integer NOT NULL,
    rule_id bigint NOT NULL,
    user_id bigint NOT NULL,
    type character varying(10) NOT NULL,
    token character varying(127) NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.channels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;


--
-- Name: code_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.code_blocks (
    id integer NOT NULL,
    event_id bigint NOT NULL,
    block text,
    error_line character varying(127),
    error_column_num integer NOT NULL,
    error_line_num integer NOT NULL,
    file_name character varying(255) NOT NULL,
    stack character varying(255) NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: code_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.code_blocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: code_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.code_blocks_id_seq OWNED BY public.code_blocks.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    name character varying(127) NOT NULL,
    status public.event_status DEFAULT 'unhandled'::public.event_status,
    stack text NOT NULL,
    message text NOT NULL,
    os_type character varying(20) NOT NULL,
    os_release character varying(50) NOT NULL,
    architecture character varying(20) NOT NULL,
    version character varying(10) NOT NULL,
    mem_rss integer NOT NULL,
    mem_heap_total integer NOT NULL,
    mem_heap_used integer NOT NULL,
    mem_external integer NOT NULL,
    mem_array_buffers integer NOT NULL,
    up_time numeric(20,0) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    fingerprints character varying(127) NOT NULL,
    work_space_path character varying(255) NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policies (
    id integer NOT NULL,
    sub character varying(50) NOT NULL,
    obj character varying(50) NOT NULL,
    act character varying(50) NOT NULL,
    eft public.eft DEFAULT 'allow'::public.eft NOT NULL
);


--
-- Name: policies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.policies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.policies_id_seq OWNED BY public.policies.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    framework character varying(50) NOT NULL,
    client_token character varying(255) NOT NULL,
    user_id bigint NOT NULL,
    members bigint[],
    delete boolean DEFAULT false,
    name character varying(50) NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: request_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_info (
    id integer NOT NULL,
    url character varying(127) NOT NULL,
    method character varying NOT NULL,
    host character varying NOT NULL,
    useragent text NOT NULL,
    accept text NOT NULL,
    query_paras json,
    event_id bigint NOT NULL,
    ip character varying(20),
    delete boolean DEFAULT false
);


--
-- Name: request_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.request_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.request_info_id_seq OWNED BY public.request_info.id;


--
-- Name: source_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.source_maps (
    id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    project_id bigint NOT NULL,
    version integer NOT NULL,
    hash_value character varying(255) NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: source_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.source_maps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.source_maps_id_seq OWNED BY public.source_maps.id;


--
-- Name: trigger_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trigger_types (
    id integer NOT NULL,
    description character varying(255) NOT NULL
);


--
-- Name: triggers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.triggers (
    trigger_type_id bigint NOT NULL,
    rule_id bigint NOT NULL,
    threshold character varying(10),
    time_window public.action_interval,
    id integer NOT NULL,
    delete boolean DEFAULT false
);


--
-- Name: triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.triggers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.triggers_id_seq OWNED BY public.trigger_types.id;


--
-- Name: triggers_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.triggers_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: triggers_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.triggers_id_seq1 OWNED BY public.triggers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    second_name character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    user_key character varying(255) NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: alert_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_histories ALTER COLUMN id SET DEFAULT nextval('public.alert_histories_id_seq'::regclass);


--
-- Name: alert_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rules ALTER COLUMN id SET DEFAULT nextval('public.alert_tables_id_seq'::regclass);


--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);


--
-- Name: code_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_blocks ALTER COLUMN id SET DEFAULT nextval('public.code_blocks_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: policies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies ALTER COLUMN id SET DEFAULT nextval('public.policies_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: request_info id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_info ALTER COLUMN id SET DEFAULT nextval('public.request_info_id_seq'::regclass);


--
-- Name: source_maps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_maps ALTER COLUMN id SET DEFAULT nextval('public.source_maps_id_seq'::regclass);


--
-- Name: trigger_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trigger_types ALTER COLUMN id SET DEFAULT nextval('public.triggers_id_seq'::regclass);


--
-- Name: triggers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.triggers ALTER COLUMN id SET DEFAULT nextval('public.triggers_id_seq1'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alert_histories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alert_histories (id, rule_id, trigger_time, delete) FROM stdin;
\.


--
-- Data for Name: alert_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alert_rules (id, project_id, filter, action_interval, name, active, created_at, delete) FROM stdin;
1	1	all	1m	hallo	t	2023-12-09 14:01:40.657165+08	t
2	3	any	1m	Demo alert	t	2023-12-13 18:01:20.962533+08	t
3	7	any	1m	Demo	t	2023-12-14 01:05:14.52916+08	t
6	7	any	1m	j;jl;i	t	2023-12-14 13:52:44.103595+08	f
7	7	any	1m	j;jl;ihfgh	t	2023-12-14 13:55:13.70346+08	f
8	7	any	1m	ij;ljbk	t	2023-12-14 13:58:09.994839+08	f
9	7	any	1m	ij;ljbk	t	2023-12-14 13:58:42.747707+08	f
\.


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.channels (id, rule_id, user_id, type, token, delete) FROM stdin;
1	1	1	line	9Idjs8pouWobptIvBmMYzgSF0xEH2iea6VByh7mCrbu	t
2	2	2	line	9Idjs8pouWobptIvBmMYzgSF0xEH2iea6VByh7mCrbu	t
3	3	3	line	9Idjs8pouWobptIvBmMYzgSF0xEH2iea6VByh7mCrbu	t
4	6	3	line	453245	f
5	7	3	line	453245	f
6	8	3	line	453785	f
7	9	3	line	453785	f
\.


--
-- Data for Name: code_blocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.code_blocks (id, event_id, block, error_line, error_column_num, error_line_num, file_name, stack, delete) FROM stdin;
1	30	\napp.use(cors());\n\napp.use(er.requestHandler());\napp.get('/programError', async (req, res, next) => {\n  try {\n    console.log('Hi');\n    throw new Error('This is the error!');\n  } catch (e) {\n    // er.captureError(e);\n    next(e);\n  }\n});\n\napp.get('/typeError', async (req, res, next) => {	throw new Error('This is the error!');	11	44	app.js	/app.js:44:11	f
2	30	    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }\n\n      sync = 0\n    });\n  }	layer.handle_request(req, res, next)	15	284	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:284:15	f
3	30	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
4	30	    }\n\n    if (layer.method && layer.method !== method) {\n      next(err)\n    } else if (err) {\n      layer.handle_error(err, req, res, next);\n    } else {\n      layer.handle_request(req, res, next);\n    }\n\n    sync = 0\n  }\n};\n\n/**	layer.handle_request(req, res, next);	13	144	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:144:13	f
5	30	  var method = req.method.toLowerCase();\n  if (method === 'head' && !this.methods['head']) {\n    method = 'get';\n  }\n\n  req.route = this;\n\n  next();\n\n  function next(err) {\n    // signal to exit route\n    if (err && err === 'route') {\n      return done();\n    }\n	next();	3	114	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:114:3	f
6	30	    // Capture one-time layer values\n    req.params = self.mergeParams\n      ? mergeParams(layer.params, parentParams)\n      : layer.params;\n    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }	self.process_params(layer, paramcalled, req, res, function (err) {	10	280	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:280:10	f
7	30	  var params = this.params;\n\n  // captured parameters from the layer, keys and values\n  var keys = layer.keys;\n\n  // fast track\n  if (!keys || keys.length === 0) {\n    return done();\n  }\n\n  var i = 0;\n  var name;\n  var paramIndex = 0;\n  var key;\n  var paramVal;	return done();	12	346	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:346:12	f
8	30	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
9	30	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
10	30	\N	\N	7	136	home/ian/appWorkSchool/personal-project/sdk/index.js	/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7	f
11	31	\napp.use(cors());\n\napp.use(er.requestHandler());\napp.get('/programError', async (req, res, next) => {\n  try {\n    console.log('Hi');\n    throw new Error('This is the error!');\n  } catch (e) {\n    // er.captureError(e);\n    next(e);\n  }\n});\n\napp.get('/typeError', async (req, res, next) => {	throw new Error('This is the error!');	11	44	app.js	/app.js:44:11	f
12	31	  var params = this.params;\n\n  // captured parameters from the layer, keys and values\n  var keys = layer.keys;\n\n  // fast track\n  if (!keys || keys.length === 0) {\n    return done();\n  }\n\n  var i = 0;\n  var name;\n  var paramIndex = 0;\n  var key;\n  var paramVal;	return done();	12	346	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:346:12	f
13	31	  var method = req.method.toLowerCase();\n  if (method === 'head' && !this.methods['head']) {\n    method = 'get';\n  }\n\n  req.route = this;\n\n  next();\n\n  function next(err) {\n    // signal to exit route\n    if (err && err === 'route') {\n      return done();\n    }\n	next();	3	114	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:114:3	f
14	31	\N	\N	7	136	home/ian/appWorkSchool/personal-project/sdk/index.js	/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7	f
15	31	    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }\n\n      sync = 0\n    });\n  }	layer.handle_request(req, res, next)	15	284	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:284:15	f
16	31	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
17	31	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
18	31	    }\n\n    if (layer.method && layer.method !== method) {\n      next(err)\n    } else if (err) {\n      layer.handle_error(err, req, res, next);\n    } else {\n      layer.handle_request(req, res, next);\n    }\n\n    sync = 0\n  }\n};\n\n/**	layer.handle_request(req, res, next);	13	144	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:144:13	f
19	31	    // Capture one-time layer values\n    req.params = self.mergeParams\n      ? mergeParams(layer.params, parentParams)\n      : layer.params;\n    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }	self.process_params(layer, paramcalled, req, res, function (err) {	10	280	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:280:10	f
20	31	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
21	32	\napp.use(cors());\n\napp.use(er.requestHandler());\napp.get('/programError', async (req, res, next) => {\n  try {\n    console.log('Hi');\n    throw new Error('This is the error!');\n  } catch (e) {\n    // er.captureError(e);\n    next(e);\n  }\n});\n\napp.get('/typeError', async (req, res, next) => {	throw new Error('This is the error!');	11	44	app.js	/app.js:44:11	f
22	32	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
23	32	  var method = req.method.toLowerCase();\n  if (method === 'head' && !this.methods['head']) {\n    method = 'get';\n  }\n\n  req.route = this;\n\n  next();\n\n  function next(err) {\n    // signal to exit route\n    if (err && err === 'route') {\n      return done();\n    }\n	next();	3	114	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:114:3	f
24	32	    }\n\n    if (layer.method && layer.method !== method) {\n      next(err)\n    } else if (err) {\n      layer.handle_error(err, req, res, next);\n    } else {\n      layer.handle_request(req, res, next);\n    }\n\n    sync = 0\n  }\n};\n\n/**	layer.handle_request(req, res, next);	13	144	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:144:13	f
25	32	  var params = this.params;\n\n  // captured parameters from the layer, keys and values\n  var keys = layer.keys;\n\n  // fast track\n  if (!keys || keys.length === 0) {\n    return done();\n  }\n\n  var i = 0;\n  var name;\n  var paramIndex = 0;\n  var key;\n  var paramVal;	return done();	12	346	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:346:12	f
26	32	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
27	32	\N	\N	7	136	home/ian/appWorkSchool/personal-project/sdk/index.js	/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7	f
28	32	    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }\n\n      sync = 0\n    });\n  }	layer.handle_request(req, res, next)	15	284	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:284:15	f
29	32	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
30	32	    // Capture one-time layer values\n    req.params = self.mergeParams\n      ? mergeParams(layer.params, parentParams)\n      : layer.params;\n    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }	self.process_params(layer, paramcalled, req, res, function (err) {	10	280	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:280:10	f
151	82	\napp.use(cors());\n\napp.use(er.requestHandler());\napp.get('/programError', async (req, res, next) => {\n  try {\n    console.log('Hi');\n    throw new Error('This is the error!');\n  } catch (e) {\n    // er.captureError(e);\n    next(e);\n  }\n});\n\napp.get('/typeError', async (req, res, next) => {	throw new Error('This is the error!');	11	44	app.js	/app.js:44:11	f
152	82	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
153	82	    }\n\n    if (layer.method && layer.method !== method) {\n      next(err)\n    } else if (err) {\n      layer.handle_error(err, req, res, next);\n    } else {\n      layer.handle_request(req, res, next);\n    }\n\n    sync = 0\n  }\n};\n\n/**	layer.handle_request(req, res, next);	13	144	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:144:13	f
154	82	  var method = req.method.toLowerCase();\n  if (method === 'head' && !this.methods['head']) {\n    method = 'get';\n  }\n\n  req.route = this;\n\n  next();\n\n  function next(err) {\n    // signal to exit route\n    if (err && err === 'route') {\n      return done();\n    }\n	next();	3	114	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:114:3	f
155	82	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
156	82	    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }\n\n      sync = 0\n    });\n  }	layer.handle_request(req, res, next)	15	284	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:284:15	f
157	82	  var params = this.params;\n\n  // captured parameters from the layer, keys and values\n  var keys = layer.keys;\n\n  // fast track\n  if (!keys || keys.length === 0) {\n    return done();\n  }\n\n  var i = 0;\n  var name;\n  var paramIndex = 0;\n  var key;\n  var paramVal;	return done();	12	346	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:346:12	f
161	83	\napp.use(cors());\n\napp.use(er.requestHandler());\napp.get('/programError', async (req, res, next) => {\n  try {\n    console.log('Hi');\n    throw new Error('This is the error!');\n  } catch (e) {\n    // er.captureError(e);\n    next(e);\n  }\n});\n\napp.get('/typeError', async (req, res, next) => {	throw new Error('This is the error!');	11	44	app.js	/app.js:44:11	f
158	82	    // Capture one-time layer values\n    req.params = self.mergeParams\n      ? mergeParams(layer.params, parentParams)\n      : layer.params;\n    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }	self.process_params(layer, paramcalled, req, res, function (err) {	10	280	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:280:10	f
159	82	\N	\N	7	136	home/ian/appWorkSchool/personal-project/sdk/index.js	/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7	f
160	82	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
162	83	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
163	83	    }\n\n    if (layer.method && layer.method !== method) {\n      next(err)\n    } else if (err) {\n      layer.handle_error(err, req, res, next);\n    } else {\n      layer.handle_request(req, res, next);\n    }\n\n    sync = 0\n  }\n};\n\n/**	layer.handle_request(req, res, next);	13	144	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:144:13	f
164	83	  var method = req.method.toLowerCase();\n  if (method === 'head' && !this.methods['head']) {\n    method = 'get';\n  }\n\n  req.route = this;\n\n  next();\n\n  function next(err) {\n    // signal to exit route\n    if (err && err === 'route') {\n      return done();\n    }\n	next();	3	114	node_modules/express/lib/router/route.js	/node_modules/express/lib/router/route.js:114:3	f
165	83	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
166	83	    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }\n\n      sync = 0\n    });\n  }	layer.handle_request(req, res, next)	15	284	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:284:15	f
167	83	  var params = this.params;\n\n  // captured parameters from the layer, keys and values\n  var keys = layer.keys;\n\n  // fast track\n  if (!keys || keys.length === 0) {\n    return done();\n  }\n\n  var i = 0;\n  var name;\n  var paramIndex = 0;\n  var key;\n  var paramVal;	return done();	12	346	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:346:12	f
168	83	    // Capture one-time layer values\n    req.params = self.mergeParams\n      ? mergeParams(layer.params, parentParams)\n      : layer.params;\n    var layerPath = layer.path;\n\n    // this should be done for the layer\n    self.process_params(layer, paramcalled, req, res, function (err) {\n      if (err) {\n        next(layerError || err)\n      } else if (route) {\n        layer.handle_request(req, res, next)\n      } else {\n        trim_prefix(layer, layerError, layerPath, path)\n      }	self.process_params(layer, paramcalled, req, res, function (err) {	10	280	node_modules/express/lib/router/index.js	/node_modules/express/lib/router/index.js:280:10	f
169	83	\N	\N	7	136	home/ian/appWorkSchool/personal-project/sdk/index.js	/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7	f
170	83	\n  if (fn.length > 3) {\n    // not a standard request handler\n    return next();\n  }\n\n  try {\n    fn(req, res, next);\n  } catch (err) {\n    next(err);\n  }\n};\n\n/**\n * Check if this route matches `path`, if so	fn(req, res, next);	5	95	node_modules/express/lib/router/layer.js	/node_modules/express/lib/router/layer.js:95:5	f
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, user_id, project_id, name, status, stack, message, os_type, os_release, architecture, version, mem_rss, mem_heap_total, mem_heap_used, mem_external, mem_array_buffers, up_time, created_at, fingerprints, work_space_path, delete) FROM stdin;
139	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	71131136	18059264	11147680	4041474	73038	2611	2023-12-14 00:12:53+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
1	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62427136	10526720	9376824	3999345	20085	10823	2023-12-09 16:12:21+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
2	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	64274432	11837440	11315256	4023302	44042	11668	2023-12-09 16:26:26+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
3	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	63770624	12099584	10784480	4033755	54495	11707	2023-12-09 16:27:04+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
4	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	64311296	12099584	11416560	4065000	85740	11798	2023-12-09 16:28:36+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
5	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61243392	10526720	8853624	3996383	17123	14931	2023-12-09 17:20:48+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
6	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61784064	10526720	9396776	4017737	38477	15104	2023-12-09 17:23:41+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
7	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62218240	10788864	9864808	4039091	59831	15217	2023-12-09 17:25:34+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
8	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62488576	10788864	10080272	4060446	81186	15240	2023-12-09 17:25:57+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
9	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62758912	11837440	9635896	4075108	95848	15281	2023-12-09 17:26:39+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
10	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62210048	18321408	11677248	4058005	73038	16547	2023-12-09 17:47:44+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
11	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	59277312	10264576	9259480	3998217	17621	17275	2023-12-09 17:59:52+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
12	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	60952576	10264576	9514856	4019612	38976	17368	2023-12-09 18:01:26+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
13	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61415424	10526720	9983872	4040963	60327	17588	2023-12-09 18:05:06+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
30	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	42565632	13148160	11798896	4383973	404713	5497	2023-12-10 12:26:39+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
82	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61644800	11313152	10526064	4155453	176193	20549	2023-12-10 16:37:38+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
28	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	42811392	13148160	12026904	4394136	414876	5123	2023-12-10 12:20:25+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
102	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	69246976	18059264	11081472	4041474	73038	36945	2023-12-13 22:17:14+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
136	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	74444800	18059264	11147472	4041474	73038	2295	2023-12-14 00:07:37+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
137	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	72654848	18059264	11193656	4041474	73038	2322	2023-12-14 00:08:05+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
29	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	42098688	13148160	11611968	4396515	402331	5277	2023-12-10 12:22:59+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
31	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	43016192	13148160	12026032	4417093	437833	5550	2023-12-10 12:27:32+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
32	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	43216896	13148160	12245480	4450228	470968	5579	2023-12-10 12:28:01+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
83	1	1	Error	handled	Error: This is the error!\n/app.js:44:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/home/ian/appWorkSchool/personal-project/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	14733312	10526720	9815976	4038806	59546	22336	2023-12-10 17:07:26+08	ttDk9OKcuzJc9zHzhw8MTMjSlrPwrp01kIxYXqNlCno=	/home/ian/appWorkSchool/personal-project/targetProject	f
103	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	68878336	18321408	11461416	4042568	73038	37588	2023-12-13 22:27:58+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
92	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66875392	11575296	9549480	4075074	93854	25097	2023-12-13 17:56:51+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
93	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	67145728	11837440	10012048	4096340	115120	25098	2023-12-13 17:56:51+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
94	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	67416064	11837440	10205856	4117610	136390	25098	2023-12-13 17:56:52+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
95	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66781184	11051008	9848696	4138882	141951	25133	2023-12-13 17:57:26+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
96	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66781184	11051008	10049736	4152634	171414	25133	2023-12-13 17:57:26+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
97	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66953216	11313152	10519416	4173905	192685	25133	2023-12-13 17:57:26+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
98	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66953216	11313152	10709864	4195173	213953	25133	2023-12-13 17:57:26+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
99	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	66793472	11575296	10343432	4189820	208600	25133	2023-12-13 17:57:27+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
138	3	7	ReferenceError	unhandled	ReferenceError: hii is not defined\n/app.js:98:1\nnode:internal/process/task_queues:95:5	hii is not defined	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	71290880	18059264	11162288	4041474	73038	2432	2023-12-14 00:09:54+08	KVhDGJff9qSfASXRAYjbqgWW3gDwaf21goOI6CggTOY=	/home/ian/appWorkSchool/targetProject	f
100	2	3	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	67063808	11575296	10538736	4219281	238061	25133	2023-12-13 17:57:27+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
101	3	7	Error	unhandled	Error: This is the error!\n/app.js:48:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	59351040	10264576	8847304	3998303	17123	36846	2023-12-13 22:15:36+08	nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=	/home/ian/appWorkSchool/targetProject	f
140	3	7	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:57:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61034496	10264576	9277112	3998303	17123	2680	2023-12-14 00:14:03+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
141	3	7	Error	unhandled	Error: This is the error!\n/app.js:48:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	61698048	10264576	9612768	4019607	38387	2740	2023-12-14 00:15:02+08	nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=	/home/ian/appWorkSchool/targetProject	f
142	3	7	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:56:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62050304	10264576	8990256	3998303	17123	29552	2023-12-18 18:08:45+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
143	3	7	TypeError	unhandled	TypeError: console.logg is not a function\n/app.js:56:13\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	console.logg is not a function	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62713856	10264576	9462136	4019608	38388	29552	2023-12-18 18:08:45+08	3VwClBvL+gBPrhAf9t4lFskTBbCxUyQQuZHwEp1Y14A=	/home/ian/appWorkSchool/targetProject	f
144	3	7	Error	unhandled	Error: This is the error!\n/app.js:47:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	62955520	10526720	9915328	4040873	59653	29553	2023-12-18 18:08:46+08	nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=	/home/ian/appWorkSchool/targetProject	f
145	3	7	Error	unhandled	Error: This is the error!\n/app.js:47:11\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/route.js:144:13\n/node_modules/express/lib/router/route.js:114:3\n/node_modules/express/lib/router/layer.js:95:5\n/node_modules/express/lib/router/index.js:284:15\n/node_modules/express/lib/router/index.js:346:12\n/node_modules/express/lib/router/index.js:280:10\n/node_modules/@falconeye-tech/sdk/index.js:136:7\n/node_modules/express/lib/router/layer.js:95:5	This is the error!	Linux	5.15.133.1-microsoft-standard-WSL2	x64	v20.9.0	63492096	11575296	9471312	4062072	68160	29553	2023-12-18 18:08:46+08	nF8CIvO9OkV8aSxvbCZgVJnVlPVj/JOQlWr3opj4/Pk=	/home/ian/appWorkSchool/targetProject	f
\.


--
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policies (id, sub, obj, act, eft) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, framework, client_token, user_id, members, delete, name) FROM stdin;
1	express	5dee0e38-54ec-4c87-b7f1-b95eea7cfaba	1	{1}	f	My first project
2	javascript	324d903f-7d5f-416c-9f50-4088483465c9	1	{1}	f	test Project1
3	express	2a103642-b4d6-4136-9ce4-9856a37c2e03	2	{2}	f	Demo project
7	express	ca048536-f004-4b11-ae88-40bb1878666f	3	{3}	f	Demo
8	express	6651b28b-e2d1-402d-8634-073491eae711	3	{3}	f	Demo 2
\.


--
-- Data for Name: request_info; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.request_info (id, url, method, host, useragent, accept, query_paras, event_id, ip, delete) FROM stdin;
1	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	1	::ffff:127.0.0.1	f
2	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	2	::ffff:127.0.0.1	f
3	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	3	::ffff:127.0.0.1	f
4	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	4	::ffff:127.0.0.1	f
5	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	5	::ffff:127.0.0.1	f
6	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	6	::ffff:127.0.0.1	f
7	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	7	::ffff:127.0.0.1	f
8	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	8	::ffff:127.0.0.1	f
9	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	9	::ffff:127.0.0.1	f
10	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	10	::ffff:127.0.0.1	f
11	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	11	::ffff:127.0.0.1	f
12	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	12	::ffff:127.0.0.1	f
13	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	13	::ffff:127.0.0.1	f
14	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	30	::ffff:127.0.0.1	f
15	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	31	::ffff:127.0.0.1	f
16	/programError	GET	localhost:3001	curl/7.81.0	*/*	null	32	::ffff:127.0.0.1	f
26	/programError	GET	localhost:3001	curl/7.81.0	*/*	\N	82	::ffff:127.0.0.1	f
27	/programError	GET	localhost:3001	curl/7.81.0	*/*	\N	83	::ffff:127.0.0.1	f
36	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	92	::1	f
37	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	93	::1	f
38	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	94	::1	f
39	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	95	::1	f
40	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	96	::1	f
41	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	97	::1	f
42	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	98	::1	f
43	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	99	::1	f
44	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	100	::1	f
45	/programError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	101	::1	f
46	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	140	::1	f
47	/programError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	141	::1	f
48	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	143	::1	f
49	/typeError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	142	::1	f
50	/programError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	144	::1	f
51	/programError	GET	localhost:3001	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36 Edg/120.0.0.0	*/*	\N	145	::1	f
\.


--
-- Data for Name: source_maps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.source_maps (id, file_name, project_id, version, hash_value, delete) FROM stdin;
1	zHjWKeI9k2sf.map	1	1	ExzezpjEkS0P82+dk7pyYhexC+7dHOKYNUzMsOYTHxQ=	f
2	4BszTZ2k_Z3j.map	2	1	CeSlPaYCS3WmAO5wcc8z3r0gWbM/ULz4LGvNU8bM7PM=	f
3	x33OdDROcgNc.map	2	1	CeSlPaYCS3WmAO5wcc8z3r0gWbM/ULz4LGvNU8bM7PM=	f
4	8WP5faCoz-Ch.map	2	1	ZFV0z8G4HPQ+c3lLhrr1+HzLVK2XA51sVt2bwMGhWC8=	f
5	1JeMo6XPsHch.map	2	1	ZFV0z8G4HPQ+c3lLhrr1+HzLVK2XA51sVt2bwMGhWC8=	f
6	5Ean2KA4avfQ.map	2	1	ZFV0z8G4HPQ+c3lLhrr1+HzLVK2XA51sVt2bwMGhWC8=	f
7	xT55799Ran8c.map	2	2	CsQ7Wmm6elGhU1WFMxtNczerYAc0E5fH+R3c//aJemw=	f
8	vuPCcEHbzvho.map	3	1	7tV+IM5YpJGV7GP3NPQvOsNEjk1IkcQuaqGb26pjf44=	f
\.


--
-- Data for Name: trigger_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.trigger_types (id, description) FROM stdin;
1	A new issue is created
2	The issue is seen more than {value} times in {interval}
3	the issue is seen by more than {value} users in {interval}
\.


--
-- Data for Name: triggers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.triggers (trigger_type_id, rule_id, threshold, time_window, id, delete) FROM stdin;
1	1	\N	\N	1	t
2	2	\N	1m	2	t
1	3	\N	\N	3	t
2	6	NaN	1m	4	f
2	7	\N	1m	5	f
2	8	\N	1m	6	f
2	9	10	1m	7	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, first_name, second_name, password, user_key) FROM stdin;
1	kevin@gmail.com	kevin	lee	$argon2id$v=19$m=65536,t=3,p=4$k+h7OlsK2bD4MrKMD6Lh1A$Ujivt6yGOoo0tGPboKVps0lVejNDEMycQvUTJgAUCAU	f7da9241-4308-4a97-81c1-e25819140532
2	a186235@gmail.com	Ian	Lai	$argon2id$v=19$m=65536,t=3,p=4$92MtUDEYDPo+CyuHZdDxGA$rUXKRRVRTyNSc00WdKgOzZf1+PKnRRWfzqmENr28xPc	593b182d-8570-45eb-93e9-1f8c277f8375
3	frank@gmail.com	Frank	Tsai	$argon2id$v=19$m=65536,t=3,p=4$oTGdEwltgs74uymL8SDzHw$FlYX7NXVWswREozTK4nIrEdeez40Aqv1XEZ9Ad/XHg8	526acaff-5726-40c7-a8ae-949b8ee23b46
\.


--
-- Name: alert_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alert_histories_id_seq', 1, false);


--
-- Name: alert_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alert_tables_id_seq', 9, true);


--
-- Name: channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.channels_id_seq', 7, true);


--
-- Name: code_blocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.code_blocks_id_seq', 170, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.events_id_seq', 145, true);


--
-- Name: policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.policies_id_seq', 1, false);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.projects_id_seq', 8, true);


--
-- Name: request_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.request_info_id_seq', 51, true);


--
-- Name: source_maps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.source_maps_id_seq', 8, true);


--
-- Name: triggers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.triggers_id_seq', 3, true);


--
-- Name: triggers_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.triggers_id_seq1', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 49, true);


--
-- Name: alert_histories alert_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_histories
    ADD CONSTRAINT alert_histories_pkey PRIMARY KEY (id);


--
-- Name: alert_rules alert_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rules
    ADD CONSTRAINT alert_tables_pkey PRIMARY KEY (id);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: code_blocks code_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_blocks
    ADD CONSTRAINT code_blocks_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: policies policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: request_info request_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_info
    ADD CONSTRAINT request_info_pkey PRIMARY KEY (id);


--
-- Name: source_maps source_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_maps
    ADD CONSTRAINT source_maps_pkey PRIMARY KEY (id);


--
-- Name: trigger_types triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trigger_types
    ADD CONSTRAINT triggers_pkey PRIMARY KEY (id);


--
-- Name: triggers triggers_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.triggers
    ADD CONSTRAINT triggers_pkey1 PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: alert_histories alert_histories_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_histories
    ADD CONSTRAINT alert_histories_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.alert_rules(id);


--
-- Name: channels channels_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.alert_rules(id);


--
-- Name: events events_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: events events_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: projects projects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: request_info request_info_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_info
    ADD CONSTRAINT request_info_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: source_maps source_maps_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_maps
    ADD CONSTRAINT source_maps_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: triggers trigger_rule_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.triggers
    ADD CONSTRAINT trigger_rule_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.alert_rules(id);


--
-- PostgreSQL database dump complete
--

