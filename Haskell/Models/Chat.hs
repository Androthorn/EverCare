module Haskell.Models.Chat where

import Data.Time.Clock (UTCTime)

data Message = Message { 
    messageId :: Int,
    senderId :: Int,
    receiverId :: Int,
    content :: String,
    timestamp :: UTCTime
} deriving Show
