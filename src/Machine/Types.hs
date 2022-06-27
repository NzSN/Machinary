{-# LANGUAGE InstanceSigs #-}

module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..),
    Interface(..)
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


class Monad tr => TransCtx tr where
  connect :: Machine m => tr m -> Maybe String
  disconnect :: Machine m => tr m -> Maybe String
  send :: Machine m => tr m -> a -> tr m
  recv :: Machine m => tr m -> Maybe a


-- Concrete Interfaces
data TransTCP m = TransTCP { ipaddr  :: String,
                             port    :: Integer,
                             machine :: m
                           } deriving (Show, Eq)

instance TransCtx TransTCP where



-- Concrete Machines
type Options = [(String, [String])]
data RemoteMachine =
  RemoteMachine { ident :: String,
                  options :: Options
                } deriving (Show, Eq)


instance Machine RemoteMachine where
  init ::  RemoteMachine -> RemoteMachine
  init = undefined

  term :: RemoteMachine -> RemoteMachine
  term = undefined

  config :: RemoteMachine -> ConfigProc -> RemoteMachine
  config = undefined
