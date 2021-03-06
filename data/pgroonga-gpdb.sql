-- NOTE: This isn't worked yet.

SET search_path = public;

DROP SCHEMA IF EXISTS pgroonga CASCADE;
CREATE SCHEMA pgroonga;

CREATE FUNCTION pgroonga.table_name(indexName cstring)
	RETURNS cstring
	AS '$libdir/pgroonga', 'pgroonga_table_name'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.command(groongaCommand text)
	RETURNS text
	AS '$libdir/pgroonga', 'pgroonga_command'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.snippet_html(target text, keywords text[])
	RETURNS text[]
	AS '$libdir/pgroonga', 'pgroonga_snippet_html'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.match_term(target text, term text)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_term_text'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_term(target text[], term text)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_term_text_array'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_term(target varchar, term varchar)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_term_varchar'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_term(target varchar[], term varchar)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_term_varchar_array'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.match_term,
	LEFTARG = text,
	RIGHTARG = text
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.match_term,
	LEFTARG = text[],
	RIGHTARG = text
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.match_term,
	LEFTARG = varchar,
	RIGHTARG = varchar
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.match_term,
	LEFTARG = varchar[],
	RIGHTARG = varchar
);


CREATE FUNCTION pgroonga.match_query(text, text)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_query_text'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_query(text[], text)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_query_text_array'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_query(varchar, varchar)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_query_varchar'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match_query,
	LEFTARG = text,
	RIGHTARG = text
);

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match_query,
	LEFTARG = text[],
	RIGHTARG = text
);

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match_query,
	LEFTARG = varchar,
	RIGHTARG = varchar
);


CREATE FUNCTION pgroonga.match_regexp(text, text)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_regexp_text'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match_regexp(varchar, varchar)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_match_regexp_varchar'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE OPERATOR @~ (
	PROCEDURE = pgroonga.match_regexp,
	LEFTARG = text,
	RIGHTARG = text
);

CREATE OPERATOR @~ (
	PROCEDURE = pgroonga.match_regexp,
	LEFTARG = varchar,
	RIGHTARG = varchar
);


CREATE FUNCTION pgroonga.insert(internal)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_insert'
	LANGUAGE C;
CREATE FUNCTION pgroonga.beginscan(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_beginscan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.gettuple(internal)
	RETURNS bool
	AS '$libdir/pgroonga', 'pgroonga_gettuple'
	LANGUAGE C;
CREATE FUNCTION pgroonga.rescan(internal)
	RETURNS void
	AS '$libdir/pgroonga', 'pgroonga_rescan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.endscan(internal)
	RETURNS void
	AS '$libdir/pgroonga', 'pgroonga_endscan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.build(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_build'
	LANGUAGE C;
CREATE FUNCTION pgroonga.buildempty(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_buildempty'
	LANGUAGE C;
CREATE FUNCTION pgroonga.bulkdelete(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_bulkdelete'
	LANGUAGE C;
CREATE FUNCTION pgroonga.vacuumcleanup(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_vacuumcleanup'
	LANGUAGE C;
CREATE FUNCTION pgroonga.canreturn(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_canreturn'
	LANGUAGE C;
CREATE FUNCTION pgroonga.costestimate(internal)
	RETURNS internal
	AS '$libdir/pgroonga', 'pgroonga_costestimate'
	LANGUAGE C;

DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
INSERT INTO pg_catalog.pg_am VALUES(
	'pgroonga',	-- amname
	11,		-- amstrategies
	0,		-- amsupport
	0,		-- amorderstrategy
	true,		-- amcanunique
	true,		-- amcanmulticol
	true,		-- amoptionalkey
	false,		-- amsearchnulls
	false,		-- amstorage
	true,		-- amclusterable
	false,		-- amcanshrink
	'pgroonga.insert',	-- aminsert
	'pgroonga.beginscan',	-- ambeginscan
	'pgroonga.gettuple',	-- amgettuple
	0,	-- amgetmulti
	'pgroonga.rescan',	-- amrescan
	'pgroonga.endscan',	-- amendscan
	0,		-- ammarkpos,
	0,		-- amrestrpos,
	'pgroonga.build',	-- ambuild
	'pgroonga.bulkdelete',	-- ambulkdelete
	'pgroonga.vacuumcleanup',	-- amvacuumcleanup
	'pgroonga.costestimate',	-- amcostestimate
	0	-- amoptions
);

CREATE OPERATOR CLASS pgroonga.text_full_text_search_ops DEFAULT FOR TYPE text
	USING pgroonga AS
		OPERATOR 6 pg_catalog.~~,
		OPERATOR 7 pg_catalog.~~*,
		OPERATOR 8 %%,
		OPERATOR 9 @@;

CREATE OPERATOR CLASS pgroonga.text_array_full_text_search_ops
	DEFAULT
	FOR TYPE text[]
	USING pgroonga AS
		OPERATOR 8 %% (text[], text),
		OPERATOR 9 @@ (text[], text);

CREATE OPERATOR CLASS pgroonga.varchar_full_text_search_ops FOR TYPE varchar
	USING pgroonga AS
		OPERATOR 8 %%,
		OPERATOR 9 @@;

CREATE OPERATOR CLASS pgroonga.varchar_ops DEFAULT FOR TYPE varchar
	USING pgroonga AS
		OPERATOR 1 < (text, text),
		OPERATOR 2 <= (text, text),
		OPERATOR 3 = (text, text),
		OPERATOR 4 >= (text, text),
		OPERATOR 5 > (text, text);

CREATE OPERATOR CLASS pgroonga.varchar_array_ops
	DEFAULT
	FOR TYPE varchar[]
	USING pgroonga AS
		OPERATOR 8 %% (varchar[], varchar);

CREATE OPERATOR CLASS pgroonga.bool_ops DEFAULT FOR TYPE bool
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.int2_ops DEFAULT FOR TYPE int2
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.int4_ops DEFAULT FOR TYPE int4
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.int8_ops DEFAULT FOR TYPE int8
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.float4_ops DEFAULT FOR TYPE float4
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.float8_ops DEFAULT FOR TYPE float8
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.timestamp_ops DEFAULT FOR TYPE timestamp
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.timestamptz_ops DEFAULT FOR TYPE timestamptz
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >;

CREATE OPERATOR CLASS pgroonga.text_regexp_ops FOR TYPE text
	USING pgroonga AS
		OPERATOR 6 pg_catalog.~~,
		OPERATOR 7 pg_catalog.~~*,
		OPERATOR 10 @~;

CREATE OPERATOR CLASS pgroonga.varchar_regexp_ops FOR TYPE varchar
	USING pgroonga AS
		OPERATOR 10 @~;
