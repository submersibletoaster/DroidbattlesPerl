package Droidbattles::Actor;
use strict;
use warnings;

use Class::XSAccessor
    true => [qw(
        has_position
        has_velocity
        has_direction
        has_armor
    )],
    false => [],
    accessors => [qw(
        position
        velocity
        direction
        armor
        size
    )];

sub defaults {
    (
    #$_[0]->SUPER::defaults, 
    armor => 100,
    direction => 0,
    velocity => 10,
    size => 512,
    );
}


sub new {
    my ($class,@args) = @_;
    my %self = ( $class->defaults() , @args );
    return bless \%self, ref($class)||$class;
    
}

sub damage {
    my ($self,$d) = @_;

    
}

1;
