// Mariana Quinde Garcia
// CS360 PA3 Problem 3 and 4
// Implement the recursive-descend parser of FCS 
// section 11.6 constructing parse trees of the grammar 
// of balanced parentheses
// Tree class with a root and methods to print in pre-order
// and post-order and compute height
public class Tree {
	Node root;

	public Tree(Node root){
		this.root = root;
	}

	public Tree getLeftMostChild(){
		if(root == null) {
			return null;
		} 
		return root.leftmostChild;
	}

	public Tree getRightSibling(){
		if(root == null) {
			return null;
		} 
		return root.rightSibling;
	}

	// computes height
	public int getHeight(){
		int h = 0;
		Node node = this.root;
		if(node != null) {
			// if no children, height is 0
			if(node.leftmostChild == null) {
				return 0;
			}

			// if children, get height of highest child
			Tree child = node.leftmostChild;
			while(child != null){
				if(child.getHeight() > h){
					h = child.getHeight();
				}
				child = child.getRightSibling();				
			}
			// add 1 for total height 
			h++;
		}
		return h;
	}

	// prints in formatted way
	public void print(){
		Node node = this.root;
		System.out.print(node.label);
		if(node.label!='e') {
			System.out.print(" ");
			if(node.leftmostChild != null) {
				System.out.print("[");
				node.leftmostChild.print();
				System.out.print("] ");
			}
			if(node.rightSibling != null) {
				node.rightSibling.print();
			}
		}
	}

	// prints in pre-order
	public void printPreOrder(){
		Node node = this.root;
		System.out.print(node.label);
		if(node.leftmostChild != null) {
			node.leftmostChild.printPreOrder();
		}
		if(node.rightSibling != null) {
			node.rightSibling.printPreOrder();
		}

	}

	// prints in pre-order
	public void printPostOrder(){
		Node node = this.root;
		if(node.leftmostChild != null) {
			node.leftmostChild.printPostOrder();
		}
		System.out.print(node.label);
		if(node.rightSibling != null) {
			node.rightSibling.printPostOrder();
		}

	}
}