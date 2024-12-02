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
-- Name: chatwoot; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA chatwoot;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: accounts_after_insert_row_tr(); Type: FUNCTION; Schema: chatwoot; Owner: -
--

CREATE FUNCTION chatwoot.accounts_after_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    execute format('create sequence IF NOT EXISTS conv_dpid_seq_%s', NEW.id);
    RETURN NULL;
END;
$$;


--
-- Name: camp_dpid_before_insert(); Type: FUNCTION; Schema: chatwoot; Owner: -
--

CREATE FUNCTION chatwoot.camp_dpid_before_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    execute format('create sequence IF NOT EXISTS camp_dpid_seq_%s', NEW.id);
    RETURN NULL;
END;
$$;


--
-- Name: campaigns_before_insert_row_tr(); Type: FUNCTION; Schema: chatwoot; Owner: -
--

CREATE FUNCTION chatwoot.campaigns_before_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.display_id := nextval('camp_dpid_seq_' || NEW.account_id);
    RETURN NEW;
END;
$$;


--
-- Name: conversations_before_insert_row_tr(); Type: FUNCTION; Schema: chatwoot; Owner: -
--

CREATE FUNCTION chatwoot.conversations_before_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.display_id := nextval('conv_dpid_seq_' || NEW.account_id);
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_tokens; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.access_tokens (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id bigint,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.access_tokens_id_seq OWNED BY chatwoot.access_tokens.id;


--
-- Name: account_users; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.account_users (
    id bigint NOT NULL,
    account_id bigint,
    user_id bigint,
    role integer DEFAULT 0,
    inviter_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active_at timestamp without time zone,
    availability integer DEFAULT 0 NOT NULL,
    auto_offline boolean DEFAULT true NOT NULL,
    custom_role_id bigint
);


--
-- Name: account_users_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.account_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_users_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.account_users_id_seq OWNED BY chatwoot.account_users.id;


--
-- Name: accounts; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.accounts (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale integer DEFAULT 0,
    domain character varying(100),
    support_email character varying(100),
    feature_flags bigint DEFAULT 0 NOT NULL,
    auto_resolve_duration integer,
    limits jsonb DEFAULT '{}'::jsonb,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    status integer DEFAULT 0
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.accounts_id_seq OWNED BY chatwoot.accounts.id;


--
-- Name: action_mailbox_inbound_emails; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.action_mailbox_inbound_emails (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    message_id character varying NOT NULL,
    message_checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.action_mailbox_inbound_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_mailbox_inbound_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.action_mailbox_inbound_emails_id_seq OWNED BY chatwoot.action_mailbox_inbound_emails.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.active_storage_attachments_id_seq OWNED BY chatwoot.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp without time zone NOT NULL,
    service_name character varying NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.active_storage_blobs_id_seq OWNED BY chatwoot.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.active_storage_variant_records_id_seq OWNED BY chatwoot.active_storage_variant_records.id;


--
-- Name: agent_bot_inboxes; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.agent_bot_inboxes (
    id bigint NOT NULL,
    inbox_id integer,
    agent_bot_id integer,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id integer
);


--
-- Name: agent_bot_inboxes_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.agent_bot_inboxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agent_bot_inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.agent_bot_inboxes_id_seq OWNED BY chatwoot.agent_bot_inboxes.id;


--
-- Name: agent_bots; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.agent_bots (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    outgoing_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    bot_type integer DEFAULT 0,
    bot_config jsonb DEFAULT '{}'::jsonb
);


--
-- Name: agent_bots_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.agent_bots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agent_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.agent_bots_id_seq OWNED BY chatwoot.agent_bots.id;


--
-- Name: applied_slas; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.applied_slas (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    sla_policy_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sla_status integer DEFAULT 0
);


--
-- Name: applied_slas_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.applied_slas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applied_slas_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.applied_slas_id_seq OWNED BY chatwoot.applied_slas.id;


--
-- Name: articles; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.articles (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    portal_id integer NOT NULL,
    category_id integer,
    folder_id integer,
    title character varying,
    description text,
    content text,
    status integer,
    views integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    author_id bigint,
    associated_article_id bigint,
    meta jsonb DEFAULT '{}'::jsonb,
    slug character varying NOT NULL,
    "position" integer,
    locale character varying DEFAULT 'en'::character varying NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.articles_id_seq OWNED BY chatwoot.articles.id;


--
-- Name: attachments; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.attachments (
    id integer NOT NULL,
    file_type integer DEFAULT 0,
    external_url character varying,
    coordinates_lat double precision DEFAULT 0.0,
    coordinates_long double precision DEFAULT 0.0,
    message_id integer NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fallback_title character varying,
    extension character varying
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.attachments_id_seq OWNED BY chatwoot.attachments.id;


--
-- Name: audits; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.audits (
    id bigint NOT NULL,
    auditable_id bigint,
    auditable_type character varying,
    associated_id bigint,
    associated_type character varying,
    user_id bigint,
    user_type character varying,
    username character varying,
    action character varying,
    audited_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    remote_address character varying,
    request_uuid character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.audits_id_seq OWNED BY chatwoot.audits.id;


--
-- Name: automation_rules; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.automation_rules (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    event_name character varying NOT NULL,
    conditions jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    actions jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: automation_rules_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.automation_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.automation_rules_id_seq OWNED BY chatwoot.automation_rules.id;


--
-- Name: campaigns; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.campaigns (
    id bigint NOT NULL,
    display_id integer NOT NULL,
    title character varying NOT NULL,
    description text,
    message text NOT NULL,
    sender_id integer,
    enabled boolean DEFAULT true,
    account_id bigint NOT NULL,
    inbox_id bigint NOT NULL,
    trigger_rules jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    campaign_type integer DEFAULT 0 NOT NULL,
    campaign_status integer DEFAULT 0 NOT NULL,
    audience jsonb DEFAULT '[]'::jsonb,
    scheduled_at timestamp without time zone,
    trigger_only_during_business_hours boolean DEFAULT false
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.campaigns_id_seq OWNED BY chatwoot.campaigns.id;


--
-- Name: canned_responses; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.canned_responses (
    id integer NOT NULL,
    account_id integer NOT NULL,
    short_code character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: canned_responses_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.canned_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: canned_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.canned_responses_id_seq OWNED BY chatwoot.canned_responses.id;


--
-- Name: categories; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.categories (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    portal_id integer NOT NULL,
    name character varying,
    description text,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale character varying DEFAULT 'en'::character varying,
    slug character varying NOT NULL,
    parent_category_id bigint,
    associated_category_id bigint,
    icon character varying DEFAULT ''::character varying
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.categories_id_seq OWNED BY chatwoot.categories.id;


--
-- Name: channel_api; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_api (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    webhook_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier character varying,
    hmac_token character varying,
    hmac_mandatory boolean DEFAULT false,
    additional_attributes jsonb DEFAULT '{}'::jsonb
);


--
-- Name: channel_api_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_api_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_api_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_api_id_seq OWNED BY chatwoot.channel_api.id;


--
-- Name: channel_email; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_email (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    email character varying NOT NULL,
    forward_to_email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    imap_enabled boolean DEFAULT false,
    imap_address character varying DEFAULT ''::character varying,
    imap_port integer DEFAULT 0,
    imap_login character varying DEFAULT ''::character varying,
    imap_password character varying DEFAULT ''::character varying,
    imap_enable_ssl boolean DEFAULT true,
    smtp_enabled boolean DEFAULT false,
    smtp_address character varying DEFAULT ''::character varying,
    smtp_port integer DEFAULT 0,
    smtp_login character varying DEFAULT ''::character varying,
    smtp_password character varying DEFAULT ''::character varying,
    smtp_domain character varying DEFAULT ''::character varying,
    smtp_enable_starttls_auto boolean DEFAULT true,
    smtp_authentication character varying DEFAULT 'login'::character varying,
    smtp_openssl_verify_mode character varying DEFAULT 'none'::character varying,
    smtp_enable_ssl_tls boolean DEFAULT false,
    provider_config jsonb DEFAULT '{}'::jsonb,
    provider character varying
);


--
-- Name: channel_email_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_email_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_email_id_seq OWNED BY chatwoot.channel_email.id;


--
-- Name: channel_facebook_pages; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_facebook_pages (
    id integer NOT NULL,
    page_id character varying NOT NULL,
    user_access_token character varying NOT NULL,
    page_access_token character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    instagram_id character varying
);


--
-- Name: channel_facebook_pages_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_facebook_pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_facebook_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_facebook_pages_id_seq OWNED BY chatwoot.channel_facebook_pages.id;


--
-- Name: channel_line; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_line (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    line_channel_id character varying NOT NULL,
    line_channel_secret character varying NOT NULL,
    line_channel_token character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channel_line_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_line_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_line_id_seq OWNED BY chatwoot.channel_line.id;


--
-- Name: channel_sms; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_sms (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    phone_number character varying NOT NULL,
    provider character varying DEFAULT 'default'::character varying,
    provider_config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channel_sms_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_sms_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_sms_id_seq OWNED BY chatwoot.channel_sms.id;


--
-- Name: channel_telegram; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_telegram (
    id bigint NOT NULL,
    bot_name character varying,
    account_id integer NOT NULL,
    bot_token character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channel_telegram_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_telegram_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_telegram_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_telegram_id_seq OWNED BY chatwoot.channel_telegram.id;


--
-- Name: channel_twilio_sms; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_twilio_sms (
    id bigint NOT NULL,
    phone_number character varying,
    auth_token character varying NOT NULL,
    account_sid character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    medium integer DEFAULT 0,
    messaging_service_sid character varying,
    api_key_sid character varying
);


--
-- Name: channel_twilio_sms_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_twilio_sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_twilio_sms_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_twilio_sms_id_seq OWNED BY chatwoot.channel_twilio_sms.id;


--
-- Name: channel_twitter_profiles; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_twitter_profiles (
    id bigint NOT NULL,
    profile_id character varying NOT NULL,
    twitter_access_token character varying NOT NULL,
    twitter_access_token_secret character varying NOT NULL,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tweets_enabled boolean DEFAULT true
);


--
-- Name: channel_twitter_profiles_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_twitter_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_twitter_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_twitter_profiles_id_seq OWNED BY chatwoot.channel_twitter_profiles.id;


--
-- Name: channel_web_widgets; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_web_widgets (
    id integer NOT NULL,
    website_url character varying,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    website_token character varying,
    widget_color character varying DEFAULT '#1f93ff'::character varying,
    welcome_title character varying,
    welcome_tagline character varying,
    feature_flags integer DEFAULT 7 NOT NULL,
    reply_time integer DEFAULT 0,
    hmac_token character varying,
    pre_chat_form_enabled boolean DEFAULT false,
    pre_chat_form_options jsonb DEFAULT '{}'::jsonb,
    hmac_mandatory boolean DEFAULT false,
    continuity_via_email boolean DEFAULT true NOT NULL
);


--
-- Name: channel_web_widgets_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_web_widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_web_widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_web_widgets_id_seq OWNED BY chatwoot.channel_web_widgets.id;


--
-- Name: channel_whatsapp; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.channel_whatsapp (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    phone_number character varying NOT NULL,
    provider character varying DEFAULT 'default'::character varying,
    provider_config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    message_templates jsonb DEFAULT '{}'::jsonb,
    message_templates_last_updated timestamp without time zone
);


--
-- Name: channel_whatsapp_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.channel_whatsapp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_whatsapp_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.channel_whatsapp_id_seq OWNED BY chatwoot.channel_whatsapp.id;


--
-- Name: contact_inboxes; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.contact_inboxes (
    id bigint NOT NULL,
    contact_id bigint,
    inbox_id bigint,
    source_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hmac_verified boolean DEFAULT false,
    pubsub_token character varying
);


--
-- Name: contact_inboxes_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.contact_inboxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.contact_inboxes_id_seq OWNED BY chatwoot.contact_inboxes.id;


--
-- Name: contacts; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.contacts (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    email character varying,
    phone_number character varying,
    account_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_attributes jsonb DEFAULT '{}'::jsonb,
    identifier character varying,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    last_activity_at timestamp without time zone,
    contact_type integer DEFAULT 0,
    middle_name character varying DEFAULT ''::character varying,
    last_name character varying DEFAULT ''::character varying,
    location character varying DEFAULT ''::character varying,
    country_code character varying DEFAULT ''::character varying,
    blocked boolean DEFAULT false NOT NULL
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.contacts_id_seq OWNED BY chatwoot.contacts.id;


--
-- Name: conversation_participants; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.conversation_participants (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: conversation_participants_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.conversation_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversation_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.conversation_participants_id_seq OWNED BY chatwoot.conversation_participants.id;


--
-- Name: conversations; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.conversations (
    id integer NOT NULL,
    account_id integer NOT NULL,
    inbox_id integer NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    assignee_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_id bigint,
    display_id integer NOT NULL,
    contact_last_seen_at timestamp without time zone,
    agent_last_seen_at timestamp without time zone,
    additional_attributes jsonb DEFAULT '{}'::jsonb,
    contact_inbox_id bigint,
    uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    identifier character varying,
    last_activity_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    team_id bigint,
    campaign_id bigint,
    snoozed_until timestamp without time zone,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    assignee_last_seen_at timestamp without time zone,
    first_reply_created_at timestamp without time zone,
    priority integer,
    sla_policy_id bigint,
    waiting_since timestamp(6) without time zone,
    cached_label_list text
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.conversations_id_seq OWNED BY chatwoot.conversations.id;


--
-- Name: csat_survey_responses; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.csat_survey_responses (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    message_id bigint NOT NULL,
    rating integer NOT NULL,
    feedback_message text,
    contact_id bigint NOT NULL,
    assigned_agent_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: csat_survey_responses_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.csat_survey_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: csat_survey_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.csat_survey_responses_id_seq OWNED BY chatwoot.csat_survey_responses.id;


--
-- Name: custom_attribute_definitions; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.custom_attribute_definitions (
    id bigint NOT NULL,
    attribute_display_name character varying,
    attribute_key character varying,
    attribute_display_type integer DEFAULT 0,
    default_value integer,
    attribute_model integer DEFAULT 0,
    account_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    attribute_description text,
    attribute_values jsonb DEFAULT '[]'::jsonb,
    regex_pattern character varying,
    regex_cue character varying
);


--
-- Name: custom_attribute_definitions_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.custom_attribute_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_attribute_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.custom_attribute_definitions_id_seq OWNED BY chatwoot.custom_attribute_definitions.id;


--
-- Name: custom_filters; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.custom_filters (
    id bigint NOT NULL,
    name character varying NOT NULL,
    filter_type integer DEFAULT 0 NOT NULL,
    query jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_filters_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.custom_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.custom_filters_id_seq OWNED BY chatwoot.custom_filters.id;


--
-- Name: custom_roles; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.custom_roles (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    account_id bigint NOT NULL,
    permissions text[] DEFAULT '{}'::text[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: custom_roles_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.custom_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.custom_roles_id_seq OWNED BY chatwoot.custom_roles.id;


--
-- Name: dashboard_apps; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.dashboard_apps (
    id bigint NOT NULL,
    title character varying NOT NULL,
    content jsonb DEFAULT '[]'::jsonb,
    account_id bigint NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dashboard_apps_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.dashboard_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboard_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.dashboard_apps_id_seq OWNED BY chatwoot.dashboard_apps.id;


--
-- Name: data_imports; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.data_imports (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    data_type character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    processing_errors text,
    total_records integer,
    processed_records integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: data_imports_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.data_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.data_imports_id_seq OWNED BY chatwoot.data_imports.id;


--
-- Name: email_templates; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.email_templates (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text NOT NULL,
    account_id integer,
    template_type integer DEFAULT 1,
    locale integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_templates_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.email_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.email_templates_id_seq OWNED BY chatwoot.email_templates.id;


--
-- Name: folders; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.folders (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.folders_id_seq OWNED BY chatwoot.folders.id;


--
-- Name: inbox_members; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.inbox_members (
    id integer NOT NULL,
    user_id integer NOT NULL,
    inbox_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: inbox_members_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.inbox_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inbox_members_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.inbox_members_id_seq OWNED BY chatwoot.inbox_members.id;


--
-- Name: inboxes; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.inboxes (
    id integer NOT NULL,
    channel_id integer NOT NULL,
    account_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    channel_type character varying,
    enable_auto_assignment boolean DEFAULT true,
    greeting_enabled boolean DEFAULT false,
    greeting_message character varying,
    email_address character varying,
    working_hours_enabled boolean DEFAULT false,
    out_of_office_message character varying,
    timezone character varying DEFAULT 'UTC'::character varying,
    enable_email_collect boolean DEFAULT true,
    csat_survey_enabled boolean DEFAULT false,
    allow_messages_after_resolved boolean DEFAULT true,
    auto_assignment_config jsonb DEFAULT '{}'::jsonb,
    lock_to_single_conversation boolean DEFAULT false NOT NULL,
    portal_id bigint,
    sender_name_type integer DEFAULT 0 NOT NULL,
    business_name character varying
);


--
-- Name: inboxes_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.inboxes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inboxes_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.inboxes_id_seq OWNED BY chatwoot.inboxes.id;


--
-- Name: installation_configs; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.installation_configs (
    id bigint NOT NULL,
    name character varying NOT NULL,
    serialized_value jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locked boolean DEFAULT true NOT NULL
);


--
-- Name: installation_configs_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.installation_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: installation_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.installation_configs_id_seq OWNED BY chatwoot.installation_configs.id;


--
-- Name: integrations_hooks; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.integrations_hooks (
    id bigint NOT NULL,
    status integer DEFAULT 1,
    inbox_id integer,
    account_id integer,
    app_id character varying,
    hook_type integer DEFAULT 0,
    reference_id character varying,
    access_token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb
);


--
-- Name: integrations_hooks_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.integrations_hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: integrations_hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.integrations_hooks_id_seq OWNED BY chatwoot.integrations_hooks.id;


--
-- Name: labels; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.labels (
    id bigint NOT NULL,
    title character varying,
    description text,
    color character varying DEFAULT '#1f93ff'::character varying NOT NULL,
    show_on_sidebar boolean,
    account_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.labels_id_seq OWNED BY chatwoot.labels.id;


--
-- Name: macros; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.macros (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    name character varying NOT NULL,
    visibility integer DEFAULT 0,
    created_by_id bigint,
    updated_by_id bigint,
    actions jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: macros_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.macros_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: macros_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.macros_id_seq OWNED BY chatwoot.macros.id;


--
-- Name: mentions; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.mentions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL,
    mentioned_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mentions_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.mentions_id_seq OWNED BY chatwoot.mentions.id;


--
-- Name: messages; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.messages (
    id integer NOT NULL,
    content text,
    account_id integer NOT NULL,
    inbox_id integer NOT NULL,
    conversation_id integer NOT NULL,
    message_type integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    private boolean DEFAULT false NOT NULL,
    status integer DEFAULT 0,
    source_id character varying,
    content_type integer DEFAULT 0 NOT NULL,
    content_attributes json DEFAULT '{}'::json,
    sender_type character varying,
    sender_id bigint,
    external_source_ids jsonb DEFAULT '{}'::jsonb,
    additional_attributes jsonb DEFAULT '{}'::jsonb,
    processed_message_content text,
    sentiment jsonb DEFAULT '{}'::jsonb
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.messages_id_seq OWNED BY chatwoot.messages.id;


--
-- Name: notes; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.notes_id_seq OWNED BY chatwoot.notes.id;


--
-- Name: notification_settings; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.notification_settings (
    id bigint NOT NULL,
    account_id integer,
    user_id integer,
    email_flags integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    push_flags integer DEFAULT 0 NOT NULL
);


--
-- Name: notification_settings_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.notification_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.notification_settings_id_seq OWNED BY chatwoot.notification_settings.id;


--
-- Name: notification_subscriptions; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.notification_subscriptions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    subscription_type integer NOT NULL,
    subscription_attributes jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier text
);


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.notification_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.notification_subscriptions_id_seq OWNED BY chatwoot.notification_subscriptions.id;


--
-- Name: notifications; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.notifications (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    notification_type integer NOT NULL,
    primary_actor_type character varying NOT NULL,
    primary_actor_id bigint NOT NULL,
    secondary_actor_type character varying,
    secondary_actor_id bigint,
    read_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    snoozed_until timestamp(6) without time zone,
    last_activity_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    meta jsonb DEFAULT '{}'::jsonb
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.notifications_id_seq OWNED BY chatwoot.notifications.id;


--
-- Name: platform_app_permissibles; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.platform_app_permissibles (
    id bigint NOT NULL,
    platform_app_id bigint NOT NULL,
    permissible_type character varying NOT NULL,
    permissible_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: platform_app_permissibles_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.platform_app_permissibles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platform_app_permissibles_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.platform_app_permissibles_id_seq OWNED BY chatwoot.platform_app_permissibles.id;


--
-- Name: platform_apps; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.platform_apps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: platform_apps_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.platform_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platform_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.platform_apps_id_seq OWNED BY chatwoot.platform_apps.id;


--
-- Name: portal_members; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.portal_members (
    id bigint NOT NULL,
    portal_id bigint,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portal_members_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.portal_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portal_members_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.portal_members_id_seq OWNED BY chatwoot.portal_members.id;


--
-- Name: portals; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.portals (
    id bigint NOT NULL,
    account_id integer NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    custom_domain character varying,
    color character varying,
    homepage_link character varying,
    page_title character varying,
    header_text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    config jsonb DEFAULT '{"allowed_locales": ["en"]}'::jsonb,
    archived boolean DEFAULT false,
    channel_web_widget_id bigint
);


--
-- Name: portals_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.portals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portals_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.portals_id_seq OWNED BY chatwoot.portals.id;


--
-- Name: portals_members; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.portals_members (
    portal_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: related_categories; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.related_categories (
    id bigint NOT NULL,
    category_id bigint,
    related_category_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: related_categories_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.related_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: related_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.related_categories_id_seq OWNED BY chatwoot.related_categories.id;


--
-- Name: reporting_events; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.reporting_events (
    id bigint NOT NULL,
    name character varying,
    value double precision,
    account_id integer,
    inbox_id integer,
    user_id integer,
    conversation_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    value_in_business_hours double precision,
    event_start_time timestamp without time zone,
    event_end_time timestamp without time zone
);


--
-- Name: reporting_events_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.reporting_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reporting_events_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.reporting_events_id_seq OWNED BY chatwoot.reporting_events.id;


--
-- Name: sla_events; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.sla_events (
    id bigint NOT NULL,
    applied_sla_id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL,
    sla_policy_id bigint NOT NULL,
    inbox_id bigint NOT NULL,
    event_type integer,
    meta jsonb DEFAULT '{}'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sla_events_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.sla_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sla_events_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.sla_events_id_seq OWNED BY chatwoot.sla_events.id;


--
-- Name: sla_policies; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.sla_policies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    first_response_time_threshold double precision,
    next_response_time_threshold double precision,
    only_during_business_hours boolean DEFAULT false,
    account_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description character varying,
    resolution_time_threshold double precision
);


--
-- Name: sla_policies_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.sla_policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sla_policies_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.sla_policies_id_seq OWNED BY chatwoot.sla_policies.id;


--
-- Name: taggings; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_type character varying,
    taggable_id integer,
    tagger_type character varying,
    tagger_id integer,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.taggings_id_seq OWNED BY chatwoot.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.tags_id_seq OWNED BY chatwoot.tags.id;


--
-- Name: team_members; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.team_members (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.team_members_id_seq OWNED BY chatwoot.team_members.id;


--
-- Name: teams; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.teams (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    allow_auto_assign boolean DEFAULT true,
    account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.teams_id_seq OWNED BY chatwoot.teams.id;


--
-- Name: telegram_bots; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.telegram_bots (
    id integer NOT NULL,
    name character varying,
    auth_key character varying,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: telegram_bots_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.telegram_bots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: telegram_bots_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.telegram_bots_id_seq OWNED BY chatwoot.telegram_bots.id;


--
-- Name: users; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.users (
    id integer NOT NULL,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    name character varying NOT NULL,
    display_name character varying,
    email character varying,
    tokens json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pubsub_token character varying,
    availability integer DEFAULT 0,
    ui_settings jsonb DEFAULT '{}'::jsonb,
    custom_attributes jsonb DEFAULT '{}'::jsonb,
    type character varying,
    message_signature text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.users_id_seq OWNED BY chatwoot.users.id;


--
-- Name: webhooks; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.webhooks (
    id bigint NOT NULL,
    account_id integer,
    inbox_id integer,
    url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    webhook_type integer DEFAULT 0,
    subscriptions jsonb DEFAULT '["conversation_status_changed", "conversation_updated", "conversation_created", "contact_created", "contact_updated", "message_created", "message_updated", "webwidget_triggered"]'::jsonb
);


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.webhooks_id_seq OWNED BY chatwoot.webhooks.id;


--
-- Name: working_hours; Type: TABLE; Schema: chatwoot; Owner: -
--

CREATE TABLE chatwoot.working_hours (
    id bigint NOT NULL,
    inbox_id bigint,
    account_id bigint,
    day_of_week integer NOT NULL,
    closed_all_day boolean DEFAULT false,
    open_hour integer,
    open_minutes integer,
    close_hour integer,
    close_minutes integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    open_all_day boolean DEFAULT false
);


--
-- Name: working_hours_id_seq; Type: SEQUENCE; Schema: chatwoot; Owner: -
--

CREATE SEQUENCE chatwoot.working_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: working_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: chatwoot; Owner: -
--

ALTER SEQUENCE chatwoot.working_hours_id_seq OWNED BY chatwoot.working_hours.id;


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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: access_tokens id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.access_tokens ALTER COLUMN id SET DEFAULT nextval('chatwoot.access_tokens_id_seq'::regclass);


--
-- Name: account_users id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.account_users ALTER COLUMN id SET DEFAULT nextval('chatwoot.account_users_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.accounts ALTER COLUMN id SET DEFAULT nextval('chatwoot.accounts_id_seq'::regclass);


--
-- Name: action_mailbox_inbound_emails id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.action_mailbox_inbound_emails ALTER COLUMN id SET DEFAULT nextval('chatwoot.action_mailbox_inbound_emails_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('chatwoot.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('chatwoot.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('chatwoot.active_storage_variant_records_id_seq'::regclass);


--
-- Name: agent_bot_inboxes id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.agent_bot_inboxes ALTER COLUMN id SET DEFAULT nextval('chatwoot.agent_bot_inboxes_id_seq'::regclass);


--
-- Name: agent_bots id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.agent_bots ALTER COLUMN id SET DEFAULT nextval('chatwoot.agent_bots_id_seq'::regclass);


--
-- Name: applied_slas id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.applied_slas ALTER COLUMN id SET DEFAULT nextval('chatwoot.applied_slas_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.articles ALTER COLUMN id SET DEFAULT nextval('chatwoot.articles_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.attachments ALTER COLUMN id SET DEFAULT nextval('chatwoot.attachments_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.audits ALTER COLUMN id SET DEFAULT nextval('chatwoot.audits_id_seq'::regclass);


--
-- Name: automation_rules id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.automation_rules ALTER COLUMN id SET DEFAULT nextval('chatwoot.automation_rules_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.campaigns ALTER COLUMN id SET DEFAULT nextval('chatwoot.campaigns_id_seq'::regclass);


--
-- Name: canned_responses id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.canned_responses ALTER COLUMN id SET DEFAULT nextval('chatwoot.canned_responses_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.categories ALTER COLUMN id SET DEFAULT nextval('chatwoot.categories_id_seq'::regclass);


--
-- Name: channel_api id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_api ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_api_id_seq'::regclass);


--
-- Name: channel_email id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_email ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_email_id_seq'::regclass);


--
-- Name: channel_facebook_pages id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_facebook_pages ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_facebook_pages_id_seq'::regclass);


--
-- Name: channel_line id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_line ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_line_id_seq'::regclass);


--
-- Name: channel_sms id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_sms ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_sms_id_seq'::regclass);


--
-- Name: channel_telegram id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_telegram ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_telegram_id_seq'::regclass);


--
-- Name: channel_twilio_sms id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_twilio_sms ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_twilio_sms_id_seq'::regclass);


--
-- Name: channel_twitter_profiles id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_twitter_profiles ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_twitter_profiles_id_seq'::regclass);


--
-- Name: channel_web_widgets id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_web_widgets ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_web_widgets_id_seq'::regclass);


--
-- Name: channel_whatsapp id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_whatsapp ALTER COLUMN id SET DEFAULT nextval('chatwoot.channel_whatsapp_id_seq'::regclass);


--
-- Name: contact_inboxes id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.contact_inboxes ALTER COLUMN id SET DEFAULT nextval('chatwoot.contact_inboxes_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.contacts ALTER COLUMN id SET DEFAULT nextval('chatwoot.contacts_id_seq'::regclass);


--
-- Name: conversation_participants id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.conversation_participants ALTER COLUMN id SET DEFAULT nextval('chatwoot.conversation_participants_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.conversations ALTER COLUMN id SET DEFAULT nextval('chatwoot.conversations_id_seq'::regclass);


--
-- Name: csat_survey_responses id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.csat_survey_responses ALTER COLUMN id SET DEFAULT nextval('chatwoot.csat_survey_responses_id_seq'::regclass);


--
-- Name: custom_attribute_definitions id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_attribute_definitions ALTER COLUMN id SET DEFAULT nextval('chatwoot.custom_attribute_definitions_id_seq'::regclass);


--
-- Name: custom_filters id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_filters ALTER COLUMN id SET DEFAULT nextval('chatwoot.custom_filters_id_seq'::regclass);


--
-- Name: custom_roles id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_roles ALTER COLUMN id SET DEFAULT nextval('chatwoot.custom_roles_id_seq'::regclass);


--
-- Name: dashboard_apps id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.dashboard_apps ALTER COLUMN id SET DEFAULT nextval('chatwoot.dashboard_apps_id_seq'::regclass);


--
-- Name: data_imports id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.data_imports ALTER COLUMN id SET DEFAULT nextval('chatwoot.data_imports_id_seq'::regclass);


--
-- Name: email_templates id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.email_templates ALTER COLUMN id SET DEFAULT nextval('chatwoot.email_templates_id_seq'::regclass);


--
-- Name: folders id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.folders ALTER COLUMN id SET DEFAULT nextval('chatwoot.folders_id_seq'::regclass);


--
-- Name: inbox_members id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.inbox_members ALTER COLUMN id SET DEFAULT nextval('chatwoot.inbox_members_id_seq'::regclass);


--
-- Name: inboxes id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.inboxes ALTER COLUMN id SET DEFAULT nextval('chatwoot.inboxes_id_seq'::regclass);


--
-- Name: installation_configs id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.installation_configs ALTER COLUMN id SET DEFAULT nextval('chatwoot.installation_configs_id_seq'::regclass);


--
-- Name: integrations_hooks id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.integrations_hooks ALTER COLUMN id SET DEFAULT nextval('chatwoot.integrations_hooks_id_seq'::regclass);


--
-- Name: labels id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.labels ALTER COLUMN id SET DEFAULT nextval('chatwoot.labels_id_seq'::regclass);


--
-- Name: macros id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.macros ALTER COLUMN id SET DEFAULT nextval('chatwoot.macros_id_seq'::regclass);


--
-- Name: mentions id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.mentions ALTER COLUMN id SET DEFAULT nextval('chatwoot.mentions_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.messages ALTER COLUMN id SET DEFAULT nextval('chatwoot.messages_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notes ALTER COLUMN id SET DEFAULT nextval('chatwoot.notes_id_seq'::regclass);


--
-- Name: notification_settings id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notification_settings ALTER COLUMN id SET DEFAULT nextval('chatwoot.notification_settings_id_seq'::regclass);


--
-- Name: notification_subscriptions id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notification_subscriptions ALTER COLUMN id SET DEFAULT nextval('chatwoot.notification_subscriptions_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notifications ALTER COLUMN id SET DEFAULT nextval('chatwoot.notifications_id_seq'::regclass);


--
-- Name: platform_app_permissibles id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.platform_app_permissibles ALTER COLUMN id SET DEFAULT nextval('chatwoot.platform_app_permissibles_id_seq'::regclass);


--
-- Name: platform_apps id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.platform_apps ALTER COLUMN id SET DEFAULT nextval('chatwoot.platform_apps_id_seq'::regclass);


--
-- Name: portal_members id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.portal_members ALTER COLUMN id SET DEFAULT nextval('chatwoot.portal_members_id_seq'::regclass);


--
-- Name: portals id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.portals ALTER COLUMN id SET DEFAULT nextval('chatwoot.portals_id_seq'::regclass);


--
-- Name: related_categories id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.related_categories ALTER COLUMN id SET DEFAULT nextval('chatwoot.related_categories_id_seq'::regclass);


--
-- Name: reporting_events id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.reporting_events ALTER COLUMN id SET DEFAULT nextval('chatwoot.reporting_events_id_seq'::regclass);


--
-- Name: sla_events id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.sla_events ALTER COLUMN id SET DEFAULT nextval('chatwoot.sla_events_id_seq'::regclass);


--
-- Name: sla_policies id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.sla_policies ALTER COLUMN id SET DEFAULT nextval('chatwoot.sla_policies_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.taggings ALTER COLUMN id SET DEFAULT nextval('chatwoot.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.tags ALTER COLUMN id SET DEFAULT nextval('chatwoot.tags_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.team_members ALTER COLUMN id SET DEFAULT nextval('chatwoot.team_members_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.teams ALTER COLUMN id SET DEFAULT nextval('chatwoot.teams_id_seq'::regclass);


--
-- Name: telegram_bots id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.telegram_bots ALTER COLUMN id SET DEFAULT nextval('chatwoot.telegram_bots_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.users ALTER COLUMN id SET DEFAULT nextval('chatwoot.users_id_seq'::regclass);


--
-- Name: webhooks id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.webhooks ALTER COLUMN id SET DEFAULT nextval('chatwoot.webhooks_id_seq'::regclass);


--
-- Name: working_hours id; Type: DEFAULT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.working_hours ALTER COLUMN id SET DEFAULT nextval('chatwoot.working_hours_id_seq'::regclass);


--
-- Name: access_tokens access_tokens_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: account_users account_users_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.account_users
    ADD CONSTRAINT account_users_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: action_mailbox_inbound_emails action_mailbox_inbound_emails_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.action_mailbox_inbound_emails
    ADD CONSTRAINT action_mailbox_inbound_emails_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: agent_bot_inboxes agent_bot_inboxes_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.agent_bot_inboxes
    ADD CONSTRAINT agent_bot_inboxes_pkey PRIMARY KEY (id);


--
-- Name: agent_bots agent_bots_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.agent_bots
    ADD CONSTRAINT agent_bots_pkey PRIMARY KEY (id);


--
-- Name: applied_slas applied_slas_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.applied_slas
    ADD CONSTRAINT applied_slas_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: automation_rules automation_rules_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.automation_rules
    ADD CONSTRAINT automation_rules_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: canned_responses canned_responses_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.canned_responses
    ADD CONSTRAINT canned_responses_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: channel_api channel_api_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_api
    ADD CONSTRAINT channel_api_pkey PRIMARY KEY (id);


--
-- Name: channel_email channel_email_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_email
    ADD CONSTRAINT channel_email_pkey PRIMARY KEY (id);


--
-- Name: channel_facebook_pages channel_facebook_pages_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_facebook_pages
    ADD CONSTRAINT channel_facebook_pages_pkey PRIMARY KEY (id);


--
-- Name: channel_line channel_line_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_line
    ADD CONSTRAINT channel_line_pkey PRIMARY KEY (id);


--
-- Name: channel_sms channel_sms_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_sms
    ADD CONSTRAINT channel_sms_pkey PRIMARY KEY (id);


--
-- Name: channel_telegram channel_telegram_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_telegram
    ADD CONSTRAINT channel_telegram_pkey PRIMARY KEY (id);


--
-- Name: channel_twilio_sms channel_twilio_sms_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_twilio_sms
    ADD CONSTRAINT channel_twilio_sms_pkey PRIMARY KEY (id);


--
-- Name: channel_twitter_profiles channel_twitter_profiles_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_twitter_profiles
    ADD CONSTRAINT channel_twitter_profiles_pkey PRIMARY KEY (id);


--
-- Name: channel_web_widgets channel_web_widgets_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_web_widgets
    ADD CONSTRAINT channel_web_widgets_pkey PRIMARY KEY (id);


--
-- Name: channel_whatsapp channel_whatsapp_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.channel_whatsapp
    ADD CONSTRAINT channel_whatsapp_pkey PRIMARY KEY (id);


--
-- Name: contact_inboxes contact_inboxes_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.contact_inboxes
    ADD CONSTRAINT contact_inboxes_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: conversation_participants conversation_participants_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.conversation_participants
    ADD CONSTRAINT conversation_participants_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: csat_survey_responses csat_survey_responses_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.csat_survey_responses
    ADD CONSTRAINT csat_survey_responses_pkey PRIMARY KEY (id);


--
-- Name: custom_attribute_definitions custom_attribute_definitions_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_attribute_definitions
    ADD CONSTRAINT custom_attribute_definitions_pkey PRIMARY KEY (id);


--
-- Name: custom_filters custom_filters_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_filters
    ADD CONSTRAINT custom_filters_pkey PRIMARY KEY (id);


--
-- Name: custom_roles custom_roles_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.custom_roles
    ADD CONSTRAINT custom_roles_pkey PRIMARY KEY (id);


--
-- Name: dashboard_apps dashboard_apps_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.dashboard_apps
    ADD CONSTRAINT dashboard_apps_pkey PRIMARY KEY (id);


--
-- Name: data_imports data_imports_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.data_imports
    ADD CONSTRAINT data_imports_pkey PRIMARY KEY (id);


--
-- Name: email_templates email_templates_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.email_templates
    ADD CONSTRAINT email_templates_pkey PRIMARY KEY (id);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: inbox_members inbox_members_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.inbox_members
    ADD CONSTRAINT inbox_members_pkey PRIMARY KEY (id);


--
-- Name: inboxes inboxes_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.inboxes
    ADD CONSTRAINT inboxes_pkey PRIMARY KEY (id);


--
-- Name: installation_configs installation_configs_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.installation_configs
    ADD CONSTRAINT installation_configs_pkey PRIMARY KEY (id);


--
-- Name: integrations_hooks integrations_hooks_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.integrations_hooks
    ADD CONSTRAINT integrations_hooks_pkey PRIMARY KEY (id);


--
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: macros macros_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.macros
    ADD CONSTRAINT macros_pkey PRIMARY KEY (id);


--
-- Name: mentions mentions_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notification_settings notification_settings_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notification_settings
    ADD CONSTRAINT notification_settings_pkey PRIMARY KEY (id);


--
-- Name: notification_subscriptions notification_subscriptions_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notification_subscriptions
    ADD CONSTRAINT notification_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: platform_app_permissibles platform_app_permissibles_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.platform_app_permissibles
    ADD CONSTRAINT platform_app_permissibles_pkey PRIMARY KEY (id);


--
-- Name: platform_apps platform_apps_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.platform_apps
    ADD CONSTRAINT platform_apps_pkey PRIMARY KEY (id);


--
-- Name: portal_members portal_members_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.portal_members
    ADD CONSTRAINT portal_members_pkey PRIMARY KEY (id);


--
-- Name: portals portals_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.portals
    ADD CONSTRAINT portals_pkey PRIMARY KEY (id);


--
-- Name: related_categories related_categories_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.related_categories
    ADD CONSTRAINT related_categories_pkey PRIMARY KEY (id);


--
-- Name: reporting_events reporting_events_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.reporting_events
    ADD CONSTRAINT reporting_events_pkey PRIMARY KEY (id);


--
-- Name: sla_events sla_events_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.sla_events
    ADD CONSTRAINT sla_events_pkey PRIMARY KEY (id);


--
-- Name: sla_policies sla_policies_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.sla_policies
    ADD CONSTRAINT sla_policies_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: telegram_bots telegram_bots_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.telegram_bots
    ADD CONSTRAINT telegram_bots_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: working_hours working_hours_pkey; Type: CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.working_hours
    ADD CONSTRAINT working_hours_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: associated_index; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX associated_index ON chatwoot.audits USING btree (associated_type, associated_id);


--
-- Name: attribute_key_model_index; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX attribute_key_model_index ON chatwoot.custom_attribute_definitions USING btree (attribute_key, attribute_model, account_id);


--
-- Name: auditable_index; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX auditable_index ON chatwoot.audits USING btree (auditable_type, auditable_id, version);


--
-- Name: by_account_user; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX by_account_user ON chatwoot.notification_settings USING btree (account_id, user_id);


--
-- Name: conv_acid_inbid_stat_asgnid_idx; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX conv_acid_inbid_stat_asgnid_idx ON chatwoot.conversations USING btree (account_id, inbox_id, status, assignee_id);


--
-- Name: index_access_tokens_on_owner_type_and_owner_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_access_tokens_on_owner_type_and_owner_id ON chatwoot.access_tokens USING btree (owner_type, owner_id);


--
-- Name: index_access_tokens_on_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_access_tokens_on_token ON chatwoot.access_tokens USING btree (token);


--
-- Name: index_account_users_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_account_users_on_account_id ON chatwoot.account_users USING btree (account_id);


--
-- Name: index_account_users_on_custom_role_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_account_users_on_custom_role_id ON chatwoot.account_users USING btree (custom_role_id);


--
-- Name: index_account_users_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_account_users_on_user_id ON chatwoot.account_users USING btree (user_id);


--
-- Name: index_accounts_on_status; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_accounts_on_status ON chatwoot.accounts USING btree (status);


--
-- Name: index_action_mailbox_inbound_emails_uniqueness; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_action_mailbox_inbound_emails_uniqueness ON chatwoot.action_mailbox_inbound_emails USING btree (message_id, message_checksum);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON chatwoot.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON chatwoot.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON chatwoot.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON chatwoot.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_agent_bots_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_agent_bots_on_account_id ON chatwoot.agent_bots USING btree (account_id);


--
-- Name: index_applied_slas_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_applied_slas_on_account_id ON chatwoot.applied_slas USING btree (account_id);


--
-- Name: index_applied_slas_on_account_sla_policy_conversation; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_applied_slas_on_account_sla_policy_conversation ON chatwoot.applied_slas USING btree (account_id, sla_policy_id, conversation_id);


--
-- Name: index_applied_slas_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_applied_slas_on_conversation_id ON chatwoot.applied_slas USING btree (conversation_id);


--
-- Name: index_applied_slas_on_sla_policy_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_applied_slas_on_sla_policy_id ON chatwoot.applied_slas USING btree (sla_policy_id);


--
-- Name: index_articles_on_associated_article_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_articles_on_associated_article_id ON chatwoot.articles USING btree (associated_article_id);


--
-- Name: index_articles_on_author_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_articles_on_author_id ON chatwoot.articles USING btree (author_id);


--
-- Name: index_articles_on_slug; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_articles_on_slug ON chatwoot.articles USING btree (slug);


--
-- Name: index_attachments_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_attachments_on_account_id ON chatwoot.attachments USING btree (account_id);


--
-- Name: index_attachments_on_message_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_attachments_on_message_id ON chatwoot.attachments USING btree (message_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_audits_on_created_at ON chatwoot.audits USING btree (created_at);


--
-- Name: index_audits_on_request_uuid; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_audits_on_request_uuid ON chatwoot.audits USING btree (request_uuid);


--
-- Name: index_automation_rules_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_automation_rules_on_account_id ON chatwoot.automation_rules USING btree (account_id);


--
-- Name: index_campaigns_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_campaigns_on_account_id ON chatwoot.campaigns USING btree (account_id);


--
-- Name: index_campaigns_on_campaign_status; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_campaigns_on_campaign_status ON chatwoot.campaigns USING btree (campaign_status);


--
-- Name: index_campaigns_on_campaign_type; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_campaigns_on_campaign_type ON chatwoot.campaigns USING btree (campaign_type);


--
-- Name: index_campaigns_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_campaigns_on_inbox_id ON chatwoot.campaigns USING btree (inbox_id);


--
-- Name: index_campaigns_on_scheduled_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_campaigns_on_scheduled_at ON chatwoot.campaigns USING btree (scheduled_at);


--
-- Name: index_categories_on_associated_category_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_categories_on_associated_category_id ON chatwoot.categories USING btree (associated_category_id);


--
-- Name: index_categories_on_locale; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_categories_on_locale ON chatwoot.categories USING btree (locale);


--
-- Name: index_categories_on_locale_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_categories_on_locale_and_account_id ON chatwoot.categories USING btree (locale, account_id);


--
-- Name: index_categories_on_parent_category_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_categories_on_parent_category_id ON chatwoot.categories USING btree (parent_category_id);


--
-- Name: index_categories_on_slug_and_locale_and_portal_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_slug_and_locale_and_portal_id ON chatwoot.categories USING btree (slug, locale, portal_id);


--
-- Name: index_channel_api_on_hmac_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_api_on_hmac_token ON chatwoot.channel_api USING btree (hmac_token);


--
-- Name: index_channel_api_on_identifier; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_api_on_identifier ON chatwoot.channel_api USING btree (identifier);


--
-- Name: index_channel_email_on_email; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_email_on_email ON chatwoot.channel_email USING btree (email);


--
-- Name: index_channel_email_on_forward_to_email; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_email_on_forward_to_email ON chatwoot.channel_email USING btree (forward_to_email);


--
-- Name: index_channel_facebook_pages_on_page_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_channel_facebook_pages_on_page_id ON chatwoot.channel_facebook_pages USING btree (page_id);


--
-- Name: index_channel_facebook_pages_on_page_id_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_facebook_pages_on_page_id_and_account_id ON chatwoot.channel_facebook_pages USING btree (page_id, account_id);


--
-- Name: index_channel_line_on_line_channel_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_line_on_line_channel_id ON chatwoot.channel_line USING btree (line_channel_id);


--
-- Name: index_channel_sms_on_phone_number; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_sms_on_phone_number ON chatwoot.channel_sms USING btree (phone_number);


--
-- Name: index_channel_telegram_on_bot_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_telegram_on_bot_token ON chatwoot.channel_telegram USING btree (bot_token);


--
-- Name: index_channel_twilio_sms_on_account_sid_and_phone_number; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_account_sid_and_phone_number ON chatwoot.channel_twilio_sms USING btree (account_sid, phone_number);


--
-- Name: index_channel_twilio_sms_on_messaging_service_sid; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_messaging_service_sid ON chatwoot.channel_twilio_sms USING btree (messaging_service_sid);


--
-- Name: index_channel_twilio_sms_on_phone_number; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_twilio_sms_on_phone_number ON chatwoot.channel_twilio_sms USING btree (phone_number);


--
-- Name: index_channel_twitter_profiles_on_account_id_and_profile_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_twitter_profiles_on_account_id_and_profile_id ON chatwoot.channel_twitter_profiles USING btree (account_id, profile_id);


--
-- Name: index_channel_web_widgets_on_hmac_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_web_widgets_on_hmac_token ON chatwoot.channel_web_widgets USING btree (hmac_token);


--
-- Name: index_channel_web_widgets_on_website_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_web_widgets_on_website_token ON chatwoot.channel_web_widgets USING btree (website_token);


--
-- Name: index_channel_whatsapp_on_phone_number; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_channel_whatsapp_on_phone_number ON chatwoot.channel_whatsapp USING btree (phone_number);


--
-- Name: index_contact_inboxes_on_contact_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contact_inboxes_on_contact_id ON chatwoot.contact_inboxes USING btree (contact_id);


--
-- Name: index_contact_inboxes_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contact_inboxes_on_inbox_id ON chatwoot.contact_inboxes USING btree (inbox_id);


--
-- Name: index_contact_inboxes_on_inbox_id_and_source_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_contact_inboxes_on_inbox_id_and_source_id ON chatwoot.contact_inboxes USING btree (inbox_id, source_id);


--
-- Name: index_contact_inboxes_on_pubsub_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_contact_inboxes_on_pubsub_token ON chatwoot.contact_inboxes USING btree (pubsub_token);


--
-- Name: index_contact_inboxes_on_source_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contact_inboxes_on_source_id ON chatwoot.contact_inboxes USING btree (source_id);


--
-- Name: index_contacts_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_account_id ON chatwoot.contacts USING btree (account_id);


--
-- Name: index_contacts_on_account_id_and_last_activity_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_account_id_and_last_activity_at ON chatwoot.contacts USING btree (account_id, last_activity_at DESC NULLS LAST);


--
-- Name: index_contacts_on_blocked; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_blocked ON chatwoot.contacts USING btree (blocked);


--
-- Name: index_contacts_on_lower_email_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_lower_email_account_id ON chatwoot.contacts USING btree (lower((email)::text), account_id);


--
-- Name: index_contacts_on_name_email_phone_number_identifier; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_name_email_phone_number_identifier ON chatwoot.contacts USING gin (name chatwoot.gin_trgm_ops, email chatwoot.gin_trgm_ops, phone_number chatwoot.gin_trgm_ops, identifier chatwoot.gin_trgm_ops);


--
-- Name: index_contacts_on_nonempty_fields; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_nonempty_fields ON chatwoot.contacts USING btree (account_id, email, phone_number, identifier) WHERE (((email)::text <> ''::text) OR ((phone_number)::text <> ''::text) OR ((identifier)::text <> ''::text));


--
-- Name: index_contacts_on_phone_number_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_contacts_on_phone_number_and_account_id ON chatwoot.contacts USING btree (phone_number, account_id);


--
-- Name: index_conversation_participants_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversation_participants_on_account_id ON chatwoot.conversation_participants USING btree (account_id);


--
-- Name: index_conversation_participants_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversation_participants_on_conversation_id ON chatwoot.conversation_participants USING btree (conversation_id);


--
-- Name: index_conversation_participants_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversation_participants_on_user_id ON chatwoot.conversation_participants USING btree (user_id);


--
-- Name: index_conversation_participants_on_user_id_and_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_conversation_participants_on_user_id_and_conversation_id ON chatwoot.conversation_participants USING btree (user_id, conversation_id);


--
-- Name: index_conversations_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_account_id ON chatwoot.conversations USING btree (account_id);


--
-- Name: index_conversations_on_account_id_and_display_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_conversations_on_account_id_and_display_id ON chatwoot.conversations USING btree (account_id, display_id);


--
-- Name: index_conversations_on_assignee_id_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_assignee_id_and_account_id ON chatwoot.conversations USING btree (assignee_id, account_id);


--
-- Name: index_conversations_on_campaign_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_campaign_id ON chatwoot.conversations USING btree (campaign_id);


--
-- Name: index_conversations_on_contact_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_contact_id ON chatwoot.conversations USING btree (contact_id);


--
-- Name: index_conversations_on_contact_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_contact_inbox_id ON chatwoot.conversations USING btree (contact_inbox_id);


--
-- Name: index_conversations_on_first_reply_created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_first_reply_created_at ON chatwoot.conversations USING btree (first_reply_created_at);


--
-- Name: index_conversations_on_id_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_id_and_account_id ON chatwoot.conversations USING btree (account_id, id);


--
-- Name: index_conversations_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_inbox_id ON chatwoot.conversations USING btree (inbox_id);


--
-- Name: index_conversations_on_priority; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_priority ON chatwoot.conversations USING btree (priority);


--
-- Name: index_conversations_on_status_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_status_and_account_id ON chatwoot.conversations USING btree (status, account_id);


--
-- Name: index_conversations_on_status_and_priority; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_status_and_priority ON chatwoot.conversations USING btree (status, priority);


--
-- Name: index_conversations_on_team_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_team_id ON chatwoot.conversations USING btree (team_id);


--
-- Name: index_conversations_on_uuid; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_conversations_on_uuid ON chatwoot.conversations USING btree (uuid);


--
-- Name: index_conversations_on_waiting_since; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_conversations_on_waiting_since ON chatwoot.conversations USING btree (waiting_since);


--
-- Name: index_csat_survey_responses_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_csat_survey_responses_on_account_id ON chatwoot.csat_survey_responses USING btree (account_id);


--
-- Name: index_csat_survey_responses_on_assigned_agent_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_csat_survey_responses_on_assigned_agent_id ON chatwoot.csat_survey_responses USING btree (assigned_agent_id);


--
-- Name: index_csat_survey_responses_on_contact_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_csat_survey_responses_on_contact_id ON chatwoot.csat_survey_responses USING btree (contact_id);


--
-- Name: index_csat_survey_responses_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_csat_survey_responses_on_conversation_id ON chatwoot.csat_survey_responses USING btree (conversation_id);


--
-- Name: index_csat_survey_responses_on_message_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_csat_survey_responses_on_message_id ON chatwoot.csat_survey_responses USING btree (message_id);


--
-- Name: index_custom_attribute_definitions_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_custom_attribute_definitions_on_account_id ON chatwoot.custom_attribute_definitions USING btree (account_id);


--
-- Name: index_custom_filters_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_custom_filters_on_account_id ON chatwoot.custom_filters USING btree (account_id);


--
-- Name: index_custom_filters_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_custom_filters_on_user_id ON chatwoot.custom_filters USING btree (user_id);


--
-- Name: index_custom_roles_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_custom_roles_on_account_id ON chatwoot.custom_roles USING btree (account_id);


--
-- Name: index_dashboard_apps_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_dashboard_apps_on_account_id ON chatwoot.dashboard_apps USING btree (account_id);


--
-- Name: index_dashboard_apps_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_dashboard_apps_on_user_id ON chatwoot.dashboard_apps USING btree (user_id);


--
-- Name: index_data_imports_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_data_imports_on_account_id ON chatwoot.data_imports USING btree (account_id);


--
-- Name: index_email_templates_on_name_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_email_templates_on_name_and_account_id ON chatwoot.email_templates USING btree (name, account_id);


--
-- Name: index_inbox_members_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_inbox_members_on_inbox_id ON chatwoot.inbox_members USING btree (inbox_id);


--
-- Name: index_inbox_members_on_inbox_id_and_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_inbox_members_on_inbox_id_and_user_id ON chatwoot.inbox_members USING btree (inbox_id, user_id);


--
-- Name: index_inboxes_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_inboxes_on_account_id ON chatwoot.inboxes USING btree (account_id);


--
-- Name: index_inboxes_on_channel_id_and_channel_type; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_inboxes_on_channel_id_and_channel_type ON chatwoot.inboxes USING btree (channel_id, channel_type);


--
-- Name: index_inboxes_on_portal_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_inboxes_on_portal_id ON chatwoot.inboxes USING btree (portal_id);


--
-- Name: index_installation_configs_on_name; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_installation_configs_on_name ON chatwoot.installation_configs USING btree (name);


--
-- Name: index_installation_configs_on_name_and_created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_installation_configs_on_name_and_created_at ON chatwoot.installation_configs USING btree (name, created_at);


--
-- Name: index_labels_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_labels_on_account_id ON chatwoot.labels USING btree (account_id);


--
-- Name: index_labels_on_title_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_labels_on_title_and_account_id ON chatwoot.labels USING btree (title, account_id);


--
-- Name: index_macros_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_macros_on_account_id ON chatwoot.macros USING btree (account_id);


--
-- Name: index_mentions_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_mentions_on_account_id ON chatwoot.mentions USING btree (account_id);


--
-- Name: index_mentions_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_mentions_on_conversation_id ON chatwoot.mentions USING btree (conversation_id);


--
-- Name: index_mentions_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_mentions_on_user_id ON chatwoot.mentions USING btree (user_id);


--
-- Name: index_mentions_on_user_id_and_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_mentions_on_user_id_and_conversation_id ON chatwoot.mentions USING btree (user_id, conversation_id);


--
-- Name: index_messages_on_account_created_type; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_account_created_type ON chatwoot.messages USING btree (account_id, created_at, message_type);


--
-- Name: index_messages_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_account_id ON chatwoot.messages USING btree (account_id);


--
-- Name: index_messages_on_account_id_and_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_account_id_and_inbox_id ON chatwoot.messages USING btree (account_id, inbox_id);


--
-- Name: index_messages_on_additional_attributes_campaign_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_additional_attributes_campaign_id ON chatwoot.messages USING gin (((additional_attributes -> 'campaign_id'::text)));


--
-- Name: index_messages_on_content; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_content ON chatwoot.messages USING gin (content chatwoot.gin_trgm_ops);


--
-- Name: index_messages_on_conversation_account_type_created; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_conversation_account_type_created ON chatwoot.messages USING btree (conversation_id, account_id, message_type, created_at);


--
-- Name: index_messages_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_conversation_id ON chatwoot.messages USING btree (conversation_id);


--
-- Name: index_messages_on_created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_created_at ON chatwoot.messages USING btree (created_at);


--
-- Name: index_messages_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_inbox_id ON chatwoot.messages USING btree (inbox_id);


--
-- Name: index_messages_on_sender_type_and_sender_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_sender_type_and_sender_id ON chatwoot.messages USING btree (sender_type, sender_id);


--
-- Name: index_messages_on_source_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_messages_on_source_id ON chatwoot.messages USING btree (source_id);


--
-- Name: index_notes_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notes_on_account_id ON chatwoot.notes USING btree (account_id);


--
-- Name: index_notes_on_contact_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notes_on_contact_id ON chatwoot.notes USING btree (contact_id);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notes_on_user_id ON chatwoot.notes USING btree (user_id);


--
-- Name: index_notification_subscriptions_on_identifier; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_notification_subscriptions_on_identifier ON chatwoot.notification_subscriptions USING btree (identifier);


--
-- Name: index_notification_subscriptions_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notification_subscriptions_on_user_id ON chatwoot.notification_subscriptions USING btree (user_id);


--
-- Name: index_notifications_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notifications_on_account_id ON chatwoot.notifications USING btree (account_id);


--
-- Name: index_notifications_on_last_activity_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notifications_on_last_activity_at ON chatwoot.notifications USING btree (last_activity_at);


--
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON chatwoot.notifications USING btree (user_id);


--
-- Name: index_platform_app_permissibles_on_permissibles; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_platform_app_permissibles_on_permissibles ON chatwoot.platform_app_permissibles USING btree (permissible_type, permissible_id);


--
-- Name: index_platform_app_permissibles_on_platform_app_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_platform_app_permissibles_on_platform_app_id ON chatwoot.platform_app_permissibles USING btree (platform_app_id);


--
-- Name: index_portal_members_on_portal_id_and_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_portal_members_on_portal_id_and_user_id ON chatwoot.portal_members USING btree (portal_id, user_id);


--
-- Name: index_portal_members_on_user_id_and_portal_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_portal_members_on_user_id_and_portal_id ON chatwoot.portal_members USING btree (user_id, portal_id);


--
-- Name: index_portals_members_on_portal_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_portals_members_on_portal_id ON chatwoot.portals_members USING btree (portal_id);


--
-- Name: index_portals_members_on_portal_id_and_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_portals_members_on_portal_id_and_user_id ON chatwoot.portals_members USING btree (portal_id, user_id);


--
-- Name: index_portals_members_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_portals_members_on_user_id ON chatwoot.portals_members USING btree (user_id);


--
-- Name: index_portals_on_channel_web_widget_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_portals_on_channel_web_widget_id ON chatwoot.portals USING btree (channel_web_widget_id);


--
-- Name: index_portals_on_custom_domain; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_portals_on_custom_domain ON chatwoot.portals USING btree (custom_domain);


--
-- Name: index_portals_on_slug; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_portals_on_slug ON chatwoot.portals USING btree (slug);


--
-- Name: index_related_categories_on_category_id_and_related_category_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_related_categories_on_category_id_and_related_category_id ON chatwoot.related_categories USING btree (category_id, related_category_id);


--
-- Name: index_related_categories_on_related_category_id_and_category_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_related_categories_on_related_category_id_and_category_id ON chatwoot.related_categories USING btree (related_category_id, category_id);


--
-- Name: index_reporting_events_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_account_id ON chatwoot.reporting_events USING btree (account_id);


--
-- Name: index_reporting_events_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_conversation_id ON chatwoot.reporting_events USING btree (conversation_id);


--
-- Name: index_reporting_events_on_created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_created_at ON chatwoot.reporting_events USING btree (created_at);


--
-- Name: index_reporting_events_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_inbox_id ON chatwoot.reporting_events USING btree (inbox_id);


--
-- Name: index_reporting_events_on_name; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_name ON chatwoot.reporting_events USING btree (name);


--
-- Name: index_reporting_events_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_reporting_events_on_user_id ON chatwoot.reporting_events USING btree (user_id);


--
-- Name: index_resolved_contact_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_resolved_contact_account_id ON chatwoot.contacts USING btree (account_id) WHERE (((email)::text <> ''::text) OR ((phone_number)::text <> ''::text) OR ((identifier)::text <> ''::text));


--
-- Name: index_sla_events_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_events_on_account_id ON chatwoot.sla_events USING btree (account_id);


--
-- Name: index_sla_events_on_applied_sla_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_events_on_applied_sla_id ON chatwoot.sla_events USING btree (applied_sla_id);


--
-- Name: index_sla_events_on_conversation_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_events_on_conversation_id ON chatwoot.sla_events USING btree (conversation_id);


--
-- Name: index_sla_events_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_events_on_inbox_id ON chatwoot.sla_events USING btree (inbox_id);


--
-- Name: index_sla_events_on_sla_policy_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_events_on_sla_policy_id ON chatwoot.sla_events USING btree (sla_policy_id);


--
-- Name: index_sla_policies_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_sla_policies_on_account_id ON chatwoot.sla_policies USING btree (account_id);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_context ON chatwoot.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON chatwoot.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id ON chatwoot.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON chatwoot.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type ON chatwoot.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id ON chatwoot.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON chatwoot.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON chatwoot.tags USING btree (name);


--
-- Name: index_team_members_on_team_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_team_members_on_team_id ON chatwoot.team_members USING btree (team_id);


--
-- Name: index_team_members_on_team_id_and_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_team_members_on_team_id_and_user_id ON chatwoot.team_members USING btree (team_id, user_id);


--
-- Name: index_team_members_on_user_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_team_members_on_user_id ON chatwoot.team_members USING btree (user_id);


--
-- Name: index_teams_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_teams_on_account_id ON chatwoot.teams USING btree (account_id);


--
-- Name: index_teams_on_name_and_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_teams_on_name_and_account_id ON chatwoot.teams USING btree (name, account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_users_on_email ON chatwoot.users USING btree (email);


--
-- Name: index_users_on_pubsub_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_users_on_pubsub_token ON chatwoot.users USING btree (pubsub_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON chatwoot.users USING btree (reset_password_token);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON chatwoot.users USING btree (uid, provider);


--
-- Name: index_webhooks_on_account_id_and_url; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX index_webhooks_on_account_id_and_url ON chatwoot.webhooks USING btree (account_id, url);


--
-- Name: index_working_hours_on_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_working_hours_on_account_id ON chatwoot.working_hours USING btree (account_id);


--
-- Name: index_working_hours_on_inbox_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX index_working_hours_on_inbox_id ON chatwoot.working_hours USING btree (inbox_id);


--
-- Name: reporting_events__account_id__name__created_at; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX reporting_events__account_id__name__created_at ON chatwoot.reporting_events USING btree (account_id, name, created_at);


--
-- Name: taggings_idx; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON chatwoot.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX taggings_idy ON chatwoot.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: tags_name_trgm_idx; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX tags_name_trgm_idx ON chatwoot.tags USING gin (lower((name)::text) chatwoot.gin_trgm_ops);


--
-- Name: uniq_email_per_account_contact; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX uniq_email_per_account_contact ON chatwoot.contacts USING btree (email, account_id);


--
-- Name: uniq_identifier_per_account_contact; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX uniq_identifier_per_account_contact ON chatwoot.contacts USING btree (identifier, account_id);


--
-- Name: uniq_primary_actor_per_account_notifications; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX uniq_primary_actor_per_account_notifications ON chatwoot.notifications USING btree (primary_actor_type, primary_actor_id);


--
-- Name: uniq_secondary_actor_per_account_notifications; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX uniq_secondary_actor_per_account_notifications ON chatwoot.notifications USING btree (secondary_actor_type, secondary_actor_id);


--
-- Name: uniq_user_id_per_account_id; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX uniq_user_id_per_account_id ON chatwoot.account_users USING btree (account_id, user_id);


--
-- Name: unique_permissibles_index; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE UNIQUE INDEX unique_permissibles_index ON chatwoot.platform_app_permissibles USING btree (platform_app_id, permissible_id, permissible_type);


--
-- Name: user_index; Type: INDEX; Schema: chatwoot; Owner: -
--

CREATE INDEX user_index ON chatwoot.audits USING btree (user_id, user_type);


--
-- Name: accounts accounts_after_insert_row_tr; Type: TRIGGER; Schema: chatwoot; Owner: -
--

CREATE TRIGGER accounts_after_insert_row_tr AFTER INSERT ON chatwoot.accounts FOR EACH ROW EXECUTE FUNCTION chatwoot.accounts_after_insert_row_tr();


--
-- Name: accounts camp_dpid_before_insert; Type: TRIGGER; Schema: chatwoot; Owner: -
--

CREATE TRIGGER camp_dpid_before_insert AFTER INSERT ON chatwoot.accounts FOR EACH ROW EXECUTE FUNCTION chatwoot.camp_dpid_before_insert();


--
-- Name: campaigns campaigns_before_insert_row_tr; Type: TRIGGER; Schema: chatwoot; Owner: -
--

CREATE TRIGGER campaigns_before_insert_row_tr BEFORE INSERT ON chatwoot.campaigns FOR EACH ROW EXECUTE FUNCTION chatwoot.campaigns_before_insert_row_tr();


--
-- Name: conversations conversations_before_insert_row_tr; Type: TRIGGER; Schema: chatwoot; Owner: -
--

CREATE TRIGGER conversations_before_insert_row_tr BEFORE INSERT ON chatwoot.conversations FOR EACH ROW EXECUTE FUNCTION chatwoot.conversations_before_insert_row_tr();


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES chatwoot.active_storage_blobs(id);


--
-- Name: inboxes fk_rails_a1f654bf2d; Type: FK CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.inboxes
    ADD CONSTRAINT fk_rails_a1f654bf2d FOREIGN KEY (portal_id) REFERENCES chatwoot.portals(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: chatwoot; Owner: -
--

ALTER TABLE ONLY chatwoot.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES chatwoot.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO chatwoot, public;

INSERT INTO "schema_migrations" (version) VALUES
('20230426130150'),
('20230503101201'),
('20230509101256'),
('20230510060828'),
('20230510113208'),
('20230515051424'),
('20230523104139'),
('20230525085402'),
('20230608040738'),
('20230612103936'),
('20230614044633'),
('20230620132319'),
('20230620212340'),
('20230706090122'),
('20230714054138'),
('20230727065605'),
('20230801180936'),
('20230905060223'),
('20231011041615'),
('20231013072802'),
('20231114111614'),
('20231129091149'),
('20231201014644'),
('20231211010807'),
('20231219000743'),
('20231219073832'),
('20231223033019'),
('20231223040257'),
('20240124054340'),
('20240124084032'),
('20240129080827'),
('20240131040316'),
('20240207103014'),
('20240213131252'),
('20240215065844'),
('20240216055809'),
('20240306201954'),
('20240319062553'),
('20240322071629'),
('20240415210313'),
('20240515201632'),
('20240516003531'),
('20240726220747'),
('20240923215335');


