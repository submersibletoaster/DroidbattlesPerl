package Droidbattles::Effect;
use strict;
use warnings;

use Class::XSAccessor
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
        size
    )];
 
sub defaults {
    direction => 0 ,
    velocity => 10,
    range => 10,
    size => 10

}

sub new {
    my ($class,@args) = @_;
    my %self = ( $class->defaults() , @args );
    return bless \%self, ref($class)||$class;
    
}

1;
