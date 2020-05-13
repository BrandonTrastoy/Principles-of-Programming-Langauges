data RE a = Symbol a
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

matchhelp :: (Eq a) => RE a -> [a] -> (Bool, [a])
matchhelp Empty l = (True, l)
matchhelp (Symbol a) [] = (False, [])
matchhelp (Symbol a) (b:bs)
    | a == b = (True, bs)
    | otherwise = (False, [])
matchhelp (r :+: s) list = 
    where
    (m1, l1) = matchhelp r list 
    (m2, l2) = matchhelp s l1 

