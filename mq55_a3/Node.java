// Mariana Quinde Garcia
// CS360 PA3 Problem 3 and 4
// Implement the recursive-descend parser of FCS 
// section 11.6 constructing parse trees of the grammar 
// of balanced parentheses
// Node class to represent a node with label,
// left child and right sibling
public class Node {
	char label;
	Tree leftmostChild;
	Tree rightSibling;
	
	public Node(char l) {
		this.label = l;
		this.leftmostChild = null;
		this.rightSibling = null;
	}
}
