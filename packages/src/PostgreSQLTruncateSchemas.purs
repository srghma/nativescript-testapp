module PostgreSQLTruncateSchemas where

import Protolude

import Data.String as String
import Database.PostgreSQL as PostgreSQL

truncateTables :: PostgreSQL.Connection -> Array (Tuple String String) -> Aff Unit
truncateTables connection tables =
  PostgreSQL.execute connection
    ( PostgreSQL.Query
    $ String.joinWith "\n"
    $ map (\(Tuple schema table) -> "TRUNCATE TABLE " <> quote schema <> "." <> quote table <> " RESTART IDENTITY CASCADE;") tables
    )
    PostgreSQL.Row0
    >>= maybe (pure unit) (\e -> throwError $ error $ "[truncateTables] PgError: " <> show e)
  where
    quote x = "\"" <> x <> "\""

truncateTablesInSchemas :: PostgreSQL.Connection -> Array String -> Aff Unit
truncateTablesInSchemas connection schemas =
  PostgreSQL.execute connection
    (PostgreSQL.Query $ String.joinWith "\n"
      [ """
        DO
        $func$
        BEGIN
          EXECUTE
          (
            SELECT 'TRUNCATE TABLE ' || string_agg(format('%I.%I', table_schema, table_name), ', ') || ' RESTART IDENTITY CASCADE'
            FROM information_schema.tables
        """
      , "WHERE table_schema IN (" <> (String.joinWith ", " $ map squote schemas) <> ")"
      , """
            AND table_type = 'BASE TABLE'
          );
        END
        $func$;
        """
      ]
    ) PostgreSQL.Row0
    >>= maybe (pure unit) (\e -> throwError $ error $ "[truncateSchemas] PgError: " <> show e)
  where
    squote x = "\'" <> x <> "\'"
