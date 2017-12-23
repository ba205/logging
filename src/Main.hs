{-# LANGUAGE OverloadedStrings #-}
module Main where

import Logger
import LogReader
import Data.Text as T

-- | Helper function
fromEither :: Either a b -> b
fromEither (Right x) = x

-- | Examples of expected behavior.
main :: IO ()
main = do
  let logger = createLogger

      -- example given in prompt
      l1 = updateLogger 1 "abc" logger
      l2 = updateLogger 2 "def" (fromEither l1)
      l3 = updateLogger 1 "ghi" (fromEither l2)   

  case l3 of
    Left error -> putStrLn $ T.unpack error
    Right l    -> do
      (log1, m1) <- logReader l
      putStrLn $ "test: 'def' is highest priority" ++ show m1
      (log2, m2) <- logReader log1
      putStrLn $ "test: 'ghi' is next highest priority" ++ show m2
      (log3, m3) <- logReader log2
      putStrLn $ "test: 'abc' is next highest priority" ++ show m3
      -- expect exception, since empty queue
      (log4, m4) <- logReader log3
      putStrLn $ "Exception expected"
      putStrLn $ show m4
