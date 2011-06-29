package Droidbattles::Effect::Debris;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );

use Class::XSAccessor
    false => ['is_collidable'],
    accessors => [qw( maxage age started )];

sub defaults {
    shift->SUPER::defaults,
    velocity => 10,
    size => 1000,
    maxage => 75,
    age => 0,
}


sub step {
    my ($self,$arena) = @_;
    
    $self->{started} ||= $arena->ticks;
    
    $self->age( $self->age+1 );
    $self->size( $self->size * 0.99 );
    
    $arena->destroy_element( $self )
        if ($arena->ticks > $self->maxage + $self->started );
    
    
}







1;
