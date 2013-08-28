package Catchme;

use strict;
use warnings;

require Exporter;
our @ISA       = qw/Exporter/;
our @EXPORT    = qw/catchme/;
our @EXPORT_OK = qw/forgetmenot/;

our $VERSION = "0.01";

use Carp;

sub catchme($&) {

    return 1 unless $@;

    my $exception = $@;

    my $types   = shift;
    my $coderef = shift;

    if ( ! ref( $types ) ) {
        $types = [ $types ];
    }

    if ( grep { $exception->isa( $_ ) } @{ $types } ) {

       local $@ = $exception;
       $coderef->();

    } else {

        die $exception;

    }

}

sub forgetmenot($&) {

    goto &catchme;

}

1;
