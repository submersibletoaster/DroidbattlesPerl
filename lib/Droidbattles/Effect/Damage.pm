package Droidbattles::Effect::Damage;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );

use Class::XSAccessor
    false => ['is_collidable'],
    accessors => [qw( maxage age range)];

sub defaults {
    shift->SUPER::defaults,
    velocity => 0,
    size => 100,
    maxage => 75,
    age => 0,
}


sub step {
    my ($self,$arena) = @_;
    
    $self->{started} ||= $arena->ticks;
    
    $self->age( $self->age+1 );
    
    
    $self->size( $self->size + $self->range );
    
    $arena->destroy_element( $self )
        if ($self->age >  $self->maxage );
    
    
}

1;
