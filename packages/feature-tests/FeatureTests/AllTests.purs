module FeatureTests.AllTests where

import Protolude
import Test.Spec (SpecT, describe)
import Data.Identity
import FeatureTests.FeatureTestSpec
import FeatureTests.Tests.Login.SuccessSpec as FeatureTests.Tests.Login.SuccessSpec
-- | import FeatureTests.Tests.Login.ErrorNotConfirmedSpec as FeatureTests.Tests.Login.ErrorNotConfirmedSpec
import FeatureTests.Tests.Register.SuccessSpec as FeatureTests.Tests.Register.SuccessSpec

allTests :: SpecT Aff FeatureSpecConfig Identity Unit
allTests = do
  describe "login" do
    it "success" FeatureTests.Tests.Login.SuccessSpec.spec
    -- | it "error not confirmed" FeatureTests.Tests.Login.ErrorNotConfirmedSpec.spec
  describe "register" do
    itOnly "success" FeatureTests.Tests.Register.SuccessSpec.spec
