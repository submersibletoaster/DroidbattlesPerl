#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';

use AnyEvent;
use Benchmark 'timethis';

use Droidbattles::Arena;
use Droidbattles::Arena::Functions;
use Droidbattles::Effect::OutOfBounds;
use Droidbattles::Effect::Newton2D;
use Droidbattles::Effect::Plasmaround;
use Droidbattles::Droid;

use Data::Dumper;

$Data::Dumper::Indent=1;

my $arena = new Droidbattles::Arena;
my $bounds = new Droidbattles::Effect::OutOfBounds 
                    range => [ 2 ** 16 , 2 ** 16 ];
my $physics = new Droidbattles::Effect::Newton2D;
my $testdroid = new Droidbattles::Droid
                    position => [ 512,0 ],
                    direction=> 270,
                    velocity => 35;
                    
my $plasmaround = new Droidbattles::Effect::Plasmaround
                        origin => [-1000,0],
                        direction => 90;

## Fill the arena
$arena->add_element( 
 $_
) for (
    $physics,
    $bounds,
    $testdroid,
    $plasmaround
);


#timethis( 100000, sub {$arena->simulate} );
#__END__

my $dt = AnyEvent->timer( interval => 1, cb=>sub{print Dumper $arena->get_actors} );

my $timer = AnyEvent->timer(
    after => 1/50 , interval => 10/50 , cb => 
    sub { $arena->simulate; }
);

AnyEvent->condvar->recv;


