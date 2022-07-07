{-# LANGUAGE NoImplicitPrelude #-}

module Machine.CommuCtx.Proto
  ( EndPoint (..),
    TransPort (..),
    send,
    recv,
    close
  ) where

import Prelude
import qualified Data.ByteString as BStr

class TransPort p where
  sendTrans :: p -> BStr.ByteString -> IO Int
  recvTrans :: p -> Int -> IO BStr.ByteString
  closeTrans :: p -> IO ()

newtype EndPoint tr = EndPoint { sock :: tr } deriving (Show, Eq)


send :: TransPort tr => EndPoint tr -> BStr.ByteString -> IO Int
send = sendProto . sock

recv :: TransPort tr => EndPoint tr -> Int -> IO BStr.ByteString
recv = recvProto . sock

close :: TransPort tr => EndPoint tr -> IO ()
close = closeProto . sock


sendProto :: TransPort p => p -> BStr.ByteString -> IO Int
sendProto s bs = do
  sendTrans s bs

recvProto :: TransPort p => p -> Int -> IO BStr.ByteString
recvProto s n = do
  recvTrans s n

closeProto :: TransPort p => p -> IO ()
closeProto s = do
  closeTrans s
