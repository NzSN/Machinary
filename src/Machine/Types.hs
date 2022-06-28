{-# LANGUAGE InstanceSigs #-}

module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..),
    TransCtx(..)
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

instance Functor TransTCP where
  fmap f (TransTCP a p m) = TransTCP a p (f m)

instance Applicative TransTCP where
  pure = TransTCP "" 0
  (TransTCP _ _ f) <*> (TransTCP a p m) = TransTCP a p $ f m

instance Monad TransTCP where
  return = pure
  (TransTCP a p m) >>= f = TransTCP a p $ machine $ f m

instance TransCtx TransTCP where
  connect = undefined
  disconnect = undefined
  send = undefined
  recv = undefined



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
