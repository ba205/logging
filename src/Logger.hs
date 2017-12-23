{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}
module Logger where

import Data.PQueue.Max (MaxQueue)
import qualified Data.PQueue.Max as PM
import Data.Text (Text)
import qualified Data.Text as T

-- | Custom logger datatype, with queue, maximum size of
--   queue, and a default priority if the user requires. 
data Logger = Logger { masterLog       :: MaxQueue (Int, Text) -- PSQ Text Int
                     , queueBound      :: Int
                     , defaultPriority :: Int
                     }
                     deriving (Show)

-- | User function to update the default priority of their messages.
updatePriority :: Int -> Logger -> Logger
updatePriority newPriority (Logger {masterLog, queueBound, defaultPriority})
  = Logger masterLog queueBound newPriority

-- | Initialize Logger with empty queue, bound size set to 1024,
--   and defaultPriority set to 3. In practice, this can be any
--   number between 1 and 3.
createLogger :: Logger
createLogger = 
  Logger { masterLog = PM.empty, queueBound = 1024, defaultPriority = 3 }

-- | Type Synonym for logging error messages.
type LogError = Text

-- | Given your priority, message, and logger, if the queue is full,
--   return an error message. Otherwise, update the queue in the logger.
updateLogger :: Int -> Text -> Logger -> Either LogError Logger
updateLogger priority message (Logger {masterLog, queueBound, defaultPriority})
  = case PM.size masterLog >= queueBound of
      True  -> Left "Can't add message; queue is full"
      False -> let newLog = PM.insert (priority, message) masterLog
        in Right $ Logger newLog queueBound defaultPriority

-- | Given your message and logger, if the queue is full,
--   return an error message. Otherwise, update the queue with default
--   priority in the logger.
updateLoggerWithDefault :: Text -> Logger -> Either LogError Logger
updateLoggerWithDefault 
  message logger@(Logger {masterLog, queueBound, defaultPriority}) =
  updateLogger defaultPriority message logger
