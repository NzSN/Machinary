{-# LANGUAGE NoImplicitPrelude, InstanceSigs, RankNTypes, GADTs #-}

module Machine.Machines.GenericMachine
  ( GenericMachine(..),
    Option(..),
    Options(..)
  ) where

import Prelude
import Machine.Types as MType (
  CommuCtx(..),
  Opt,
  Machine(..),
  Serializable(..))

import qualified Machine.CommuCtx.CommuTCP as CTCP

data Option = Option { key :: String, value :: [String] }
newtype Options = Options { opts :: [Option] }

data GenericMachine i =
  GenericMachine {
    ident :: String,
    options :: Options,
    interface :: i
    }


instance Machine GenericMachine where
  enable :: CommuCtx i => GenericMachine i -> IO Bool
  enable m = send (interface m) $ serialize "Init"

  disable :: CommuCtx i => GenericMachine i -> IO Bool
  disable m = send (interface m) $ serialize "Term"

  config :: CommuCtx i => GenericMachine i -> Opt -> IO Bool
  config m opt = send (interface m) $ serialize $ show opt

  iface :: GenericMachine i -> i
  iface = interface

-- Operation on GenericMachine
pingOp :: GenericMachine i -> CTCP.Address -> IO Bool
pingOp m = undefined
