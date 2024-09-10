module NextjsApp.NodeEnv where


type Env =
  { apiUrl :: String
  , isProduction :: Boolean
  }

foreign import env :: Env

-- | foreign import jwtKey :: String

-- | oneDay = 60.0 {- sec -} * 60.0 {- min -} * 24.0 {- h -}

-- | jwtMaxAgeInSeconds :: Number
-- | jwtMaxAgeInSeconds = oneDay

-- | jwtDomain :: Maybe String
-- | jwtDomain =
-- |   if env.isProduction
-- |     then Just "todomydomain.com" -- TODO: server on `https://api.todomydomain.com/graphql`, client on `https://todomydomain.com/graphql`
-- |     else Nothing -- this is actually more restrictive, it allows only on the same ORIGIN (subdomain + domain)
