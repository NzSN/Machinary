{-# LANGUAGE InstanceSigs #-}

module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..),
    CommuCtx(..)
  ) where

type ConfigProc = String -> [String] -> Bool

class Machine m where
  init :: m -> m
  term :: m -> m
  config :: m
         -> ConfigProc
         -> m

type OpArgs = [(String, String)]
class Operation op where
  (<-*>) :: Machine m => m -> op -> OpArgs -> m


class CommuCtx tr where
  connect :: tr -> Maybe String
  disconnect :: tr-> Maybe String
  send :: tr -> a -> tr
  recv :: tr -> Maybe a


-- Concrete Interfaces
data TransTCP = TransTCP { ipaddr  :: String,
                             port    :: Integer
                           } deriving (Show, Eq)

instance CommuCtx TransTCP where
  connect = undefined
  disconnect = undefined
  send = undefined
  recv = undefined


-- Concrete Machines
type Options = [(String, [String])]
data RemoteMachine =
  RemoteMachine { ident :: String,
                  options :: Options,
                  interface :: TransTCP
                } deriving (Show, Eq)


instance Machine RemoteMachine where
  init ::  RemoteMachine -> RemoteMachine
  init = undefined

  term :: RemoteMachine -> RemoteMachine
  term = undefined

  config :: RemoteMachine -> ConfigProc -> RemoteMachine
  config = undefined
