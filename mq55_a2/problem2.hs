--Mariana Quinde Garcia
--CS360 PA2 Problem 2
--This program defines the huffman algorithm, and encodes and 
-- decodes sample-messages and sample-trees 
--from examples in week 2 (figures 1-2) to encode and decode 
--To call: testDecode1 (for tree 1)
--			  testEncode2 (for tree 2)

-- Tree structure
data Tree a = Leaf a Int | Node a (Tree a) (Tree a) Int 

-- Print tree
instance Show a => Show (Tree a) where 
	show (Leaf a w) = show a
	show (Node b lc rc w) = show b ++ "(" ++ show lc ++ "),(" ++ show rc ++ ")"

-- makes a set with the union of symbols of children nodes
symbols (Leaf a w) = a
symbols (Node a lc rc w) = symbols(lc) ++ symbols(rc)

-- gets the weight of node: some of the weight of its children
weight (Leaf a w) = w
weight (Node a lc rc w) = w

-- makes a tree with lc and rc as children
makeTree lc rc = Node (symbols(lc) ++ symbols(rc)) lc rc (weight(lc) + weight(rc))

-- chooses which branch to take when traversing tree in decode
chooseBranch 0 (Node a lc rc w) = lc
chooseBranch 1 (Node a lc rc w) = rc

-- decodes a binary message ls into a word for the tree
decode ls tree = decode1 ls tree
	where 
			decode1 [] (Node a lc rc w) = [] 
			decode1 l (Leaf a w) = a ++ decode l tree
			decode1 (h:t) (Node a lc rc w) = decode1 t (chooseBranch h (Node a lc rc w))

-- checks in x is member of the tree
memberT (Leaf a w) x 
	| a == x = True
	| otherwise = False
memberT (Node a lc rc w) x 
	| (memberT lc) x = True
	| (memberT rc) x = True
	| otherwise = False

-- encodes a message in characters into binary according to the tree
encode ls tree = encodeSymbol ls tree
	where 
			encodeSymbol [] (Leaf a w) = []
			encodeSymbol [] (Node a lc rc w) = []
			encodeSymbol (h:t) (Leaf a w) = encodeSymbol t tree
			encodeSymbol (h:t) (Node a lc rc w) = if (memberT lc h) then 0:(encodeSymbol (h:t) lc) else 1:(encodeSymbol (h:t) rc)

-- decodes message for tree in figure 1
testDecode1 = do
	let tree = makeTree (Leaf "A" 1) (makeTree (makeTree (Leaf "B" 0) (Leaf "C" 1)) (Leaf "D" 1))
	let message = [1,0,0,1,0,1,1,1,0]
	let dm = decode message tree
	print dm

-- encodes message for tree in figure 1
testEncode1 = do
	let tree = makeTree (Leaf "A" 1) (makeTree (makeTree (Leaf "B" 0) (Leaf "C" 1)) (Leaf "D" 1))
	let message = ["B", "C", "D", "A"]
	let em = encode message tree
	print em

-- decodes message for tree in figure  2
testDecode2 = do
	let tree = makeTree (makeTree (Leaf "D" 22) (Leaf "E" 23)) (makeTree (Leaf "F" 27) (makeTree (Leaf "C" 12) (makeTree (Leaf "A" 7) (Leaf "B" 9))))
	let message = [1,0,1,1,1,0,1,1,0,0,1,1,1,1,1]
	let dm = decode message tree
	print dm

-- encodes message for tree in figure 2
testEncode2 = do	
	let tree = makeTree (makeTree (Leaf "D" 22) (Leaf "E" 23)) (makeTree (Leaf "F" 27) (makeTree (Leaf "C" 12) (makeTree (Leaf "A" 7) (Leaf "B" 9))))
	let message = ["F","A","C","E","B"]
	let em = encode message tree
	print em
