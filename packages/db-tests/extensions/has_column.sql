
begin;

-- has_column( schema, table, column )
CREATE OR REPLACE FUNCTION has_column ( NAME, NAME, NAME )
RETURNS TEXT AS $$
    SELECT ok( _cexists( $1, $2, $3 ), 'Column ' || quote_ident($1) || '.' || quote_ident($2) || '.' || quote_ident($3) || ' should exist' );
$$ LANGUAGE SQL;

commit;
