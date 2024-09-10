module FeatureTests.FeatureTestSpecUtils.Db where

import Protolude

import Control.Monad.Reader (ask)
import Data.Exists (Exists)
import Data.Functor.Variant (FProxy(..))
import Database.PostgreSQL (class FromSQLRow, class FromSQLValue, class ToSQLRow, Connection, PGError, Query(..), Row1(..))
import Database.PostgreSQL as PostgreSQL
import PostgreSQLExtra as PostgreSQLExtra

liftToConfig f x y = ask >>= \config -> f config.dbConnection x y

------------

execute = liftToConfig PostgreSQLExtra.execute

executeOrThrow = liftToConfig PostgreSQLExtra.executeOrThrow

----------

query = liftToConfig PostgreSQLExtra.query

queryOrThrow = liftToConfig PostgreSQLExtra.queryOrThrow

----------

scalar = liftToConfig PostgreSQLExtra.scalar

scalarOrThrow = liftToConfig PostgreSQLExtra.scalarOrThrow

scalarOrThrowRequired = liftToConfig PostgreSQLExtra.scalarOrThrowRequired

----------

command = liftToConfig PostgreSQLExtra.command

commandOrThrow = liftToConfig PostgreSQLExtra.commandOrThrow
