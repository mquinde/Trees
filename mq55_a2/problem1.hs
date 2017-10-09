--Mariana Quinde Garcia
--CS360 PA1 Problem 4
--This program defines a BST and functions member and insert from lab3
--It also defines a function "test g" to create a tree with g nodes
--inserted in random order. It calculates its weight balance difference 
--As we can see, the tree difference in weight balance between sibling
--nodes is very variable, which means that sometimes it is far from
--weight-balanced (see read me for further statement)
--To call: test a (where a is the number of nodes in BST e.g. test 100)

import System.Random
import Data.List

-- member and insert functions from lab3
-- Tree structure
data Tree a = Empty | Node a (Tree a) (Tree a) Int

-- prints tree with the weight of each node next to the value
instance Show a => Show (Tree a) where
  show Empty = " "
  show (Node b left right w) = show b ++ "*" ++ show w ++ "*(" ++ show left ++ "),(" ++ show right ++ ")"

-- Member checks if an elements exists in a list
memberT Empty a = False
memberT (Node b left right w) a 
	| a == b = True
	| a < b = memberT left a 
	| a > b = memberT right a

-- insert inserts an element into a list
insertT Empty a = Node a Empty Empty 1
insertT (Node b left right w) a
	| a == b = Node b left right w
	| a < b = Node b (insertT left a) right (w+1)
	| a > b = Node b left (insertT right a) (w+1)

-- generates a list with 1-a numbers in random order
genList :: Int -> StdGen -> [Int] 
genList a g = take a . nub $ (randomRs (1,a) g :: [Int])

-- makes a tree by inserting each element of a list in random order
makeTree [] Empty = Empty
makeTree [] (Node b left right w) = Node b left right w
makeTree (h:t) Empty = makeTree t (insertT Empty h)
makeTree (h:t) (Node b left right w) = makeTree t (insertT (Node b left right w) h)

-- checks if all elements in list are in tree (for testing only)
checkTree [] Empty = True
checkTree [] (Node b left right w) = True
checkTree (h:t) Empty = False
checkTree (h:t) (Node b left right w) = 
	if memberT (Node b left right w) h 
		then checkTree t (Node b left right w)
		else False

-- check how weight-balanced is the tree by returning the sum of the
-- weight difference of all sibling nodes
checkWeightBalance Empty = 0
checkWeightBalance (Node a Empty Empty w) = 0
checkWeightBalance (Node a (Node b lb rb wb) Empty  w) = wb + checkWeightBalance(Node b lb rb wb)
checkWeightBalance (Node a Empty (Node b lb rb wb) w) = wb + checkWeightBalance(Node b lb rb wb)
checkWeightBalance (Node a (Node b lb rb wb) (Node c lc rc wc) w) = abs(wb - wc) + checkWeightBalance(Node b lb rb wb) + checkWeightBalance(Node c lc rc wc)

-- creates a list 1-a, generates a tree and checks its
-- weight balance
test a = do 
	g <- newStdGen
	let list = genList a g
	let tree = makeTree list Empty
	let weightDiff = checkWeightBalance tree
	let balance = weightDiff  `div` a
	putStrLn ("The difference in weight for a tree of " ++ (show a) ++ " nodes is: " ++ (show weightDiff) ++ ". The weight balance ratio is:" ++ (show balance))
