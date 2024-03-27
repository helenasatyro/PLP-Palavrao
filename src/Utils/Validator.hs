{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Utils.Validator where

import Controllers.MatchesController
import Controllers.BoardController
import Controllers.PlayerController
import Controllers.AccountsController
import Data.Char
import Controllers.MatchesController
import Controllers.LettersController
import Utils.Utils as UT

isStringInt :: String -> Bool
isStringInt str = case reads str :: [(Int, String)] of
    [(num, "")] -> True
    _           -> False


initialValidation :: Match -> [String] -> String -> (Bool, [String], Int, [Char], [Char])
initialValidation _ _ "" = (False, [], 0, [], [])
initialValidation match wordlist linha
    | length palavras /= 3 = (False, [], 0, [], [])
    | otherwise = (resCoordenadas, resPalavras, getPointsWord letrasNoBoard word, invalidLetters, letrasUsadas)
    where
        palavras = words $ map toUpper linha
        coord = (palavras !! 0)
        isHorizontal = (palavras !! 1) == "H"       
        word = (palavras !! 2)
        x = ord (head coord ) - ord 'A'
        y = (read (tail coord) :: Int)
        playerOnTurn = getPlayerOnTurn match
        playerLetters = [letter l | l <- pLetters playerOnTurn]
        letrasNoBoard = _takeUpTo isHorizontal match (x,y) (length word)
        letterUsageReport = _wordLetterReport playerLetters letrasNoBoard word
        invalidLetters = _lettersMissing word letterUsageReport
        letrasUsadas = [l | l <- letterUsageReport, l /= '!', l /= ' ']
        estaConectado = 0 /= (length [x | x <- letrasNoBoard, x `elem` ['A'..'Z']])
        centroLivre = (((curTiles (mBoard match)) !! 7) !! 7) == '-'
        resCoordenadas = (((palavras !! 1) `elem` ["V", "H"]) 
                            && (_coordValidation coord) 
                            && (_wordValidation word letrasNoBoard) 
                            && (_tileValidationSize isHorizontal (x, y) word) 
                            && (_tileValidationLetters letrasNoBoard word) 
                            && (estaConectado || centroLivre) 
                            && (_coordCenterValidation match isHorizontal (x,y) word))
        resPalavras = (_allWordsExist match wordlist (getWords (placeWord (x,y,isHorizontal,word) (mBoard match))))


getPlayerOnTurn :: Match -> Player
getPlayerOnTurn match 
    | mTurn match = mP2 match
    | otherwise = mP1 match

_wordExistenceValidation :: Match -> [String] -> String -> Bool
_wordExistenceValidation match wordList word = ((map toLower word) `elem` (mUsedWords match)) || ((map toLower word) `elem` wordList)


_coordCenterValidation :: Match -> Bool -> (Int, Int) -> String -> Bool
_coordCenterValidation match isHorizontal (x,y) word
    | centerValue /= '-' = True
    | isHorizontal = (y == 7) && (x <= 7 && 7 <= finalXInd)
    | otherwise = (x == 7) && (y <= 7 && 7 <= finalYInd)
    where 
        finalXInd = x + (length word) - 1
        finalYInd = y + (length word) - 1
        matrix = curTiles (mBoard match)
        centerValue = (matrix !! 7) !! 7


_allWordsExist :: Match -> [String] -> [String] -> [String]
_allWordsExist match wordlist wordsToTest = [x | x <- wordsToTest, (_wordExistenceValidation match wordlist x) == False] 


_coordValidation :: [Char] -> Bool
_coordValidation (x:y) = (x `elem` ['A' .. 'O']) && (isStringInt y) && ((read y :: Int) >= 0 && (read y :: Int) <= 14)

  
_wordValidation :: String -> String -> Bool
_wordValidation word letrasNoBoard = ([] == [l | l <- word, not (isLetter l)]) && (length word /= length [l | l <- letrasNoBoard, isLetter l])

--DEBUGAR
_tileValidationLetters :: String -> String -> Bool
_tileValidationLetters [] [] = True
_tileValidationLetters (tileHead:tileTail) (wordHead:wordTail)
    | (tileHead `elem` ['A'..'Z']) && (tileHead /= wordHead) = False
    | otherwise = _tileValidationLetters tileTail wordTail



-- Recebe o board, o booleano que informa se eh horizontal, as coordenadas x e y (col, row) indexadas em zero, a palavra, e retorna se passou ou não
_tileValidationSize :: Bool -> (Int, Int) -> String -> Bool
_tileValidationSize isHorizontal (x, y) word
    | isHorizontal = (x <= 15 - (length word) && x >= 0) && (y >= 0 && y <= 14)
    | otherwise = (y <= 15 - (length word) && y >= 0) && (x >= 0 && x <= 14)

_wordLetterReport :: [Char] -> [Char] -> [Char] -> [Char]
_wordLetterReport _ _ [] = []
_wordLetterReport playerLetters (t:tileTail) (w:wordTail) -- (letrasNoBoard) (word)
    | w == t = ' ':(_wordLetterReport playerLetters tileTail wordTail)
    | w `elem` playerLetters = w:(_wordLetterReport (_removeChar w playerLetters) tileTail wordTail)
    | '<' `elem` playerLetters = '<':(_wordLetterReport (_removeChar '<' playerLetters) tileTail wordTail)
    | otherwise = '!':(_wordLetterReport playerLetters tileTail wordTail)

playerHasLetter :: Match -> Letter -> Bool
playerHasLetter match letter = letter `elem` (pLetters player)
    where player = getPlayerOnTurn match

{-  
    O output é algo assim:
    playerLetters = [A C E <] inicialmente

    PALAVRA: [A B C D E F] tinha A e D no board, não usou do player -> não tinha B e o player não tinha mas tinha curinga, usa o curinga -> ...
   NO BOARD: [A - - D - -] ... não tinha C e E o player tinha, usa C e E -> Não tinha F no board nem o player tinha curinga, vai exclamação
     OUTPUT: [  < C   E !]

     playerLetters = [A] final

     Assim, pra saber o que o player usou olha os caracteres e pra saber se passou na validação olha se tem exclamação
     As posições estão sendo respeitadas, então pra saber qual letra faltou basta olhar qual é a letra da palavra na posição exclamação.
 -}

_lettersMissing :: [Char] -> [Char] -> [Char]
_lettersMissing word filterString = 
    map fst $ filter (\(_, el) -> el == '!') $ zip word filterString


readWordInput :: String -> Match -> (Int, Int, Bool, String)
readWordInput linha match = (x, y, isHorizontal, word)
    where
        palavras = words $ map toUpper linha
        coord = (palavras !! 0)
        isHorizontal = (palavras !! 1) == "H"       
        word = (palavras !! 2)
        x = ord (head coord ) - ord 'A'
        y = (read (tail coord) :: Int)
        letrasNoBoard = _takeUpTo isHorizontal match (x,y) (length word)

accExistsValidation :: String -> IO(Bool)
accExistsValidation accName = do
    acc <- getAccByName accName
    case acc of 
        Just acc -> return True
        Nothing -> return False

matchExistsValidation :: String -> IO(Bool)
matchExistsValidation matchName = do
    match <- getMatchByName matchName
    case match of 
        Just match -> return True
        Nothing    -> return False


_takeUpTo :: Bool -> Match -> (Int, Int) -> Int -> [Char]
_takeUpTo isHorizontal match (x, y) len
    | isHorizontal = (take len (drop x (b !! y)))
    | otherwise = take len $ map (!! x) $ drop y b
    where b = curTiles (mBoard match)