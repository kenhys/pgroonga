SET search_path = public;

CREATE SCHEMA pgroonga;

CREATE FUNCTION pgroonga.score("row" record)
	RETURNS float8
	AS 'MODULE_PATHNAME', 'pgroonga_score'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.table_name(indexName cstring)
	RETURNS cstring
	AS 'MODULE_PATHNAME', 'pgroonga_table_name'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.command(groongaCommand text)
	RETURNS text
	AS 'MODULE_PATHNAME', 'pgroonga_command'
	LANGUAGE C
	VOLATILE
	STRICT;

CREATE FUNCTION pgroonga.contain(text, text)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_contain_text'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.contain(target text[], query text)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_contain_text_array'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.contain(varchar, varchar)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_contain_varchar'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.contain(target varchar[], query varchar)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_contain_varchar_array'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.contain,
	LEFTARG = text,
	RIGHTARG = text
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.contain,
	LEFTARG = text[],
	RIGHTARG = text
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.contain,
	LEFTARG = varchar,
	RIGHTARG = varchar
);

CREATE OPERATOR %% (
	PROCEDURE = pgroonga.contain,
	LEFTARG = varchar[],
	RIGHTARG = varchar
);


CREATE FUNCTION pgroonga.match(text, text)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_match'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match(text[], text)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_match'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE FUNCTION pgroonga.match(varchar, varchar)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_match'
	LANGUAGE C
	IMMUTABLE
	STRICT;

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match,
	LEFTARG = text,
	RIGHTARG = text
);

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match,
	LEFTARG = text[],
	RIGHTARG = text
);

CREATE OPERATOR @@ (
	PROCEDURE = pgroonga.match,
	LEFTARG = varchar,
	RIGHTARG = varchar
);


CREATE FUNCTION pgroonga.insert(internal)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_insert'
	LANGUAGE C;
CREATE FUNCTION pgroonga.beginscan(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_beginscan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.gettuple(internal)
	RETURNS bool
	AS 'MODULE_PATHNAME', 'pgroonga_gettuple'
	LANGUAGE C;
CREATE FUNCTION pgroonga.getbitmap(internal)
	RETURNS bigint
	AS 'MODULE_PATHNAME', 'pgroonga_getbitmap'
	LANGUAGE C;
CREATE FUNCTION pgroonga.rescan(internal)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_rescan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.endscan(internal)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_endscan'
	LANGUAGE C;
CREATE FUNCTION pgroonga.build(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_build'
	LANGUAGE C;
CREATE FUNCTION pgroonga.buildempty(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_buildempty'
	LANGUAGE C;
CREATE FUNCTION pgroonga.bulkdelete(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_bulkdelete'
	LANGUAGE C;
CREATE FUNCTION pgroonga.vacuumcleanup(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_vacuumcleanup'
	LANGUAGE C;
CREATE FUNCTION pgroonga.costestimate(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_costestimate'
	LANGUAGE C;
CREATE FUNCTION pgroonga.options(internal)
	RETURNS internal
	AS 'MODULE_PATHNAME', 'pgroonga_options'
	LANGUAGE C;

CREATE FUNCTION pgroonga.get_text(internal, internal, text)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_text'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_text_array(internal, internal, text[])
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_text_array'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_varchar(internal, internal, varchar)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_varchar'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_varchar_array(internal, internal, varchar[])
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_varchar_array'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_bool(internal, internal, bool)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_bool'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_int2(internal, internal, int2)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_int2'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_int4(internal, internal, int4)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_int4'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_int8(internal, internal, int8)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_int8'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_float4(internal, internal, float4)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_float4'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_float8(internal, internal, float8)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_float8'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_timestamp(internal, internal, timestamp)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_timestamp'
	LANGUAGE C;
CREATE FUNCTION pgroonga.get_timestamptz(internal, internal, timestamptz)
	RETURNS void
	AS 'MODULE_PATHNAME', 'pgroonga_get_timestamptz'
	LANGUAGE C;

DELETE FROM pg_catalog.pg_am WHERE amname = 'pgroonga';
INSERT INTO pg_catalog.pg_am VALUES(
	'pgroonga',	-- amname
	8,		-- amstrategies
	3,		-- amsupport
	true,		-- amcanorder
	true,		-- amcanorderbyop
	true,		-- amcanbackward
	true,		-- amcanunique
	true,		-- amcanmulticol
	true,		-- amoptionalkey
	true,		-- amsearcharray
	false,		-- amsearchnulls
	false,		-- amstorage
	true,		-- amclusterable
	false,		-- ampredlocks
	0,		-- amkeytype
	'pgroonga.insert',	-- aminsert
	'pgroonga.beginscan',	-- ambeginscan
	'pgroonga.gettuple',	-- amgettuple
	'pgroonga.getbitmap',	-- amgetbitmap
	'pgroonga.rescan',	-- amrescan
	'pgroonga.endscan',	-- amendscan
	0,		-- ammarkpos,
	0,		-- amrestrpos,
	'pgroonga.build',	-- ambuild
	'pgroonga.buildempty',	-- ambuildempty
	'pgroonga.bulkdelete',	-- ambulkdelete
	'pgroonga.vacuumcleanup',	-- amvacuumcleanup
	0,		-- amcanreturn
	'pgroonga.costestimate',	-- amcostestimate
	'pgroonga.options'	-- amoptions
);

CREATE OPERATOR CLASS pgroonga.text_full_text_search_ops DEFAULT FOR TYPE text
	USING pgroonga AS
		OPERATOR 6 pg_catalog.~~,
		OPERATOR 7 %%,
		OPERATOR 8 @@,
		FUNCTION 1 pgroonga.get_text(internal, internal, text),
		FUNCTION 2 pgroonga.get_text(internal, internal, text);

CREATE OPERATOR CLASS pgroonga.text_array_full_text_search_ops
	DEFAULT
	FOR TYPE text[]
	USING pgroonga AS
		OPERATOR 7 %% (text[], text),
		OPERATOR 8 @@ (text[], text),
		FUNCTION 1 pgroonga.get_text_array(internal, internal, text[]),
		FUNCTION 2 pgroonga.get_text(internal, internal, text);

CREATE OPERATOR CLASS pgroonga.varchar_full_text_search_ops FOR TYPE varchar
	USING pgroonga AS
		OPERATOR 7 %%,
		OPERATOR 8 @@,
		FUNCTION 1 pgroonga.get_varchar(internal, internal, varchar),
		FUNCTION 2 pgroonga.get_varchar(internal, internal, varchar);

CREATE OPERATOR CLASS pgroonga.varchar_ops DEFAULT FOR TYPE varchar
	USING pgroonga AS
		OPERATOR 1 < (text, text),
		OPERATOR 2 <= (text, text),
		OPERATOR 3 = (text, text),
		OPERATOR 4 >= (text, text),
		OPERATOR 5 > (text, text),
		FUNCTION 1 pgroonga.get_varchar(internal, internal, varchar),
		FUNCTION 2 pgroonga.get_varchar(internal, internal, varchar);

CREATE OPERATOR CLASS pgroonga.varchar_array_ops
	DEFAULT
	FOR TYPE varchar[]
	USING pgroonga AS
		OPERATOR 7 %% (varchar[], varchar),
		FUNCTION 1 pgroonga.get_varchar_array(internal, internal, varchar[]),
		FUNCTION 2 pgroonga.get_varchar(internal, internal, varchar);

CREATE OPERATOR CLASS pgroonga.bool_ops DEFAULT FOR TYPE bool
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_bool(internal, internal, bool),
		FUNCTION 2 pgroonga.get_bool(internal, internal, bool);

CREATE OPERATOR CLASS pgroonga.int2_ops DEFAULT FOR TYPE int2
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_int2(internal, internal, int2),
		FUNCTION 2 pgroonga.get_int2(internal, internal, int2);

CREATE OPERATOR CLASS pgroonga.int4_ops DEFAULT FOR TYPE int4
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_int4(internal, internal, int4),
		FUNCTION 2 pgroonga.get_int4(internal, internal, int4);

CREATE OPERATOR CLASS pgroonga.int8_ops DEFAULT FOR TYPE int8
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_int8(internal, internal, int8),
		FUNCTION 2 pgroonga.get_int8(internal, internal, int8);

CREATE OPERATOR CLASS pgroonga.float4_ops DEFAULT FOR TYPE float4
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_float4(internal, internal, float4),
		FUNCTION 2 pgroonga.get_float4(internal, internal, float4);

CREATE OPERATOR CLASS pgroonga.float8_ops DEFAULT FOR TYPE float8
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_float8(internal, internal, float8),
		FUNCTION 2 pgroonga.get_float8(internal, internal, float8);

CREATE OPERATOR CLASS pgroonga.timestamp_ops DEFAULT FOR TYPE timestamp
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_timestamp(internal, internal, timestamp),
		FUNCTION 2 pgroonga.get_timestamp(internal, internal, timestamp);

CREATE OPERATOR CLASS pgroonga.timestamptz_ops DEFAULT FOR TYPE timestamptz
	USING pgroonga AS
		OPERATOR 1 <,
		OPERATOR 2 <=,
		OPERATOR 3 =,
		OPERATOR 4 >=,
		OPERATOR 5 >,
		FUNCTION 1 pgroonga.get_timestamptz(internal, internal, timestamptz),
		FUNCTION 2 pgroonga.get_timestamptz(internal, internal, timestamptz);
