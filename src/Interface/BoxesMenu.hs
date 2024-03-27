{-# LANGUAGE DeriveGeneric #-}

module Interface.BoxesMenu where

import Text.Printf
import System.Console.ANSI
import Data.Char
import GHC.Generics
import Controllers.AccountsController
import Controllers.PlayerController
import Controllers.MatchesController

data Action = NewGame | ContinueGame | Rules | Login | Register | RegisterMatch | StartMenu | Rank | InvalidAction | BeforeGame | FinishMatch | Matches deriving (Show, Eq)

data Menu = Menu {
    box :: [[Char]],
    p1 :: Account,
    p2 :: Account,
    accsRank :: [Account],
    action :: Action,
    boxBefore :: Action,
    currentMatch :: Match
} deriving (Show, Eq)

beginGame :: Menu
beginGame = Menu {
    box = [
        "                 ┌─────────────────────────────┐                ",
        "                 │                             │                ",
        "                 │    Redimensione para que    │                ",
        "                 │  a linha caiba no terminal! │                ",
        "                 │                             │                ",
        "<-------------------------------------------------------------->",
        "                 │           > Enter           │                ",
        "                 │                             │                ",
        "                 └─────────────────────────────┘                "
    ], boxBefore = InvalidAction, action = StartMenu, p1 = Account{accName = ""}, p2 = Account{accName = ""}, currentMatch = Match{mName = ""}}

updateMenu :: Action -> Menu -> Menu
updateMenu action menu = case action of
        StartMenu -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │      1.  novo jogo            │   ",
        "    │      2.  continuar jogo       │   ",
        "    │      3.  criar conta          │   ",
        "    │      4.  regras               │   ",
        "    │      5.  rank                 │   ",
        "    │      6.  sair                 │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    └───────────────────────────────┘   "
     ], boxBefore = StartMenu, action = StartMenu}
        NewGame -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │      1. criar conta           │   ",
        "    │      2. login                 │   ",
        "    │      3. voltar                │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │      iniciando novo jogo      │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = NewGame}
        ContinueGame -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │      1. nome da partida       │   ",
        "    │      2. partidas criadas      │   ",
        "    │      3. voltar                │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │         continuando           │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = ContinueGame}
        Login -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │     1. digitar nome           │   ",
        "    │     2. voltar                 │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │            login              │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = Login}
        Rules -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │            regras             │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = Rules}
        BeforeGame -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        printf "    │        %-16s       │   " (take 16 $ (mName (currentMatch menu))),
        "    │                               │   ",
        "    │      1.  ir para jogo         │   ",
        "    │      2.  tirar player 1       │   ",
        "    │      3.  tirar player 2       │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │        opcoes de jogo         │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = BeforeGame}
        Register -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │     1. digitar nome           │   ",
        "    │     2. voltar                 │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │        criando conta          │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = Register}
        RegisterMatch -> menu { box = [
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │     1. digitar nome           │   ",
        "    │     2. voltar                 │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │       criando partida         │   ",
        "    └───────────────────────────────┘   "
    ], boxBefore = StartMenu, action = RegisterMatch}
        Rank -> menu { box = ([
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   "] 
        ++ (geraRankLines menu) ++
       ["    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │             rank              │   ",
        "    └───────────────────────────────┘   "
    ]), boxBefore = StartMenu, action = Rank}
        Matches -> menu { box = ([
        "    ┌───────────────────────────────┐   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   "]
        ++ (geraMatchLines getMatches pageIndex matchesPerPage) ++
       ["    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    └───────────────────────────────┘   "
    ]), boxBefore = ContinueGame, action = Matches}
        FinishMatch -> menu { box = ([
        "    ┌───────────────────────────────┐   ",
        printf "    │  %-5s                 %-5s  │   " (take 5 $ (accName (p1 menu))) (take 5 $ (accName (p2 menu))),
        "    │                               │   ",
        "    │           PALAVRÃO            │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │        Player ganhador        │   ",
        "    │                               │   ",
        printf "    │        %-17s      │   " (take 17 $ (accName (pAcc (getBestPlayer (currentMatch menu))))),
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │                               │   ",
        "    │       partida finalizada      │   ",
        "    └───────────────────────────────┘   "
    ]), boxBefore = StartMenu, action = FinishMatch}

geraRankLines :: Menu -> [String]
geraRankLines menu = [( "    │     " ++ (show (i)) ++ printf ". %-5s  -  %-4s         │   " (take 5 $ accName acc) (take 4 $ show (accScore acc))) | (acc, i) <- zip (take 5 $ reverse (accsRank menu)) [1..5]]

-- tentando exibir as partidas em uma página
displayMatchesPage :: [Match] -> Int -> [String]
displayMatchesPage matches pageIndex =
    let matchesPerPage = 5
        startIndex = pageIndex * matchesPerPage
        endIndex = min (startIndex + matchesPerPage) (length matches)
        matchesOnPage = take matchesPerPage (drop startIndex matches)
        matchLines = map (\(i, match) -> printf "    │   %-2d. %-20s     │" (i + 1) (take 20 $ mName match)) (zip [startIndex..] matchesOnPage)
    in matchLines

-- atualizando geraMatchLines
geraMatchLines :: [Match] -> Int -> Int -> [String]
geraMatchLines matches pageIndex matchesPerPage =
    let startIndex = pageIndex * matchesPerPage
        endIndex = min (startIndex + matchesPerPage) (length matches)
        matchesOnPage = take matchesPerPage (drop startIndex matches)
        matchLines = map (\(i, match) -> printf "    │   %-2d. %-20s     │" (i + 1) (take 20 $ mName match)) (zip [startIndex..] matchesOnPage)
    in ["    │                               │   "] ++ matchLines ++ ["    │                               │   "]
