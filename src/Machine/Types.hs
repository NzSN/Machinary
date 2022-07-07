{-# LANGUAGE FlexibleInstances #-}

module Machine.Types
  ( Machine(..),
    CommuCtx(..),
    Opt,
    Serializable(..)
  ) where

import qualified Data.String as Str
import qualified Data.ByteString as BStr

type Opt = (String, [String])

-- Serializable is a set of types which able to
-- change it's structure to be able to transfered
-- within CommuCtx.
class Serializable s where
  serialize :: s -> BStr.ByteString

instance Serializable Str.String where
  serialize = Str.fromString

instance Serializable Int where
  serialize = Str.fromString . show

instance Serializable BStr.ByteString where
  serialize s = s


-- CommuCtx is an environment which hold all informations and
-- entities that used to make communications with outside world
-- from the systems where CommuCtx reside in.
class CommuCtx tr where
  connect :: tr -> IO Bool
  disconnect :: tr -> IO Bool
  send :: Serializable d => tr -> d -> IO Int
  recv :: Serializable d => tr -> IO d

-- A Machine is a system that able to perform collection of
-- operations, you are able to perform an operation via a Machine
-- by apply an Operation instance to it.
class Machine m where
  enable :: CommuCtx ctx => m ctx -> IO Bool
  disable :: CommuCtx ctx => m ctx -> IO Bool
  config :: CommuCtx ctx
         => m ctx
         -> Opt
         -> IO Bool
  iface :: CommuCtx ctx => m ctx -> ctx
