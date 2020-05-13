Assignment 3: Simple Haskell programs
=====================================

Due October 26
Hand in by October 27 at 3:00 AM

For this assignment, you will create a Haskell module containing several
function and type definitions.

Instructions
------------

Create a Haskell module named Project. This will typically be in a file named
"Project.hs".

To define a module in Haskell, put the following code in the first line:

    module Project where

In your module, define the following data types exactly as shown:

    data Tree a = Leaf a | Fork (Tree a) (Tree a) deriving (Show, Eq, Ord)
    
    data BST a = Tip | Bin (BST a) a (BST a) deriving (Show, Eq, Ord)


Additionally, define the following functions:

- cart :: [a] -> [b] -> [(a,b)]

    Find the Cartesian product of two lists. The resulting list will contain
    pairs of elements taken from the two lists, starting with the first element
    of the first list paired with each element of the second list, in order,
    and proceeding from there.
    
    For example, cart [1,2,3] ['a','b'] returns
      [(1,'a'), (1, 'b'), (2, 'a'), (2, 'b'), (3, 'a'), (3, 'b')]

- stddev :: [Double] -> Double

    Calculate the standard deviation of a list of numbers. This is the square
    root of the mean squared differences between each number and the
    mean of all numbers.
    
    Neither the mean nor the standard deviation are defined for an empty list
    of numbers. You will not need to handle that case.
    
    For example, the mean of [1,1,1,5] is 2. The squared differences between
    each number and 2 are [1,1,1,9], the mean squared difference is 3, and
    its square root is 1.732....
    
    You should use the sqrt function. Recall that (^) raises a number to a
    power.
    
    You may use the standard length function, but recall that it returns an Int.
    To convert an Int to a Double, you may use fromIntegral.

- height :: Tree a -> Int

    Find the longest path from the root to the leaf, counting only Fork nodes.
    That is, the height of Leaf 'x' is 0 and the height of 
    Fork (Fork (Leaf 'a') (Leaf 'b')) (Leaf 'c') is 2.
    
    You may find the standard function max helpful.

- minLeaf :: Ord a => Tree a -> a

    Return the minimum element in the tree; i.e., an item in a Leaf which is 
    less than or equal to every other element.
    
    You may find the standard function min helpful.

- inorder :: Tree a -> [a]

    Return a list containing the elements of the tree in left-to-right order.
    
    inorder (Fork (Fork (Leaf 5) (Leaf 1)) (Leaf 7)) should return [5,1,7]

- contains :: Ord a => a -> BST a -> Bool

    Assuming that the tree is a binary search tree, determine whether the
    element is present in the tree.
    
    If t = Bin (Bin Tip 'a' Tip) 'b' Tip, then contains 'a' t == True
    and contains 'c' t == False.
    
    A BST is a binary search tree if, for every Bin l a r, all elements in l
    are less than or equal to a and all elements in r are greater than or
    equal to a.
    
    Your implementation should not examine every node in the tree. If the tree
    is not a true binary search tree, contains will be incorrect for some
    queries.
    
    So, if bad_tree = Bin (Bin Tip 'c' Tip) 'b', then contains 'c' bad_tree
    should be False.

- insert :: Ord a => a -> BST a -> BST a

    Return a new BST containing the element and all the elements in the old
    BST. If the old BST is a binary search tree, the new BST must be as well.
    Note that a binary search tree never contains duplicate elements.

    If t = Bin (Bin Tip 'a' Tip) 'b' Tip, then insert 'c' t might be
    Bin (Bin Tip 'a' Tip) 'b' (Bin Tip 'c' Tip).
    
    You are not required to balance the tree.

- delete :: Ord a => a -> BST a -> BST a

    Return a new BST containing all elements in the old BST that are not the
    specified element. If the old BST is a binary search tree, the new BST
    must be as well.
    
    If t = Bin (Bin Tip 'a' Tip) 'b' Tip, then delete 'b' t == Bin Tip 'a' Tip.
    
    You are not required to balance the tree.


While it is not necessary to provide type signatures for these functions, it
will help prevent you from writing code that is too specific. If your insert
function, for example, only works with BSTs containing integers, then it will 
not pass all test cases.

To submit your project, hand in only the Project.hs file.

Testing your code
-----------------

You can use ghci to try out your functions. Simply load ghci with your project

    ghci Project.hs

and you will be able to evaluate expressions 

Additionally, this file contains some test cases you may use to check your work.
Passing these tests is necessary but not sufficient to show your code correct.

To use this file, copy it to the same directory as your module and invoke ghci
with this command:

    runghc hw3.lhs

This will interpet this file and run the test cases given below.

Alternately, you may compile the test cases with this command:

    ghc hw3.lhs
    
This will create an executable named "hw3" that will run the tests. You
will need to recompile each time you modify your Project.

Note that hw3.lhs refers to the types and functions defined in your Project
module, so it won't compile unless all the definitions are there. If you wish
to test a partially written module, you can add dummmy definitions for any
functions you haven't written yet, e.g.:

    delete :: Ord a => a -> BST a -> BST a
    delete = undefined

(The type signature is optional.)

Tests
-----

This is a literate Haskell source file. Lines beginning with '>' are Haskell
source, everything else is ignored.

> module Main where
>
> import Project
> import Control.Exception (catch, ErrorCall(..), evaluate)

This section defines some trees that will be used by the test cases.

> t1, t2 :: Tree Int
> t1 = Fork (Leaf 5) (Fork (Leaf 3) (Leaf 2))
> t2 = Fork (Fork (Leaf 0) (Leaf 2)) (Fork (Fork (Leaf (-1)) (Leaf 8)) (Leaf 13))
>
> b1 :: BST Char
> b1 = Bin (Bin Tip 'a' Tip) 'b' (Bin Tip 'c' Tip)
> b2, bbad :: BST Int
> b2 = Bin (Bin Tip (-1) (Bin Tip 1 Tip)) 4 (Bin (Bin Tip 5 Tip) 6 (Bin Tip 7 Tip))
> bbad = Bin Tip 5 (Bin Tip 2 Tip)

Here are the test cases themselves. Each is defined using test or testBy,
and has a name, the value computed by your functions, and the expected value.

> tests =
>     [ test "cart [1,2,3] \"ab\""
>            (cart [1,2,3] "ab")
>            [(1,'a'),(1,'b'),(2,'a'),(2,'b'),(3,'a'),(3,'b')]
>     , test "cart [] [5,6,7]" (cart "" [5,6,7]) []
>     , testBy approx "stddev [1,1,1,5]" (stddev [1,1,1,5]) (sqrt 3)
>     , testBy approx "stddev [12,1.5,0.66,1000]" 
>           (stddev [12,1.5,0.66,1000]) 430.9920414578441
>     , test "height t1" (height t1) 2
>     , test "height t2" (height t2) 3
>     , test "minLeaf t1" (minLeaf t1) 2
>     , test "minLeaf t2" (minLeaf t2) (-1)
>     , test "inorder t1" (inorder t1) [5,3,2]
>     , test "inorder t2" (inorder t2) [0,2,-1,8,13]
>     , test "contains 'b' b1" (contains 'b' b1) True
>     , test "contains 2 b2" (contains 2 b2) False
>     , test "contains 2 bbad" (contains 2 bbad) False
>     , test "contains 'd' (insert 'd' b1)" (contains 'd' (insert 'd' b1)) True
>     , test "contains 'a' (delete 'a' b1)" (contains 'a' (delete 'a' b1)) False
>     , test "delete 5 b2"
>           (let b3 = delete 5 b2
>            in and
>               [ contains (-1) b3
>               , contains 1 b3
>               , contains 4 b3
>               , not (contains 5 b3)
>               , contains 6 b3
>               , contains 7 b3
>               ])
>           True
>     ]

The remaining functions evaluate the test cases and report whether they
succeeded. They involve features of Haskell that we have not yet discussed.

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
> approx x y = abs (x - y) / min x y <= 0.001
> 
> runTests n f [] = 
>     putStrLn $ "Completed " ++ show n ++ " tests. " ++ show f ++ " failures."
> runTests n f (t:ts) = do
>     pass <- t
>     runTests (n+1) (if pass then f else f + 1) ts
>
> main = runTests 0 0 tests