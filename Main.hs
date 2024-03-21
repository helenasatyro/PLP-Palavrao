module Main where

import Utils as UT
import AccountsController
import MatchesController
import BoardController
import DrawBoard
import System.Console.ANSI

main :: IO ()
main = do
    clearScreen
    putStrLn (unlines [ "                 ┌─────────────────────────────┐",  
                        "                 │                             │",  
                        "                 │    Redimensione para que    │",
                        "                 │  a linha caiba no terminal! │",  
                        "                 │                             │",
                        "<-------------------------------------------------------------->",
                        "                 │           > Enter           │",
                        "                 │                             │",  
                        "                 └──────────────────────────── ┘"])

    
    ctd <- getLine
    startPersistence
    
    acc1 <- createAcc "Fulano"
    acc2 <- createAcc "Sicrano"
    match <- createMatch "Fulano x Sicrano" acc1 acc2
    print(mName match)
    print(mBoard match)
    print(mP1 match)
    print(mP2 match)

    fulanoExiste <- accExists "Fulano"
    if (fulanoExiste)
        then putStrLn "Fulano existe"
        else putStrLn "Fulano não existe"
    
    kaikeExiste <- accExists "Kaike"
    if (kaikeExiste)
        then putStrLn "Kaike existe"
        else putStrLn "Kaike não existe"

    fulanoXSicranoExiste <- matchExists "Fulano x Sicrano"
    if (fulanoXSicranoExiste)
        then putStrLn "Fulano x Sicrano existe"
        else putStrLn "Fulano x Sicrano não existe"
    
    fulanoXKaikeExiste <- matchExists "Fulano x Kaike"
    if (fulanoXKaikeExiste)
        then putStrLn "Fulano x Kaike existe"
        else putStrLn "Fulano x Kaike não existe"

    maybeMatch <- getMatchByName "Fulano x Sicrano"
    case maybeMatch of
        Nothing -> putStrLn "Match not found."
        Just match -> do

            let updatedMatch = incPlayerScore (toggleMatchTurn (_updateMatchLetters match [])) 100
            updateMatchJson updatedMatch
            putStrLn (UT.getJsonStr updatedMatch)


    printBoard match
    putStrLn $ show (getWords (mBoard match))
    tt (placeWord 1 1 False "OLAR" toyBoard)
