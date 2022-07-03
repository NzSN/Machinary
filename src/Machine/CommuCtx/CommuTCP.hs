{-# LANGUAGE ImplicitPrelude #-}

module Machine.CommuCtx.CommuTCP
  ( CommuTCP (..),
    Address (..),
    TranslayerProto (..)
  ) where

import Machine.Types (CommuCtx(..))


data TranslayerProto = TCP | UDP deriving (Eq, Show)

data Address = TranslayerAddress
  { ipaddr :: String,
    port   :: Integer,
    proto  :: TranslayerProto
  } deriving (Show, Eq)

newtype CommuTCP = CommuTCP { addr  :: Address } deriving (Show, Eq)

instance CommuCtx CommuTCP where
  connect = undefined
  disconnect = undefined

  send :: CommuTCP -> d -> IO Bool
  send _ _ = undefined

  recv = undefined
