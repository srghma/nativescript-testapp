module PostgreSQLExtra where

import Protolude

import Control.Monad.Reader (ask)
import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..))
import Database.PostgreSQL as PostgreSQL
import Data.Array as Array

throwString :: ∀ t6 t7. MonadThrow Error t6 ⇒ String → t6 t7
throwString = error >>> throwError

throwPgError :: ∀ t12 t13 t15. MonadThrow Error t13 ⇒ Show t15 ⇒ t15 → t13 t12
throwPgError e = throwString $ "PgError: " <> show e

----------

execute
  :: ∀ i o m r
   . ToSQLRow i
  => MonadAff m
  => Connection
  -> Query i o
  -> i
  -> m (Maybe PGError)
execute connection querySql values = liftAff $ PostgreSQL.execute connection querySql values

executeOrThrow
  :: ∀ t113 t118 t119
  . ToSQLRow t119
  ⇒ MonadAff t113
  ⇒ MonadThrow Error t113
  ⇒ Connection
  -> Query t119 t118
  -> t119
  -> t113 Unit
executeOrThrow connection querySql values = execute connection querySql values >>= maybe (pure unit) throwPgError

----------

query connection querySql values = liftAff $ PostgreSQL.query connection querySql values

queryOrThrow connection querySql values = query connection querySql values >>= either throwPgError pure

queryHeadOrThrow connection querySql values = queryOrThrow connection querySql values >>= Array.head >>>
  maybe (throwString "queryHeadOrThrow: expected Array to be non-empty") pure

----------

scalar connection querySql values = liftAff $ PostgreSQL.scalar connection querySql values

scalarOrThrow connection querySql values = scalar connection querySql values >>= either throwPgError pure

scalarOrThrowRequired connection querySql values = scalarOrThrow connection querySql values >>= maybe (throwString "scalarOrThrowRequired: expected Just") pure

----------

command connection querySql values = liftAff $ PostgreSQL.command connection querySql values

commandOrThrow connection querySql values = command connection querySql values >>= either throwPgError pure
