package Droidbattles::Effect::Rocket;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );


use Droidbattles::Effect::RocketDebris;
use Droidbattles::Effect::RocketTrail;

use Class::XSAccessor
    replace => 1,
    accessors => [qw( strength origin distance )];

use Droidbattles::Arena::Functions qw( find_distance circles_overlap );

    
sub new {
    my $class = shift;
    
    my $self = $class->SUPER::new(@_);
    $self->position( [ @{$self->origin} ] );
    $self->owner( '(null)' ) unless $self->owner;
    
    return $self;
}

sub defaults {
    $_[0]->SUPER::defaults,
    velocity => 220,
    size => 175,
    strength => 100,
    range => 9000,
}



sub step {
    my ($self,$arena) = @_;
    
    my $travel = find_distance( $self->position , $self->origin );
    
    # Emit rocket trails
    if ( $arena->ticks % 5 == 0 ) {
        $arena->add_element(
            new Droidbattles::Effect::RocketTrail
                direction => $self->direction - 512 - 64 + rand(128),
                position => [ @{ $self->position } ],
        );
    }
    
    # Wait until travelled desired range
    return unless $travel >= $self->distance;


    # We have reached our distance - explode.
    foreach my $e ( $arena->get_actors ) {
        # Politely safe to the weapon firer
        next if ($self->owner eq $e );
        
        
        if ( circles_overlap( $self->position, $self->range , $e->position, $e->size ) ) {
            my $target_range = find_distance( $self->position , $e->position );
            my $power = $target_range / $self->range;
            my $effect = $self->strength * $power;
            warn "Rocket Hit $e with $effect ";
            $arena->damage( $e => $effect );
            
        }
    }
    
    $arena->destroy_element($self);

    $arena->add_element( 
        new Droidbattles::Effect::RocketDebris
            position => [ @{ $self->position } ],
            direction => $self->direction,
            velocity  => $self->velocity / 3,
            maxage => 50,
            
    );

}

1;
