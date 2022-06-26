{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Run (run) where

import Import

run :: RIO App ()
run = do
  App _ _ opts <- ask
  logInfo $ if optionsVerbose opts
            then "True"
            else "False"
  logInfo "We're inside the application!"
