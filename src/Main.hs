{-# LANGUAGE OverloadedStrings #-} -- Text Handling

import System.Environment
import Network.Wreq
import Data.Aeson.Lens (_String, key)
import Control.Lens
import Text.Printf -- Print the Text
import System.IO
import qualified Data.Text.Encoding as E -- To encode file content to Utf8
import qualified Data.Text.IO as I -- To read file content as Text



main = do
   args <- getArgs
   handle <- openFile (head args) ReadMode
   contents <- I.hGetContents handle

   parse <- post "http://hastebin.com/documents" (E.encodeUtf8 contents)
   let m_ParsedText = parse ^? responseBody . key "key" . _String

   -- Take the key and print the url
   case m_ParsedText of
     Just x ->  putStrLn . printf "http://hastebin.com/%s" $ x
     Nothing -> putStrLn "Nothing is sent"

   hClose handle -- Close file
