(*Mariana Quinde Garcia
CS360 PA1 Problem 4
This program defines the huffman algorithm, sample-messages and sample-trees 
from examples in week 2 (figures 1-2) to encode and decode 
To call: decode (decodeMessage2, sampleTree2)
         encode (encodeMessage2, sampleTree2) 
replace with 1 for small tree, or use other messages and trees*)
(*Datatype for a huffman tree, it can be a leaf or a node (a tree with two child
branches) It has a symbol(string) and a weight(int)*)
datatype Tree = Leaf of string * int  
                  | Node of Tree * Tree * string * int;

(*makes a set with the union of all sets of symbols in a tree*)
fun symbols(Leaf(symbol, n)) = symbol
  | symbols(Node(lChild, rChild, symbol, n)) = symbols(lChild) ^ symbols(rChild);

(*gets the weight of a tree: the sum of the weights of its children*)
fun weight(Leaf(symbol, n)) = n
  | weight(Node(lChild, rChild, symbol, n)) = n;

(* Makes a tree with left and right children*)
fun makeTree(lChild, rChild) = 
     Node(lChild, rChild, symbols(lChild) ^ symbols(rChild), weight(lChild) + weight(rChild));

(* Chooses left branch for 0 and right branch for 1*)
fun chooseBranch(0, Node(lChild, rChild, s, w)) = lChild
  | chooseBranch(1, Node(lChild, rChild, s, w)) = rChild;

(*Takes a list in binary and a tree and decodes the list according to the symbols of the tree.
It traverses the tree using the list (using chooseBranch to take each branch) and stores the
symbols to when it arrives to a leaf*)
fun decode(bits, tree) =
   let fun decode_1([], currentBranch) = []
        | decode_1(a::t, currentBranch) =
           let val nextBranch = chooseBranch(a, currentBranch);
         in case nextBranch of
         Leaf(symbol, n) =>  symbol::decode_1(t, tree)
         | Node(lChild, rChild, syms, n) => decode_1(t, nextBranch)
       end;
     in decode_1(bits, tree)
   end;


fun encodeSymbol(symbol, tree) = 
   let fun encodeSymbol_1(s, Leaf(ch, n)) = if ch = s then SOME [] else NONE
   | encodeSymbol_1(s, Node(lChild, rChild, ch, n)) = 
   case (encodeSymbol_1(s, lChild), encodeSymbol_1(s, rChild)) of
   (NONE, NONE) => NONE
   | (NONE, SOME bits) => SOME (1::bits)
   | (SOME bits, x) => SOME (0::bits);
 in valOf(encodeSymbol_1(symbol,tree))
end;


(*Takes a list with a message and a tree and returns a list in binary with the codification
of the message for the tree. It traverses the tree and returns the correct binary code for
each char in the message*)
fun encode([], tree) = []
  | encode(h::t, tree) = 
       encodeSymbol(h, tree) @ encode(t, tree);

(*Test samples corresponding to trees and messages in figure 1 and 2 of week 2 exampkes *)
(*small tree*)
val sampleTree1 = makeTree(Leaf("A", 1),
                    makeTree(
                      makeTree(
                        Leaf("B", 0),
                        Leaf("C", 1)), 
                      Leaf("D", 1)));
      
val decodeMessage1 = [1,0,0,1,0,1,1,1,0];
val encodeMessage1 = ["B","C","D","A"];

(*big tree*)
val sampleTree2 = makeTree(
                    makeTree(
                      Leaf("D", 22),
                      Leaf("E", 23)),
                    makeTree(
                      Leaf("F", 27),
                      makeTree( 
                        Leaf("C", 12),
                        makeTree(
                          Leaf("A",7),
                          Leaf("B", 9)))));
      
val decodeMessage2 = [1,0,1,1,1,0,1,1,0,0,1,1,1,1,1];
val encodeMessage2 = ["F","A","C","E","B"];

