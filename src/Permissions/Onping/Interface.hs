{-# LANGUAGE OverloadedStrings #-}
module Permissions.Onping.Interface where 
import Network.Wai
import Network.HTTP.Types (status200)
import Network.Wai.Handler.Warp (run)
import Data.Aeson 


application _ = return $
  responseLBS status200 [("Content-Type", "text/plain")] "Hello World"

main = run 3000 application
