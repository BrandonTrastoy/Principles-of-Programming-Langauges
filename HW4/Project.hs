module Project where

    data RE a            -- regular expressions over an alphabet defined by 'a'
        = Empty          -- empty regular expression
        | Sym a          -- match the given symbol
        | RE a :+: RE a  -- concatenation of two regular expressions
        | RE a :|: RE a  -- choice between two regular expressions
        | Rep (RE a)     -- zero or more repetitions of a regular expression
        | Rep1 (RE a)    -- one or more repetitions of a regular expression
        deriving (Show)

    matchEmpty :: RE a -> Bool
    matchEmpty x = case x of
        
        a :|: b -> matchEmpty a || matchEmpty b
        a :+: b -> matchEmpty a && matchEmpty b
        Empty -> True
        Sym _ -> False
        Rep _ -> True
        
        Rep1 (a :|: Empty) -> True
        Rep1 (Empty :|: b) -> True
        Rep1 _ -> False

    
    combine :: [z] -> [z] -> [z]
    combine xs     []     = xs
    combine []     ys     = ys
    combine (x:xs) (y:ys) = x : y : combine xs ys
   

    firstMatches :: RE a -> [a]
    firstMatches x = case x of
        
        a :|: b -> if matchEmpty a
                   then combine (firstMatches a) (firstMatches b)
                   else firstMatches a
        
        a :+: b -> if matchEmpty a
                   then combine (firstMatches a) (firstMatches b) 
                   else firstMatches a

        Rep (a :|: b) -> combine (firstMatches a) (firstMatches b)
        Rep a -> firstMatches a

        Rep1 a -> firstMatches a

        Empty -> []
        Sym a -> [a]












