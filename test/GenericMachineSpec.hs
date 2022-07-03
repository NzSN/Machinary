{-# LANGUAGE NoImplicitPrelude, InstanceSigs, RankNTypes #-}

module GenericMachineSpec
  (spec) where

import Prelude
import Test.Hspec ( describe, it, Spec, shouldBe )
import Machine.Types as MType
    (CommuCtx(..), Machine(..))
import Machine.Machines.GenericMachine
  (GenericMachine(..),
   Options(..))
import Control.Monad.IO.Class ( MonadIO(liftIO) )


data TransSuccess = TransSuccess
instance CommuCtx TransSuccess where
  send _ _ = return True
  connect _ = return True
  disconnect _ = return True
  recv _ = undefined

data TransFail = TransFail
instance CommuCtx TransFail where
  send :: TransFail -> a -> IO Bool
  send _ _ = return False
  connect _ = return False
  disconnect _ = return False
  recv _ = undefined



spec :: Spec
spec = do
  describe "GenericMachine Spec" $ do
    it "Init success" $ do
      let m = GenericMachine {
            ident = "M",
            options = Options { opts = [] },
            interface = TransSuccess
            }
      ret <- liftIO (enable m)
      ret `shouldBe` True

    it "Init fail" $ do
      let m = GenericMachine {
            ident = "M",
            options = Options { opts = [] },
            interface = TransFail
            }
      ret <- liftIO (enable m)
      ret `shouldBe` False
