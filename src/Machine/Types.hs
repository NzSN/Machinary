module Machine.Types
  ( Machine(..),
    Operation(..),
    OpArgs,
    RemoteMachine(..),
    CommuCtx(..),
  ) where

import qualified Data.String as Str
import qualified Data.ByteString as BStr

type Opt = (String, [String])

class CommuCtx tr where
  connect :: tr dtype -> IO Bool
  disconnect :: tr dtype-> IO Bool
  send :: tr dtype -> dtype -> IO Bool
  recv :: tr dtype -> IO dtype


class Machine m where
  init :: CommuCtx ctx => m ctx -> IO Bool
  term :: CommuCtx ctx => m ctx -> IO Bool
  config :: CommuCtx ctx
         => m ctx
         -> Opt
         -> IO Bool

type OpArgs = [(String, String)]
class Operation op where
  (<-*>) :: Machine m => m ctx -> op -> OpArgs -> m ctx

-- Concrete Machines
type Options = [(String, [String])]
data RemoteMachine i =
  RemoteMachine {
    ident :: String,
    options :: Options,
    interface :: CommuCtx i => i BStr.ByteString
    }


instance Machine RemoteMachine where
  init :: CommuCtx i => RemoteMachine i -> IO Bool
  init m = send (interface m) $ Str.fromString "Init"

  term :: CommuCtx i => RemoteMachine i -> IO Bool
  term m = send (interface m) $ Str.fromString "Term"

  config :: CommuCtx i => RemoteMachine i -> Opt -> IO Bool
  config m opt = send (interface m) $ Str.fromString $ show opt
