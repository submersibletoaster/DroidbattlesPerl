package Droidbattles::Actor;
use strict;
use warnings;

use Class::XSAccessor
    predicates => {
        has_position => 'position',
        has_size => 'size',
        has_velocity => 'velocity' ,
        has_direction => 'direction',
        has_armor => 'armor',
    },
    true => [qw(
        is_actor 
        is_collidable
    )],
    false => [qw(is_effect)],
    
    accessors => [qw(
        position
        velocity
        direction
        armor
        size
        id
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

sub collision_box {
    my $self = shift;
    my $pos = $self->position;
    my $size = $self->size;
    return (
        $pos->[0] - $size,
        $pos->[1] - $size,
        $pos->[0] + $size,
        $pos->[1] + $size
    )
    
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
