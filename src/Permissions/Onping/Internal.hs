module Permissions.Onping.Internal
    (
    ) where

import Control.Applicative
import Persist.Mongo.Settings
import Database.Persist
import Permissions.Onping.Types
import qualified Data.Text as T
import qualified Data.List as L




-- | filterSuperUserList is extracted from Onping, modified to return the SuperUser Tree of any user

getSuperUserList :: UserId -> IO  [OnPingPermissionEntity]
getSuperUserList uid = do
  aidG <- runDB $ do 
    l <- selectList [] [] 
    return $ l
  aidU <- runDB $ do
    l <- selectList [] []
    return $ l
  filterSuperUserList' uid  $ (PEgroup <$> aidG) ++ (PEuser <$> aidU) -- Complete list of all UserTags and Groups





filterSuperUserList' :: UserId -> [PermissionEntity (Entity UserTag) (Entity Group)] -> IO [(PermissionEntity (Entity UserTag)  (Entity Group))]
filterSuperUserList' aid peList =  do
  peListSeed <- runDB $ do
                  (Just uTag) <- selectFirst [UserTagUser ==. (aid)] []  
                  (Just gTag) <- selectFirst [GroupId ==. (userTagGroup.entityVal $ uTag)] [] -- Default user grp
                  egids  <- selectList [GroupUserJoinUId ==. aid] []-- other user grps
                  grps   <- selectList [GroupId <-. (groupUserJoinGId.entityVal  <$> egids)] [] 
                  return $ [PEuser uTag, PEgroup gTag] ++ (PEgroup <$> grps)
  return $ (superListMaker peListSeed ) L.\\ peListSeed -- subtracting out 1 instance of each, if overlap occurs so be it
    where 
         superListMaker :: [PermissionEntity (Entity UserTag) (Entity Group)] -> [(PermissionEntity (Entity UserTag)  (Entity Group))]
         superListMaker peListSeed = (L.foldl (\a b ->  (runFilter a b) ++ a ) peListSeed peList) 


-- | runs the filter and collects the results 
runFilter :: [PermissionEntity (Entity UserTag) (Entity Group)] -> PermissionEntity (Entity UserTag) (Entity Group) -> [PermissionEntity (Entity UserTag) (Entity Group)]
runFilter (peTester:peList) candidate 
    | suFilterFunction peTester candidate = [candidate] 
    | otherwise = runFilter peList candidate 
runFilter [] _ = []



suFilterFunction :: PermissionEntity (Entity UserTag) (Entity Group) -> PermissionEntity (Entity UserTag) (Entity Group) -> Bool
suFilterFunction (PEuser superUser) (PEuser user)
    |either (\_ -> False ) (\u -> (userTagOwner.entityVal $ user) == u) (pullValueForCompare superUser) = True
    |otherwise = False
                 
suFilterFunction (PEuser superUser) (PEgroup grp)
  |((groupOwner.entityVal $ grp) == (userTagUser.entityVal $ superUser) ) = True
  |otherwise = False

suFilterFunction (PEgroup superGroup) (PEuser user)
  |(userTagSuperGroup.entityVal $ user) == entityKey superGroup = True
  |otherwise = False
               
suFilterFunction (PEgroup superGroup) (PEgroup grp)
  |(groupGroup.entityVal $ grp) == entityKey superGroup = True
  |otherwise = False
suFilterFunction _ _ = False

pullValueForCompare :: (PersistField a) => Entity entity -> Either T.Text a
pullValueForCompare = fromPersistValue.unKey.entityKey
