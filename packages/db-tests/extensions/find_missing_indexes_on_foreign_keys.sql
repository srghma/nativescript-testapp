
-- This source code may reproduce and may modify the following components:
-- Name         - fk_no_index.sql
-- Link to file - https://github.com/pgexperts/pgx_scripts/blob/master/indexes/fk_no_index.sql
-- Copyright    - 2014, PostgreSQL Experts, Inc. and Additional Contributors
-- License      - Custom license (https://github.com/pgexperts/pgx_scripts/blob/master/LICENSE)
-- Copyright (c) 2014, PostgreSQL Experts, Inc.
--     and Additional Contributors (see README)
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice, this
--   list of conditions and the following disclaimer.
--
-- * Redistributions in binary form must reproduce the above copyright notice,
--   this list of conditions and the following disclaimer in the documentation
--   and/or other materials provided with the distribution.
--
-- * Neither the name of pgx_scripts nor the names of its
--   contributors may be used to endorse or promote products derived from
--   this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/*
  Differende from https://github.com/pgexperts/pgx_scripts/blob/master/indexes/fk_no_index.sql:
  - removed WHERE clause to include tables that have size less than 9GB
*/

/*
  When you want to add an index:

  PostgreSQL automatically creates an index for each unique constraint and primary key constraint to enforce uniqueness.
  But it will not create index for foreign key automatically.

  To do this you have to make `CREATE INDEX index_name ON column;` query

  You want to create index on foreign key if:
  - table have many object in it
  - table have `ON UPDATE CASCADE` or `ON DELETE CASCADE`

  You don't want to create index on foreign key if:
  - there already exists compound index (like [user_id, user_account_id]), in this case index on user_id column is redundant
*/

begin;

-- TODO: derive return type automatically
-- https://stackoverflow.com/questions/11740256/refactor-a-pl-pgsql-function-to-return-the-output-of-various-select-queries/11751557#11751557

CREATE OR REPLACE FUNCTION find_missing_indexes_on_foreign_keys ()
RETURNS TABLE (
  schema_name name,
  table_name  name,
  fk_name     name,
  issue       text,
  parent_name name
) AS $$
  WITH fk_actions ( code, action ) AS (
      VALUES ( 'a', 'error' ),
          ( 'r', 'restrict' ),
          ( 'c', 'cascade' ),
          ( 'n', 'set null' ),
          ( 'd', 'set default' )
  ),
  fk_list AS (
      SELECT pg_constraint.oid as fkoid, conrelid, confrelid as parentid,
          conname, relname, nspname,
          fk_actions_update.action as update_action,
          fk_actions_delete.action as delete_action,
          conkey as key_cols
      FROM pg_constraint
          JOIN pg_class ON conrelid = pg_class.oid
          JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
          JOIN fk_actions AS fk_actions_update ON confupdtype = fk_actions_update.code
          JOIN fk_actions AS fk_actions_delete ON confdeltype = fk_actions_delete.code
      WHERE contype = 'f'
  ),
  fk_attributes AS (
      SELECT fkoid, conrelid, attname, attnum
      FROM fk_list
          JOIN pg_attribute
              ON conrelid = attrelid
              AND attnum = ANY( key_cols )
      ORDER BY fkoid, attnum
  ),
  fk_cols_list AS (
      SELECT fkoid, array_agg(attname) as cols_list
      FROM fk_attributes
      GROUP BY fkoid
  ),
  index_list AS (
      SELECT indexrelid as indexid,
          pg_class.relname as indexname,
          indrelid,
          indkey,
          indpred is not null as has_predicate,
          pg_get_indexdef(indexrelid) as indexdef
      FROM pg_index
          JOIN pg_class ON indexrelid = pg_class.oid
      WHERE indisvalid
  ),
  fk_index_match AS (
      SELECT fk_list.*,
          indexid,
          indexname,
          indkey::int[] as indexatts,
          has_predicate,
          indexdef,
          array_length(key_cols, 1) as fk_colcount,
          array_length(indkey,1) as index_colcount,
          round(pg_relation_size(conrelid)/(1024^2)::numeric) as table_mb,
          cols_list
      FROM fk_list
          JOIN fk_cols_list USING (fkoid)
          LEFT OUTER JOIN index_list
              ON conrelid = indrelid
              AND (indkey::int2[])[0:(array_length(key_cols,1) -1)] @> key_cols
  ),
  fk_perfect_match AS (
      SELECT fkoid
      FROM fk_index_match
      WHERE (index_colcount - 1) <= fk_colcount
          AND NOT has_predicate
          AND indexdef LIKE '%USING btree%'
  ),
  fk_index_check AS (
      SELECT 'no index' as issue, *, 1 as issue_sort
      FROM fk_index_match
      WHERE indexid IS NULL
      UNION ALL
      SELECT 'questionable index' as issue, *, 2
      FROM fk_index_match
      WHERE indexid IS NOT NULL
          AND fkoid NOT IN (
              SELECT fkoid
              FROM fk_perfect_match)
  ),
  parent_table_stats AS (
      SELECT fkoid, tabstats.relname as parent_name,
          (n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd) as parent_writes,
          round(pg_relation_size(parentid)/(1024^2)::numeric) as parent_mb
      FROM pg_stat_user_tables AS tabstats
          JOIN fk_list
              ON relid = parentid
  ),
  fk_table_stats AS (
      SELECT fkoid,
          (n_tup_ins + n_tup_upd + n_tup_del + n_tup_hot_upd) as writes,
          seq_scan as table_scans
      FROM pg_stat_user_tables AS tabstats
          JOIN fk_list
              ON relid = conrelid
  )
  SELECT
    nspname as schema_name,
    relname as table_name,
    conname as fk_name,
    issue,
    parent_name
  FROM fk_index_check
      JOIN parent_table_stats USING (fkoid)
      JOIN fk_table_stats USING (fkoid)
  ORDER BY issue_sort, table_mb DESC, table_name, fk_name;
$$ LANGUAGE SQL;

commit;
