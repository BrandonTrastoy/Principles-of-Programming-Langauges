module Project where

    data Tree a = Leaf a | Fork (Tree a) (Tree a) deriving (Show, Eq, Ord)
    data BST a = Tip | Bin (BST a) a (BST a) deriving (Show, Eq, Ord)

    -- Cartesian Product Of Two Lists
    cart :: [a] -> [b] -> [(a,b)]
    cart xs ys = [(x,y) | x <- xs, y <- ys]

    -- Standart Deviation of List
    stddev :: [Double] -> Double
    stddev xs = sqrt . average . map ((^2) . (-) axs) $ xs
           where average = (/) <$> sum <*> realToFrac . length
                 axs     = average xs

    -- Height of Tree 
    height :: Tree a -> Int
    height (Fork left right) = 1 + max (height left) (height right)
    height (Leaf _) = 0

    -- Returns the Minimum Element in the Tree
    minLeaf :: Ord a => Tree a -> a
    minLeaf (Fork left right) = min (minLeaf left) (minLeaf right)
    minLeaf (Leaf a) = a

    -- Return a list containing the elements of the tree in left-to-right order
    inorder :: Tree a -> [a]
    inorder tree = case tree of
        Leaf a -> a:[]
        Fork left right -> inorder left ++ inorder right

    -- Returns Boolean to check if item exist in the BST
    contains :: Ord a => a -> BST a -> Bool
    contains target tree = case tree of
        Tip -> False 
        Bin left x right | x == target -> True
        Bin left x right ->
            if target <= x 
            then (contains target left)
            else (contains target right) 

    -- Inserts into the BST
    insert :: Ord a => a -> BST a -> BST a
    insert value tree = case tree of
        Tip -> Bin Tip value Tip
        Bin left x right -> 
            if value <= x
            then Bin (insert value left) x right 
            else Bin left x (insert value right)

    -- Delete target from BST
    delete :: Ord a => a -> BST a -> BST a
    delete target Tip = Tip 
    delete target (Bin left value right)
        | target < value = Bin (delete target right) value right
        | target > value = Bin left value (delete target right)
        | target == value = Bin left value right


        





