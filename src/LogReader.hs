{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}
module LogReader where

import Logger
import Data.PQueue.Max (MaxQueue)
import qualified Data.PQueue.Max as PM
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad.Trans.Except

data LogMessage = LogMessage { message    :: Text
                             , priority   :: Int
                             , date       :: Text
                             , time       :: Text
                             , threadName :: Text
                             , moduleName :: Text
                             } deriving Show

createLogMessage :: Text -> Int -> LogMessage
createLogMessage message priority =
  let date = undefined
      time = undefined
      threadName = undefined
      moduleName = undefined
    in LogMessage message priority date time threadName moduleName

logReader :: Logger -> ExceptT LogError IO LogMessage 
logReader (Logger masterLog queueBound defaultPriority) =
  do
    undefined 
