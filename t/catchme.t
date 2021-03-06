#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN {
    use_ok( 'Catchme' );
};

eval {

    die TestException->new( 'Exception Raised' );

};

catchme 'TestException' => sub {
    like( $@, qr/Exception Raised/, 'catch TestException' );
};


eval {
    die "Exception Re-raised";
};

my $exception = $@;

eval {
    local $@ = $exception;

    catchme 'Exception' => sub {
        die "not catch";
    };
    
};

like( $@, qr/Exception Re-raised/, 'not catch exception - rethrow');



done_testing();

package TestException;

use strict;
use warnings;

use overload (
        q{""}    => 'to_string',
        fallback => 1,
        );

sub new {
    my ( $class, $msg ) = @_;

    my $self = {
        msg => $msg,
    };

    bless $self, $class;
}

sub to_string {
    my $self = shift;

    return $self->{msg};
}
