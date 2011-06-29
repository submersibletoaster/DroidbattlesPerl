package Droidbattles::Effect::RocketTrail;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );

use Class::XSAccessor
    replace => 1,
    false => [ 'is_collidable' ],
    accessors => [qw( age maxage )];

sub new {
    my $class = shift;
    
    my $self = $class->SUPER::new(@_);
    $self->owner( '(null)' ) unless $self->owner;
    
    return $self;
}

sub defaults {
    $_[0]->SUPER::defaults,
    velocity => 300,
    size => 250,
    strength => 100,
    range => 9000,
    age => 0,
    maxage => 50,
}

sub step {
    my ($self,$arena) = @_;
    $self->age( $self->age+1 );
    $arena->destroy_element( $self => 'maxage' )
        if ( $self->age > $self->maxage );
        
}

1;
