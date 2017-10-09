/**
* Mariana Quinde Garcia
* CS360 PA3 Problem 1
* This program is a Prolog solution that answers the query of FCS problem
* 14.3.1 and proving the facts formulated in FCS problem 14.9.2.
* To run:
* csg("PH100", "L. Van Pelt", X).   (returns the grade as ascii list [67,43])
* csgFormat("PH100", "L. Van Pelt", X).  (returns actual grade (C+))
*
* before("CS120", "CS100").  (returns yes)
**/

/* problem 14.3.1 */
csg("PH100", "L. Van Pelt", "C+").
/* function to print actual grade and not ascii*/
csgFormat(C, S, X) :- csg(C, S, G), atom_codes(X, G).

/* problem 14.9.2 */
before("EE200", "EE005").
before("EE200", "CS100").
before("CS101", "CS100").
before("CS120", "CS101").
before("CS121", "CS120").
before("CS206", "CS121").
before("CS206", "CS205").
before("CS205", "CS101").
before(X, Y) :- X\=Y, before(X, Z), before(Z, Y), ! .

