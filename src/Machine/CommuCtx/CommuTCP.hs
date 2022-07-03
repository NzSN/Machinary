{-# LANGUAGE ImplicitPrelude #-}

module Machine.CommuCtx.CommuTCP
  ( CommuTCP (..),
    Address (..),
    TranslayerProto (..)
  ) where

import Machine.Types (CommuCtx(..))
import qualified Network.Simple.TCP as TCP
import qualified Machine.CommuCtx.Proto as Proto


data TranslayerProto = TCP | UDP deriving (Eq, Show)

data Address = TranslayerAddress
  { ipaddr :: String,
    port   :: Integer,
    proto  :: TranslayerProto
  } deriving (Show, Eq)

newtype TCPSock = TCPSock { sock :: TCP.Socket } deriving (Show, Eq)
instance Proto.TransPort TCPSock where
  sendTrans = TCP.send . sock
  recvTrans = TCP.recv . sock
  closeTrans = TCP.closeSock . sock

data CommuTCP = CommuTCP
  { addr  :: Address,
    endPoint :: Proto.EndPoint TCPSock
  } deriving (Show, Eq)

instance CommuCtx CommuTCP where
  connect = undefined
  disconnect = undefined

  send :: CommuTCP -> d -> IO Bool
  send _ _ = undefined

  recv = undefined
