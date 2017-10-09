// Mariana Quinde Garcia
// CS360 PA3
// Implements the recursive-descend parser of FCS 
// section 11.6 constructing parse trees of the grammar 
// of balanced parentheses
// To run:
// javac problem3.java
// java problem3 "()()()" (or any string desired, default runs 3 samples)

public class problem3 {
	// next index in string
	public static int next;
	// string to parse
	public static String inputString;
	// final tree
	public static Tree parseTree;
	
	// gets the next char in string
	public static char getNext(){
		return inputString.charAt(next);
	}
	
	// makes a tree with a root with label x
	// with no children or siblings
	public static Tree makeTree (char x) {
		Node root = new Node(x);
		return (new Tree(root));
	}
	
	// makes a tree with a root with label x
	// with tree t for a child	
	public static Tree makeTree(char x, Tree t) {
		Tree tree = makeTree(x);
		tree.root.leftmostChild = t;
		return tree;
	}
	
	// makes a tree with a root with label x
	// with t1 for a child and
	// with trees t2-t4 for siblings
	public static Tree makeTree(char x, Tree t1, Tree t2, Tree t3, Tree t4) {
		t3.root.rightSibling = t4;
		t2.root.rightSibling = t3;
		t1.root.rightSibling = t2;
		Tree tree = makeTree(x, t1);
		return tree;
	}

	// parses the input string into a tree
	public static Tree parse() {
		Tree t1, t2;
		// if left parenthesis, keep parsing to find right
		if((next < inputString.length()) &&(getNext() == '(')){
			next++;
			t1 = parse();
			// if right parenthesis keep parsing to find more B's
			if((t1 != null) && (getNext() == ')')) {
				next++;
				t2 = parse();
				// if null, then end of branch
				if(t2 == null) {
					return null;
				} else {
					// make tree with left and right parenthesis
					return makeTree('B', makeTree('('), t1, makeTree(')'), t2);
				}
			} else {
				return null;
			}
		} 
		// make tree with epsilon
		return makeTree('B', makeTree('e'));
	}
	
	public static void runParser(){
		parseTree = parse();
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
			inputString = "()()";
			runParser();
			next = 0;
			inputString = "(())(())";
			runParser();
			next = 0;
			inputString = "(()())()";
			runParser();
		}
		
	}
		
	
}
