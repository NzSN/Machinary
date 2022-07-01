module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..),
    CommuCtx(..)
  ) where

type ConfigProc = String -> [String] -> Bool

class Machine m where
  init :: m ctx -> m ctx
  term :: m ctx -> m ctx
  config :: m ctx
         -> ConfigProc
         -> m ctx

type OpArgs = [(String, String)]
class Operation op where
  (<-*>) :: Machine m => m ctx -> op -> OpArgs -> m ctx


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
data RemoteMachine m =
  RemoteMachine {
    ident :: String,
    options :: Options,
    interface :: CommuCtx m => m
    }


instance Machine RemoteMachine where
  init ::  RemoteMachine m -> RemoteMachine m
  init = undefined

  term :: RemoteMachine m -> RemoteMachine m
  term = undefined

  config :: RemoteMachine m  -> ConfigProc -> RemoteMachine m
  config = undefined
