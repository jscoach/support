--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    collection_id integer NOT NULL,
    "position" integer
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories_packages (
    package_id integer NOT NULL,
    category_id integer NOT NULL
);


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections (
    id integer NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: collections_packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections_packages (
    collection_id integer NOT NULL,
    package_id integer NOT NULL
);


--
-- Name: filters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filters (
    id integer NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    collection_id integer NOT NULL,
    "position" integer
);


--
-- Name: filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE filters_id_seq OWNED BY filters.id;


--
-- Name: filters_packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filters_packages (
    filter_id integer NOT NULL,
    package_id integer NOT NULL
);


--
-- Name: packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE packages (
    id integer NOT NULL,
    name character varying NOT NULL,
    state character varying NOT NULL,
    repo character varying,
    original_repo character varying,
    description text,
    original_description text,
    latest_release character varying,
    modified_at timestamp without time zone,
    published_at timestamp without time zone,
    license character varying,
    homepage character varying,
    last_week_downloads integer,
    last_month_downloads integer,
    stars integer,
    readme text,
    is_fork boolean,
    manifest json,
    contributors json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    languages json,
    downloads json,
    keywords character varying,
    total_downloads integer DEFAULT 0 NOT NULL,
    downloads_svg text DEFAULT ''::text NOT NULL,
    whitelisted boolean DEFAULT false,
    last_fetched timestamp without time zone,
    tweeted boolean DEFAULT false,
    dependents integer,
    hidden boolean DEFAULT false
);


--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscribers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscribers (
    id integer NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscribers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscribers_id_seq OWNED BY subscribers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY filters ALTER COLUMN id SET DEFAULT nextval('filters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscribers ALTER COLUMN id SET DEFAULT nextval('subscribers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filters
    ADD CONSTRAINT filters_pkey PRIMARY KEY (id);


--
-- Name: packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: subscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_categories_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_collection_id ON categories USING btree (collection_id);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_name ON categories USING btree (name);


--
-- Name: index_categories_on_name_and_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_name_and_collection_id ON categories USING btree (name, collection_id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_categories_on_slug_and_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_on_slug_and_collection_id ON categories USING btree (slug, collection_id);


--
-- Name: index_categories_packages_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_packages_on_category_id ON categories_packages USING btree (category_id);


--
-- Name: index_categories_packages_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_packages_on_package_id ON categories_packages USING btree (package_id);


--
-- Name: index_categories_packages_on_package_id_and_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_categories_packages_on_package_id_and_category_id ON categories_packages USING btree (package_id, category_id);


--
-- Name: index_collections_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_collections_on_name ON collections USING btree (name);


--
-- Name: index_collections_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_collections_on_slug ON collections USING btree (slug);


--
-- Name: index_collections_packages_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_packages_on_collection_id ON collections_packages USING btree (collection_id);


--
-- Name: index_collections_packages_on_collection_id_and_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_collections_packages_on_collection_id_and_package_id ON collections_packages USING btree (collection_id, package_id);


--
-- Name: index_collections_packages_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collections_packages_on_package_id ON collections_packages USING btree (package_id);


--
-- Name: index_filters_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filters_on_collection_id ON filters USING btree (collection_id);


--
-- Name: index_filters_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filters_on_name ON filters USING btree (name);


--
-- Name: index_filters_on_name_and_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_filters_on_name_and_collection_id ON filters USING btree (name, collection_id);


--
-- Name: index_filters_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filters_on_slug ON filters USING btree (slug);


--
-- Name: index_filters_on_slug_and_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_filters_on_slug_and_collection_id ON filters USING btree (slug, collection_id);


--
-- Name: index_filters_packages_on_filter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filters_packages_on_filter_id ON filters_packages USING btree (filter_id);


--
-- Name: index_filters_packages_on_filter_id_and_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_filters_packages_on_filter_id_and_package_id ON filters_packages USING btree (filter_id, package_id);


--
-- Name: index_filters_packages_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filters_packages_on_package_id ON filters_packages USING btree (package_id);


--
-- Name: index_packages_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_packages_on_name ON packages USING btree (name);


--
-- Name: index_packages_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_packages_on_state ON packages USING btree (state);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: packages_search; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX packages_search ON packages USING gin (((((to_tsvector('english'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('english'::regconfig, COALESCE(original_description, ''::text))) || to_tsvector('english'::regconfig, COALESCE((original_repo)::text, ''::text))) || to_tsvector('english'::regconfig, COALESCE((keywords)::text, ''::text)))));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_9e61376126; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT fk_rails_9e61376126 FOREIGN KEY (collection_id) REFERENCES collections(id);


--
-- Name: fk_rails_b4918d3b81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY filters
    ADD CONSTRAINT fk_rails_b4918d3b81 FOREIGN KEY (collection_id) REFERENCES collections(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151126104942');

INSERT INTO schema_migrations (version) VALUES ('20151126105014');

INSERT INTO schema_migrations (version) VALUES ('20151126105020');

INSERT INTO schema_migrations (version) VALUES ('20151126105948');

INSERT INTO schema_migrations (version) VALUES ('20151126112638');

INSERT INTO schema_migrations (version) VALUES ('20151126112657');

INSERT INTO schema_migrations (version) VALUES ('20151126112721');

INSERT INTO schema_migrations (version) VALUES ('20151127182135');

INSERT INTO schema_migrations (version) VALUES ('20151129144545');

INSERT INTO schema_migrations (version) VALUES ('20151129192404');

INSERT INTO schema_migrations (version) VALUES ('20151129221509');

INSERT INTO schema_migrations (version) VALUES ('20151129234503');

INSERT INTO schema_migrations (version) VALUES ('20151130195553');

INSERT INTO schema_migrations (version) VALUES ('20151211010759');

INSERT INTO schema_migrations (version) VALUES ('20151224231836');

INSERT INTO schema_migrations (version) VALUES ('20151225213406');

INSERT INTO schema_migrations (version) VALUES ('20151225213427');

INSERT INTO schema_migrations (version) VALUES ('20151225213438');

INSERT INTO schema_migrations (version) VALUES ('20151226133903');

INSERT INTO schema_migrations (version) VALUES ('20151231193401');

INSERT INTO schema_migrations (version) VALUES ('20151231195125');

INSERT INTO schema_migrations (version) VALUES ('20160101150930');

INSERT INTO schema_migrations (version) VALUES ('20160105191836');

INSERT INTO schema_migrations (version) VALUES ('20160105225509');

INSERT INTO schema_migrations (version) VALUES ('20160111105432');

INSERT INTO schema_migrations (version) VALUES ('20160111125910');

INSERT INTO schema_migrations (version) VALUES ('20160114022622');

INSERT INTO schema_migrations (version) VALUES ('20160117234848');

