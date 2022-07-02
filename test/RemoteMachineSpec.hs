{-# LANGUAGE NoImplicitPrelude, InstanceSigs, RankNTypes #-}

module RemoteMachineSpec
  (spec) where

import Prelude
import Data.String as Str
import Test.Hspec ( describe, it, Spec, shouldBe )
import Machine.Types as MType
    ( Machine(init),
      RemoteMachine(RemoteMachine, ident, options, interface),
      CommuCtx(..))
import Control.Monad.IO.Class ( MonadIO(liftIO) )


newtype TransSuccess d = TransSuccess d
instance CommuCtx TransSuccess where
  send _ _ = return True
  connect _ = return True
  disconnect _ = return True
  recv _ = undefined

newtype TransFail d = TransFail d
instance CommuCtx TransFail where
  send :: TransFail d -> a -> IO Bool
  send _ _ = return False
  connect _ = return False
  disconnect _ = return False
  recv _ = undefined



spec :: Spec
spec = do
  describe "RemoteMachine Spec" $ do
    it "Init success" $ do
      let m = RemoteMachine {
            ident = "M",
            options = [],
            interface = TransSuccess $ Str.fromString "Init"
            }
      ret <- liftIO (MType.init m)
      ret `shouldBe` True

    it "Init fail" $ do
      let m = RemoteMachine {
            ident = "M",
            options = [],
            interface = TransFail $ Str.fromString "Init"
            }
      ret <- liftIO (MType.init m)
      ret `shouldBe` False
