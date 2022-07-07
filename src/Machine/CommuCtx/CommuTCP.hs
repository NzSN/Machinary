{-# LANGUAGE ImplicitPrelude #-}

module Machine.CommuCtx.CommuTCP
  ( CommuTCP (..),
    Address (..),
    TranslayerProto (..)
  ) where

import Machine.Types (CommuCtx(..), Serializable(..))
import qualified Network.Socket as Sock
import qualified Network.Socket.ByteString as SBStr
import qualified Machine.CommuCtx.Proto as Proto


data TranslayerProto = TCP | UDP deriving (Eq, Show)

data Address = TranslayerAddress
  { ipaddr :: String,
    port   :: Integer,
    proto  :: TranslayerProto
  } deriving (Show, Eq)

newtype TCPSock = TCPSock { sock :: Sock.Socket } deriving (Show, Eq)
instance Proto.TransPort TCPSock where
  sendTrans = SBStr.send . sock
  recvTrans = SBStr.recv . sock
  closeTrans = Sock.close . sock

data CommuTCP = CommuTCP
  { addr  :: Address,
    endPoint :: Proto.EndPoint TCPSock
  } deriving (Show, Eq)

instance CommuCtx CommuTCP where
  connect = undefined
  disconnect = undefined

  send :: Serializable d => CommuTCP -> d -> IO Int
  send (CommuTCP _ e) d = do
    let bstr = serialize d
    Proto.send e bstr

  recv = undefined
