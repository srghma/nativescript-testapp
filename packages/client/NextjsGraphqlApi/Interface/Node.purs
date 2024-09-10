module NextjsGraphqlApi.Interface.Node where

import GraphQLClient
  ( SelectionSet
  , selectionForField
  , graphqlDefaultResponseScalarDecoder
  , Scope__RootQuery
  , exhaustiveFragmentSelection
  , buildFragment
  )
import NextjsGraphqlApi.Scopes
  (Scope__Node, Scope__Post, Scope__User, Scope__UserAuthentication)
import NextjsGraphqlApi.Scalars (Id)
import Data.Maybe (Maybe(..))
import Prelude (pure)

id :: SelectionSet Scope__Node Id
id = selectionForField "id" [] graphqlDefaultResponseScalarDecoder

type Fragments decodesTo = { onPost :: SelectionSet Scope__Post decodesTo
                           , onQuery :: SelectionSet Scope__RootQuery decodesTo
                           , onUser :: SelectionSet Scope__User decodesTo
                           , onUserAuthentication :: SelectionSet
                                                     Scope__UserAuthentication
                                                     decodesTo
                           }

fragments :: forall decodesTo . Fragments
                                decodesTo -> SelectionSet
                                             Scope__Node
                                             decodesTo
fragments selections = exhaustiveFragmentSelection
                       [ buildFragment "Post" selections.onPost
                       , buildFragment "Query" selections.onQuery
                       , buildFragment "User" selections.onUser
                       , buildFragment
                         "UserAuthentication"
                         selections.onUserAuthentication
                       ]

maybeFragments :: forall decodesTo . Fragments (Maybe decodesTo)
maybeFragments = { onPost: pure
                           Nothing
                 , onQuery: pure
                            Nothing
                 , onUser: pure
                           Nothing
                 , onUserAuthentication: pure
                                         Nothing
                 }
