use Tree::Nary;

use strict;

sub node_build_string() {

	my ($node, $ref_of_arg) = (shift, shift);
	my $p = $ref_of_arg;
	my $string;
	my $c;

	$c = $node->{data};
	if(defined($p)) {
		$string = $$p;
	} else {
		$string = "";
	}

	$string .= $c;
	$$p = $string;
	
	return($Tree::Nary::FALSE);
}

sub node_test() {

	my $root = Tree::Nary->new("A");
	my $node = Tree::Nary->new();
	my $node_B = Tree::Nary->new("B");
	my $node_F = Tree::Nary->new("F");
	my $node_G = Tree::Nary->new("G");
	my $node_J = Tree::Nary->new("J");
	my $i;
	my $tstring;

	if(Tree::Nary->depth($root) == 1 && Tree::Nary->max_height($root) == 1) {
		print "depth and max height of root node are OK\n";
	}

	Tree::Nary->append($root, $node_B);
	if($root->{children} == $node_B) {
		print "node_B is child of root node\n";
	}
	Tree::Nary->append_data($node_B, "E");
	Tree::Nary->prepend_data($node_B, "C");
	Tree::Nary->insert($node_B, 1, Tree::Nary->new("D"));

	Tree::Nary->append($root, $node_F);
	if($root->{children}->{next} == $node_F) {
		print "node_F is the next child of root node\n";
	}
	Tree::Nary->append($node_F, $node_G);
	Tree::Nary->prepend($node_G, $node_J);
	Tree::Nary->insert($node_G, 42, Tree::Nary->new("K"));
	Tree::Nary->insert_data($node_G, 0, "H");
	Tree::Nary->insert($node_G, 1, Tree::Nary->new("I"));

	if(Tree::Nary->depth($root) == 1) {
		print "root height = 1\n";
	}
	if(Tree::Nary->max_height($root) == 4) {
		print "height of tree is 4\n";
	}
	if(Tree::Nary->depth($node_G->{children}->{next}) == 4) {
		print "node_G->{children}->{next} == 4\n";
	}
	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_LEAFS) == 7) {
		print "7 leaves\n";
	}
	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_NON_LEAFS) == 4) {
		print "4 internal nodes\n";
	}
	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_ALL) == 11) {
		print "11 nodes\n";
	}
	if(Tree::Nary->max_height($node_F) == 3) {
		print "node F max height is 3\n";
	}
	if(Tree::Nary->n_children($node_G) == 4) {
		print "node G has 4 children\n";
	}

	# Find tests
	if(Tree::Nary->find_child($root, $Tree::Nary::TRAVERSE_ALL, "F") == $node_F) {
		print "Found node_F\n";
	}
	if(!defined(Tree::Nary->find($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_NON_LEAFS, "I"))) {
		print "Undefined node found\n";
	}
	if(Tree::Nary->find($root, $Tree::Nary::IN_ORDER, $Tree::Nary::TRAVERSE_LEAFS, "J") == $node_J) {
		print "Found node_J\n";
	}

	for($i = 0; $i < Tree::Nary->n_children($node_B); $i++) {
		$node = Tree::Nary->nth_child($node_B, $i);
		printf "node(%d)->data = %s\n", $i, $node->{data};
	}
	for($i = 0; $i < Tree::Nary->n_children($node_G); $i++) {
		if(Tree::Nary->child_position($node_G, Tree::Nary->nth_child($node_G, $i)) == $i) {
			print "PASSED.\n";
		}
	}

	#     We have built:                    A
	#                                     /   \
	#                                   B       F
	#                                 / | \       \
	#                               C   D   E       G
	#                                             / /\ \
	#                                           H  I  J  K
	#    
	#     For in-order traversal, 'G' is considered to be the "left" child
	#     of 'F', which will cause 'F' to be the last node visited.

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::PRE_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);
	if($tstring =~ /ABCDEFGHIJK/) {
		print "tstring is ABCDEFGHIJK\n";
	}
	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::POST_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);
	if($tstring =~ /CDEBHIJKGFA/) {
		print "tstring is CDEBHIJKGFA\n";
	}
	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::IN_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);
	if($tstring =~ /CBDEAHGIJKF/) {
		print "tstring is CBDEAHGIJKF\n";
	}
	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);
	if($tstring =~ /ABFCDEGHIJK/) {
		print "tstring is ABFCDEGHIJK\n";
	}
	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_LEAFS, -1, \&node_build_string, \$tstring);
	if($tstring =~ /CDEHIJK/) {
		print "tstring is CDEHIJK\n";
	}
	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::PRE_ORDER, $Tree::Nary::TRAVERSE_NON_LEAFS, -1, \&node_build_string, \$tstring);
	if($tstring =~ /ABFG/) {
		print "tstring is ABFG\n";
	}
	$tstring = undef;

	Tree::Nary->reverse_children($node_B);
	Tree::Nary->reverse_children($node_G);
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);
	if($tstring =~ /ABFEDCGKJIH/) {
		print "tstring is ABFEDCGKJIH\n";
	}

	# Tree::Nary->DESTROY($root);

	# Allocation tests ?
	$root = Tree::Nary->new();
	$node = $root;

	for($i = 0; $i < 2048; $i++) {

		Tree::Nary->append($node, Tree::Nary->new());

		if(($i%5) == 4) {
			$node = $node->{children}->{next};
		}
	}

	if(Tree::Nary->max_height($root) > 100) {
		print "Max height from root node > 100\n";
	}
	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_ALL) == 1 + 2048) {
		print "There are 2049 nodes\n";
	}

	# Tree::Nary->DESTROY($root);
}

&node_test();
