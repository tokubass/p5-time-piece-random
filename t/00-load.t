#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Time::Piece::Random' ) || print "Bail out!\n";
}

diag( "Testing Time::Piece::Random $Time::Piece::Random::VERSION, Perl $], $^X" );
