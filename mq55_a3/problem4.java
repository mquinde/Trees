// Mariana Quinde Garcia
// CS360 PA3 Problem 4
// Implements the table driven parsing algorithm of FCS section 11.7 
// constructing parse trees of the grammar of simple programming statements 
// (FCS figure 11.33). Uses a stack as explained in FCS figure 11.34.
// It also prints height and pre and post order traversals
// To run:
// javac problem4.java
// java problem4 "{wcs;s;}" (or any string desired, default is runs three examples)

import java.util.ArrayList;
import java.util.List;

public class problem4 {
	// position in input
	public static int next;
	public static String inputString;
	public static List<Character> stack;
	
	// get lookahead in put
	public static char getLookahead(){
		return inputString.charAt(next);
	}
	
	// replace head of stack with new production
	public static void expandHeadProduction(List<Character> production){
		stack.remove(0);
		stack.addAll(0, production);
	}
	
	// Get a string as a list of chars
	public static List<Character> getAsList(String str){
		ArrayList<Character> l = new ArrayList<Character>();
		for (int i = 0; i<str.length(); i++){
			l.add(str.charAt(i));
		}
		return l;
	}
	
	// get a production that matches the lookahead
	public static List<Character> getMatchProduction(){
		char c = getLookahead();
		char head = stack.get(0);
		if(head == 'S'){
			// possible production w c S
			if(c == 'w'){
				return getAsList("wcS");
			} // possible production { T
			else if(c == '{') {
				return getAsList("{T");
			} // possible production s ;
			else if(c == 's'){
				return getAsList("s;");
			}
		} else if (head == 'T'){
			// possible production }
			if(c == '}'){
				return getAsList("}");
			} 
			 // possible production S T
			return getAsList("ST");
		}
		
		return new ArrayList<Character>();
	}
	
	// make a tree with a root with label an right sibling
	public Tree makeTree(Character label, Tree rightSibling){
		Node childNode = new Node(label);
		childNode.rightSibling = rightSibling;
		return new Tree(childNode);
	}
	
	// make a tree with node for root and children of root
	public static Tree makeTree(Node node, List<Tree> children){
		Tree tree = new Tree(node);
		for(int i = (children.size()-2); i >= 0; i--) {
			if(children.get(i) != null){
				children.get(i).root.rightSibling = children.get(i+1);
			}
		}
		tree.root.leftmostChild = children.get(0);
		return tree;
	}
	
	// parses the input string into a tree
	public static Tree parse(Node node){
		// if the lookahead matches head of stack, pop
		if(getLookahead() == stack.get(0)){
			next++;
			stack.remove(0);
			return new Tree(node);
		} else {
			// find production that matches
			List<Character> prod = getMatchProduction();
			// update stack
			expandHeadProduction(prod);
			// create children trees for production
			List<Tree> children = new ArrayList<Tree>();
			for(int i = 0; i < prod.size(); i++) {
				Node childNode = new Node(prod.get(i));
				children.add(parse(childNode));
			}
			// return tree with children
			return makeTree(node, children);
		}
	}
	
	// runs parser with current input string
	public static void runParser() {
		stack = new ArrayList<Character>();
		stack.add('S');
		// init tree with one node labeled S
		Tree parseTree = parse(new Node('S'));
		// shw results
		System.out.println("Input = " + inputString);
		System.out.println("Height: " + parseTree.getHeight());
		System.out.println("Pre-Order:");
		parseTree.printPreOrder();
		System.out.println("\nPost-Order:");
		parseTree.printPostOrder();
		System.out.println("\n");
	}
	
	public static void main (String[] args){
		if(args.length>0){
			// run with input
			next = 0;
			inputString = args[0];
			runParser();
		} else {
			// run with sample test cases
			next = 0;
			inputString = "{wcs;s;}";
			runParser();
			next = 0;
			inputString = "{{s;s;}s;}";
			runParser();
			next = 0;
			inputString = "{{wcs;s;}s;}";
			runParser();
		}
	}
}
