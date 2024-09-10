module FeatureTests.Tests.Register.SuccessSpec where

import Control.Monad.Error.Class
import Control.Monad.Reader.Trans
import Control.Monad.Rec.Class
import Data.Identity
import Data.Maybe
import Data.Time.Duration
import Effect
import Effect.Aff
import Effect.Class
import FeatureTests.FeatureTestSpec
import FeatureTests.FeatureTestSpecUtils.AffRetry
import FeatureTests.FeatureTestSpecUtils.Db
import FeatureTests.FeatureTestSpecUtils.DebuggingAndTdd
import FeatureTests.FeatureTestSpecUtils.EmailAVar
import FeatureTests.FeatureTestSpecUtils.GoClientRoute
import FeatureTests.FeatureTestSpecUtils.LunaparkUtils
import LunaparkExtra
import NextjsApp.Route
import Protolude
import SpecAssertsExtra
import Test.Spec
import Unsafe.Coerce

import CSS as CSS
import CSS.Elements as CSS.Elements
import Data.Argonaut as Json
import Data.Argonaut.Decode as Json
import Data.String (Pattern(..), contains)
import Database.PostgreSQL as PostgreSQL
import Effect.AVar (AVar)
import Effect.Aff.AVar as AVar
import Effect.Aff.Retry as AffRetry
import Effect.Ref as Ref
import Faker as Faker
import Faker.Lorem as Faker.Lorem
import Faker.Name as Faker.Name
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)
import JSDOM as JSDOM
import Lunapark as Lunapark
import Lunapark.Endpoint (EndpointPart(..))
import Lunapark.Types as Lunapark
import Node.Encoding as Node.Encoding
import Node.Process as Node.Process
import Node.ReadLine as Node.ReadLine
import Node.Stream as Node.Stream
import Test.Spec.Assertions (fail, shouldContain, shouldEqual)
import Web.DOM.Document as Web.DOM.Document
import Web.DOM.Node as Web.DOM.Node
import Web.DOM.NonElementParentNode as Web.DOM.NonElementParentNode
import Web.DOM.ParentNode as Web.DOM.ParentNode
import Web.HTML.HTMLDocument as Web.HTML.HTMLDocument
import Web.HTML.HTMLLinkElement as Web.HTML.HTMLLinkElement
import Web.HTML.Window as Web.HTML.Window

usernameXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="username"]"""

emailXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="email"]"""

passwordXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="password"]"""

passwordConfirmationXpath = Lunapark.ByXPath """//div[@role="form"]//input[@aria-labelledby="passwordConfirmation"]"""

spec :: ReaderT FeatureTestEnv Aff Unit
spec = do
  let
    user =
      { username: "username1"
      , password: "userpassword1"
      , email: "useremail1@mail.com"
      }

  goClientRoute route__Register

  runLunapark $ inputField usernameXpath user.username
  waitForInputValueToEqual usernameXpath user.username

  runLunapark $ inputField emailXpath user.email
  waitForInputValueToEqual emailXpath user.email

  runLunapark $ inputField passwordXpath user.password
  waitForInputValueToEqual passwordXpath user.password

  runLunapark $ inputField passwordConfirmationXpath user.password
  waitForInputValueToEqual passwordConfirmationXpath user.password

  -- TODO: inputtig second time because of some ...
  runLunapark $ inputField usernameXpath user.username
  waitForInputValueToEqual usernameXpath user.username

  ( runLunapark $
    (Lunapark.findElement $ Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= \element -> Lunapark.getProperty element "disabled"
  ) >>= \json -> do
     boolean <- (Json.decodeJson json :: Either Json.JsonDecodeError Boolean) # either (throwError <<< error <<< Json.printJsonDecodeError) pure
     boolean `shouldEqual` false

  runLunapark $
    Lunapark.findElement (Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= Lunapark.clickElement

  -- TODO: hack, probalby because it is still validating
  void $ try $ runLunapark $
    Lunapark.findElement (Lunapark.ByXPath """//div[@role="form"]//button[text()="Submit"]""")
    >>= Lunapark.clickElement

  retryAction $
    ( getCurrentRoute
      >>= \mRoute -> mRoute `shouldEqual` Just route__Secret
    )

  ( runLunapark $
    (Lunapark.findElement $ Lunapark.ByCss $ CSS.Elements.body)
    >>= Lunapark.getText
  ) >>= \text -> text `shouldContainString` Pattern "You are on secret page"

  email <- waitForEmail

  traceM email.text

  (emailDomLink :: Web.HTML.HTMLLinkElement.HTMLLinkElement) <- liftEffect $
    JSDOM.jsdom email.text JSDOM.defaultConstructorOptions
    >>= JSDOM.window
    >>= JSDOM.document
    <#> Web.DOM.Document.toParentNode
    >>= Web.DOM.ParentNode.querySelector (Web.DOM.ParentNode.QuerySelector "a")
    >>= maybe (throwError $ error $ "cannot find a") pure
    -- TODO: it's anchor https://github.com/purescript-web/purescript-web-html/issues/8
    <#> unsafeCoerce
    -- | <#> Web.HTML.HTMLAnchorElement.fromElement
    -- | >>= maybe (throwError $ error $ "cannot find convert to HTMLAnchorElement") pure

  traceM emailDomLink

  liftEffect $ Web.HTML.HTMLLinkElement.href emailDomLink >>= \x -> x `shouldEqual` "asdf"
  -- | liftEffect $ Web.HTML.HTMLLinkElement.text emailDomLink >>= \x -> x `shouldEqual` "asdf"

  pressEnterToContinue
