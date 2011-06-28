#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';

use AnyEvent;
use Benchmark 'timethis';

use t::lib::Game1;

my $arena = new t::lib::Game1;


timethis( 10000, sub {eval{$arena->simulate}} );
__END__

my $dt = AnyEvent->timer( interval => 1, cb=>sub{print Dumper $arena->get_actors} );

my $timer = AnyEvent->timer(
    after => 1/50 , interval => 10/50 , cb => 
    sub { $arena->simulate; }
);

AnyEvent->condvar->recv;


