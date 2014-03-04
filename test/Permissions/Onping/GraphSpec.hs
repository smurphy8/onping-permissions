{-# LANGUAGE OverloadedStrings #-}
module Permissions.Onping.GraphSpec (main, spec) where
    
import Test.Hspec
        
main :: IO ()
main = hspec spec
               
spec :: Spec
spec = do
  describe "Permissions.Onping.GraphSpec is undefined" $ do
         it "should actually you know... do things" $ do
              True `shouldBe` False
