{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -Wall #-}

module Main where

import Control.Applicative ((<|>))
import Data.Proxy (Proxy (Proxy))
import Network.Wai.Handler.Warp (run)
import Servant
  ( (:>),
    Capture,
    Get,
    Handler,
    PlainText,
    serve,
  )
import System.Environment (getEnv)

type Greeter =
  "hello"
    :> Capture "name" String
    :> Get '[PlainText] String

greet :: String -> Handler String
greet name =
  pure $ "Hello, " <> name <> "!"

getPort :: IO Int
getPort =
  read <$> getEnv "PORT" <|> pure 8000

main :: IO ()
main = do
  port <- getPort
  run port $ serve (Proxy @Greeter) greet