Assignment 4: Regular Expression Analysis in Haskell
====================================================

Due November 9
Hand in by November 10 at 3:00 AM

For this assignment, you will devise two functions for analyzing regular
expressions using the RE data type created in class.

Create a file called Project.hs, and include this data declaration


data RE a            -- regular expressions over an alphabet defined by 'a'
    = Empty          -- empty regular expression
    | Sym a          -- match the given symbol
    | RE a :+: RE a  -- concatenation of two regular expressions
    | RE a :|: RE a  -- choice between two regular expressions
    | Rep (RE a)     -- zero or more repetitions of a regular expression
    | Rep1 (RE a)    -- one or more repetitions of a regular expression
    deriving (Show)



Define two functions which analyze regular expressions defined using this type.

- matchEmpty :: RE a -> Bool

    This function returns true if the regular expression matches an empty
    string. Note that the type does not include any constraints on the alphabet.
    Among other things, this means that will not be able to use the matches
    function we defined in class, as it requires 'a' to be an instance of Eq.
    
    Some examples:
    
    matchEmpty (Sym 'a') = False
    matchEmpty (Rep (Sym 'a' :+: Sym 'b')) = True
    matchEmpty (Rep1 (Sym 'a' :|: Empty)) = True


- firstMatches :: RE a -> [a]

    Given a regular expression r, return a list of all symbols that occur first
    in some string in the language described by r. You are not required to
    eliminate duplicates (since nothing is known about the alphabet, doing so
    would be impossible), but the list should be finite. No particular order
    is required.
    
    Some examples:
    
    firstMatch (Sym 'a') = ['a']
    firstMatch (Rep (Sym 'a' :|: Sym 'b')) = ['a', 'b']
    firstMatch (Sym 1 :+: Sym 2) = [1]
    firstMatch ((Sym 1 :|: Empty) :+: Sym 2) = [1,2]


Hand in the project by submitting Project.hs through Sakai.


Testing
-------

This literate Haskell file may be used to test your project. Copy it to the
same directory as your Project.hs and run it using 

    runghc hw4

Note that hw4.lhs refers to the types and functions defined in your Project
module, so it won't compile unless all the definitions are there. If you wish
to test a partially written module, you can add dummmy definitions for any
functions you haven't written yet, e.g.:

    firstMatch :: RE a -> [a]
    firstMatch = undefined

(The type signature is optional.)


> module Main where
> 
> import Control.Exception (catch, ErrorCall(..), evaluate)
> import Project (RE(..), matchEmpty, firstMatches)
>
> a = Sym 'a'
> b = Sym 'b'
>
> tests =
>     [ test "matchEmpty a" (matchEmpty a) False
>     , test "matchEmpty a*b" (matchEmpty (Rep a :+: b)) False
>     , test "matchEmpty (ab)*" (matchEmpty (Rep (a :+: b))) True
>     , test "matchEmpty (a|e)+" (matchEmpty (Rep1 (a :|: Empty))) True
>     , testBy seteq "firstMatches a" (firstMatches a) "a"
>     , testBy seteq "firstMatches (a|b)*" (firstMatches (Rep (a :|: b))) "ab"
>     , testBy seteq "firstMatches 12" (firstMatches (Sym 1 :+: Sym 2)) [1]
>     , testBy seteq "firstMatches (1|e)2" (firstMatches ((Sym 1 :|: Empty) :+: Sym 2)) [1,2]
>     ]
> 
> testBy :: (Show a) => (a -> a -> Bool) -> String -> a -> a -> IO Bool
> testBy eq name got want = catch body (\(ErrorCall s) -> fail "ERROR" s)
>     where
>     body = do
>         ok <- evaluate (eq got want)
>         if ok
>             then do
>                 putStrLn $ "PASS : " ++ name
>                 return True
>             else fail "FAIL " (show got)
>     
>     fail msg txt = do
>         putStrLn $ msg ++ ": " ++ name
>         putStrLn $ "       wanted: " ++ show want
>         putStrLn $ "       got:    " ++ txt
>         return False
>
> test :: (Eq a, Show a) => String -> a -> a -> IO Bool
> test = testBy (==)
>
> seteq l1 l2 = all (`elem` l1) l2 && all (`elem` l2) l1
>
> runTests n f [] = 
>     putStrLn $ "Completed " ++ show n ++ " tests. " ++ show f ++ " failures."
> runTests n f (t:ts) = do
>     pass <- t
>     runTests (n+1) (if pass then f else f + 1) ts
>
> main = runTests 0 0 tests