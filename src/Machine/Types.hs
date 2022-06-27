{-# LANGUAGE InstanceSigs #-}

module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..)
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


type Options = [(String, [String])]
data RemoteMachine =
  RemoteMachine { address :: String,
                  options :: Options
                } deriving (Show, Eq)


instance Machine RemoteMachine where
  init ::  RemoteMachine -> RemoteMachine
  init = undefined

  term :: RemoteMachine -> RemoteMachine
  term = undefined

  config :: RemoteMachine -> ConfigProc -> RemoteMachine
  config = undefined
