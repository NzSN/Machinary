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
import Control.Monad.IO.Class ( MonadIO )

class TransPort p where
  sendTrans :: MonadIO m => p -> BStr.ByteString -> m ()
  recvTrans :: MonadIO m => p -> Int -> m (Maybe BStr.ByteString)
  closeTrans :: MonadIO m => p -> m ()

newtype EndPoint tr = EndPoint { sock :: tr } deriving (Show, Eq)


send :: (MonadIO m, TransPort tr) => EndPoint tr -> BStr.ByteString -> m ()
send = sendProto . sock

recv :: (MonadIO m, TransPort tr) => EndPoint tr -> Int -> m (Maybe BStr.ByteString)
recv = recvProto . sock

close :: (MonadIO m, TransPort tr) => EndPoint tr -> m ()
close = closeProto . sock


sendProto :: (MonadIO m, TransPort p) => p -> BStr.ByteString -> m ()
sendProto s bs = do
  sendTrans s bs

recvProto :: (MonadIO m, TransPort p) => p -> Int -> m (Maybe BStr.ByteString)
recvProto s n = do
  recvTrans s n

closeProto :: (MonadIO m, TransPort p) => p -> m ()
closeProto s = do
  closeTrans s
