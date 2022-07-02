{-# LANGUAGE ImplicitPrelude #-}

module Machine.CommuCtx.CommuTCP
  (CommuTCP (..)) where

import Machine.Types (CommuCtx(..))


-- Concrete Interfaces
data CommuTCP a = CommuTCP {
    ipaddr  :: (String, Int)
  } deriving (Show, Eq)

instance CommuCtx CommuTCP where
  connect = undefined
  disconnect = undefined

  send :: CommuTCP d -> d -> IO Bool
  send _ _ = undefined

  recv = undefined
