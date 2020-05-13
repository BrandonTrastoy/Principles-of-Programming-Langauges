module classPractice where

    data RE a = Symbol 
            | Empty
            | RE a :+: RE a 
            | RE a :|: RE a
            | Rep (RE a)
            | Rep1 (RE a)
            deriving (Show)


    optional :: RE a -> RE a
    optional r = r :|: Empty

    -- (a|b)*
    abstar = Rep (Symbol 'a' :|: Symbol 'b')

    -- aa+
    twoas = Symbol 'a' :+: Rep1 (Symbol 'a')

    match :: (Eq a) => RE a -> [a] -> Bool
    match Empty [] = True 
    match Empty _ = False
    match (Symbol a) [b] | a == b = True

    match (r :+: s) l = match r (prefix l) && match s (suffix l)

    