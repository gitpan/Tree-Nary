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
	my $failed_tests="";
	my $test;
	my $i;
	my $tstring;

	print "General tests...\n";

	if(Tree::Nary->depth($root) == 1 && Tree::Nary->max_height($root) == 1) {
		print "TEST 1 : ok\n";
	} else {
		print "TEST 1 : nok\n";
		$failed_tests .="1 ";
	}

	Tree::Nary->append($root, $node_B);
	if($root->{children} == $node_B) {
		print "TEST 2 : ok\n";
	} else {
		print "TEST 2 : nok\n";
		$failed_tests .="2 ";
	}

	Tree::Nary->append_data($node_B, "E");
	Tree::Nary->prepend_data($node_B, "C");
	Tree::Nary->insert($node_B, 1, Tree::Nary->new("D"));

	Tree::Nary->append($root, $node_F);
	if($root->{children}->{next} == $node_F) {
		print "TEST 3 : ok\n";
	} else {
		print "TEST 3 : nok\n";
		$failed_tests .="3 ";
	}

	Tree::Nary->append($node_F, $node_G);
	Tree::Nary->prepend($node_G, $node_J);
	Tree::Nary->insert($node_G, 42, Tree::Nary->new("K"));
	Tree::Nary->insert_data($node_G, 0, "H");
	Tree::Nary->insert($node_G, 1, Tree::Nary->new("I"));

	if(Tree::Nary->depth($root) == 1) {
		print "TEST 4 : ok\n";
	} else {
		print "TEST 4 : nok\n";
		$failed_tests .="4 ";
	}

	if(Tree::Nary->max_height($root) == 4) {
		print "TEST 5 : ok\n";
	} else {
		print "TEST 5 : nok\n";
		$failed_tests .="5 ";
	}

	if(Tree::Nary->depth($node_G->{children}->{next}) == 4) {
		print "TEST 6 : ok\n";
	} else {
		print "TEST 6 : nok\n";
		$failed_tests .="6 ";
	}

	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_LEAFS) == 7) {
		print "TEST 7 : ok\n";
	} else {
		print "TEST 7 : nok\n";
		$failed_tests .="7 ";
	}

	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_NON_LEAFS) == 4) {
		print "TEST 8 : ok\n";
	} else {
		print "TEST 8 : nok\n";
		$failed_tests .="8 ";
	}

	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_ALL) == 11) {
		print "TEST 9 : ok\n";
	} else {
		print "TEST 9 : nok\n";
		$failed_tests .="9 ";
	}

	if(Tree::Nary->max_height($node_F) == 3) {
		print "TEST 10: ok\n";
	} else {
		print "TEST 10: nok\n";
		$failed_tests .="10 ";
	}

	if(Tree::Nary->n_children($node_G) == 4) {
		print "TEST 11: ok\n";
	} else {
		print "TEST 11: nok\n";
		$failed_tests .="11 ";
	}

	# Find tests
	if(Tree::Nary->find_child($root, $Tree::Nary::TRAVERSE_ALL, "F") == $node_F) {
		print "TEST 12: ok\n";
	} else {
		print "TEST 12: nok\n";
		$failed_tests .="12 ";
	}

	if(!defined(Tree::Nary->find($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_NON_LEAFS, "I"))) {
		print "TEST 13: ok\n";
	} else {
		print "TEST 13: nok\n";
		$failed_tests .="13 ";
	}

	if(Tree::Nary->find($root, $Tree::Nary::IN_ORDER, $Tree::Nary::TRAVERSE_LEAFS, "J") == $node_J) {
		print "TEST 14: ok\n";
	} else {
		print "TEST 14: nok\n";
		$failed_tests .="14 ";
	}

	for($i = 0; $i < Tree::Nary->n_children($node_B); $i++) {
		$node = Tree::Nary->nth_child($node_B, $i);
	}

	$test = $Tree::Nary::TRUE;
	for($i = 0; $i < Tree::Nary->n_children($node_G); $i++) {
		if(Tree::Nary->child_position($node_G, Tree::Nary->nth_child($node_G, $i)) == $i) {
			$test &= $Tree::Nary::TRUE;
		} else {
			$test &= $Tree::Nary::FALSE;
		}
	}

	if($test) {
		print "TEST 15: ok\n";
	} else {
		print "TEST 15: nok\n";
		$failed_tests .= "15 ";
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

	# Next test should be TRUE
	if(Tree::Nary->is_ancestor($node_F, $node_G)) {
		print "TEST 16: ok\n";
	} else {
		print "TEST 16: nok\n";
		$failed_tests .="16 ";
	}

	# Next test should be FALSE
	if(!Tree::Nary->is_ancestor($node_G, $node_F)) {
		print "TEST 17: ok\n";
	} else {
		print "TEST 17: nok\n";
		$failed_tests .="17 ";
	}

	Tree::Nary->traverse($root, $Tree::Nary::PRE_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);

	if($tstring =~ /ABCDEFGHIJK/) {
		print "TEST 18: ok\n";
	} else {
		print "TEST 18: nok\n";
		$failed_tests .="18 ";
	}

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::POST_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);

	if($tstring =~ /CDEBHIJKGFA/) {
		print "TEST 19: ok\n";
	} else {
		print "TEST 19: nok\n";
		$failed_tests .="19 ";
	}

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::IN_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);

	if($tstring =~ /CBDEAHGIJKF/) {
		print "TEST 20: ok\n";
	} else {
		print "TEST 20: nok\n";
		$failed_tests .="20 ";
	}

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);

	if($tstring =~ /ABFCDEGHIJK/) {
		print "TEST 21: ok\n";
	} else {
		print "TEST 21: nok\n";
		$failed_tests .="21 ";
	}

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_LEAFS, -1, \&node_build_string, \$tstring);

	if($tstring =~ /CDEHIJK/) {
		print "TEST 22: ok\n";
	} else {
		print "TEST 22: nok\n";
		$failed_tests .="22 ";
	}

	$tstring = undef;
	Tree::Nary->traverse($root, $Tree::Nary::PRE_ORDER, $Tree::Nary::TRAVERSE_NON_LEAFS, -1, \&node_build_string, \$tstring);

	if($tstring =~ /ABFG/) {
		print "TEST 23: ok\n";
	} else {
		print "TEST 23: nok\n";
		$failed_tests .="23 ";
	}

	$tstring = undef;

	Tree::Nary->reverse_children($node_B);
	Tree::Nary->reverse_children($node_G);
	Tree::Nary->traverse($root, $Tree::Nary::LEVEL_ORDER, $Tree::Nary::TRAVERSE_ALL, -1, \&node_build_string, \$tstring);

	if($tstring =~ /ABFEDCGKJIH/) {
		print "TEST 24: ok\n";
	} else {
		print "TEST 24: nok\n";
		$failed_tests .="24 ";
	}

	# Tree::Nary->DESTROY($root);

	print "\nAllocation tests...\n";

	$root = Tree::Nary->new();
	$node = $root;

	for($i = 0; $i < 2048; $i++) {

		Tree::Nary->append($node, Tree::Nary->new());

		if(($i%5) == 4) {
			$node = $node->{children}->{next};
		}
	}

	if(Tree::Nary->max_height($root) > 100) {
		print "TEST 25: ok\n";
	} else {
		print "TEST 25: nok\n";
		$failed_tests .="25 ";
	}

	if(Tree::Nary->n_nodes($root, $Tree::Nary::TRAVERSE_ALL) == 1 + 2048) {
		print "TEST 26: ok\n";
	} else {
		print "TEST 26: nok\n";
		$failed_tests .="26 ";
	}

	# Tree::Nary->DESTROY($root);

	if(length($failed_tests) == 0) {
		print "\nAll tests passed successfully\n";
	} else {
		print "\nErrors have been found in test(s) $failed_tests\n";
	}

}

&node_test();
