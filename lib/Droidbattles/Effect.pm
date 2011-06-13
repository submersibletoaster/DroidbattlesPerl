package Droidbattles::Effect;
use strict;
use warnings;

use Class::XSAccessor
    constructor => 'new',
    predicates => {
        has_position => 'position',
        has_velocity => 'velocity',
        has_direction=> 'direction',
        has_owner    => 'owner',
    },
    accessors => [qw(
        position
        direction
        velocity
        range
        owner
    )];
 


1;
