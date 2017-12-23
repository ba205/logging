{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}
module LogReader where

import Logger
import Data.PQueue.Max (MaxQueue)
import qualified Data.PQueue.Max as PM
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad.Trans.Except
import Data.Time.Clock
import Data.Time.Calendar
import GHC.Conc

-- Datatype to store information about logging messages.
data LogMessage = LogMessage { message    :: Text
                             , priority   :: Int
                             , datetime   :: Text
                             , threadName :: Text
                             } deriving Show

-- Given a message and its priority, create a new Log Message.
createLogMessage :: Text -> Int -> IO LogMessage
createLogMessage message priority =
  do
    datetime <-  getCurrentTime
    let datetime' = T.pack $ show datetime
    threadName <- myThreadId
    let threadName' = T.pack $ show threadName
    return $ LogMessage message priority datetime' threadName'

-- | Given the current logger, read the top priority message
--   if it exists, otherwise throw an exception.
logReader :: Logger -> IO (Logger, LogMessage) 
logReader (Logger masterLog queueBound defaultPriority) =
  do
    let ((priority, message), logger) = PM.deleteFindMax masterLog
    logMessage <- createLogMessage message priority
    let newLogger = Logger logger queueBound defaultPriority
    return (newLogger, logMessage)
