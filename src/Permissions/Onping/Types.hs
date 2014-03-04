{-# LANGUAGE TupleSections, OverloadedStrings, QuasiQuotes, TemplateHaskell, TypeFamilies, RecordWildCards,DeriveGeneric, MultiParamTypeClasses, FlexibleInstances  #-}
module Permissions.Onping.Types where

import Persist.Mongo.Settings
import Database.Persist
import GHC.Generics
import Data.Aeson

import Prelude hiding (head, init, last
                      ,readFile, tail, writeFile)


data PermissionEntity a b = PEuser {getPEuser::a} | PEgroup {getPEgroup::b} |Empty
    deriving (Show,Eq,Read,Generic)



instance (FromJSON a , FromJSON b ) => FromJSON (PermissionEntity a b)

instance (ToJSON a , ToJSON b ) => ToJSON (PermissionEntity a b)

type OnPingPermissionEntity = PermissionEntity (Entity UserTag) (Entity Group) 

-- type Permission = Tree (PermissionEntity UserId GroupId)


permissionGroups :: [PermissionEntity a b] -> [PermissionEntity a b]
permissionGroups = filter chk 
                   where chk (PEgroup _) = True
                         chk (_) = False

permissionUsers :: [PermissionEntity a b] -> [PermissionEntity a b] 
permissionUsers = filter chk 
    where chk (PEuser _) = True
          chk (_) = False
