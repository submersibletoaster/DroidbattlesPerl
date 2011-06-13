package Droidbattles::Actor;
use strict;
use warnings;

use Class::XSAccessor
    constructor => 'new',
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
    )];
    
sub damage {
    my ($self,$d) = @_;

    
}

1;
