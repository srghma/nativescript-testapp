module FeatureTests.FeatureTestSpecUtils.LunaparkUtils where

import Protolude
import FeatureTests.FeatureTestSpecUtils.AffRetry
import FeatureTests.FeatureTestSpecUtils.Lunapark (runLunapark)
import Lunapark as Lunapark
import Test.Spec.Assertions (shouldEqual)

waitForInputValueToEqual location expected =
  retryAction $
    ( ( runLunapark $
        Lunapark.findElement location
        >>= \e -> Lunapark.getAttribute e "value"
      )
      >>= \text -> text `shouldEqual` expected
    )

