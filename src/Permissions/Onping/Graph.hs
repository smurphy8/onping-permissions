{-# LANGUAGE BangPatterns,RankNTypes,OverloadedStrings #-}

module Permissions.Onping.Graph where
import Prelude 
import Permissions.Onping.Internal
import Permissions.Onping.Types 
import Persist.Mongo.Settings 
import Data.GraphViz
import Data.Graph.Inductive.Graph
import Control.Applicative 

-- import Data.GraphViz.Printing
-- import Data.GraphViz.Attributes.Complete
-- import Data.Graph.Inductive.Graphviz
-- import Data.IntSet

-- import Data.Graph.Inductive.Graph
-- import Data.Graph.Inductive.PatriciaTree
-- import Data.List 

-- import qualified Data.Text.Lazy as T
-- import qualified Data.Text.Lazy.IO as TIO
-- import Text.PrettyPrint hiding (Style)
-- import System.IO (writeFile)




permissionEntityToNode ::(Integral a) =>  OnPingPermissionEntity -> a -> OPNode
permissionEntityToNode ope = (\x -> (fromIntegral x , ope))



constructUserGraph :: UserId -> IO [OPNode]
constructUserGraph uid = do 
  sul <- getSuperUserList uid
  let zNodes = zipWith (\i s -> (permissionEntityToNode s) i ) [1 ..] sul
  return zNodes
      

