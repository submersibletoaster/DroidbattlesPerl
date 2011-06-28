package Droidbattles::Effect::Missile;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );


use Droidbattles::Effect::RocketDebris;

use Class::XSAccessor
    replace => 1,
    accessors => [qw( strength origin )];

use Droidbattles::Arena::Functions qw( find_distance circles_overlap find_direction);

    
sub new {
    my $class = shift;
    
    my $self = $class->SUPER::new(@_);
    $self->position( [ @{$self->origin} ] );
    $self->owner( '(null)' ) unless $self->owner;
    
    return $self;
}

sub defaults {
    $_[0]->SUPER::defaults,
    velocity => 400,
    size => 350,
    strength => 100,
    range => 9000,
}



sub step {
    my ($self,$arena) = @_;
    $self->range( $self->range - 1);
    
    if ($self->range <= 0 ) {
        $arena->destroy_element($self,'out of range');
    } else {
    

        foreach my $e ( $arena->get_actors ) {
            # Politely safe to the weapon firer
            next if ($self->owner eq $e );
        
            if ( circles_overlap( $self->position, $self->size , $e->position, $e->size ) ) {
                warn "Missile collision with $e";
                $arena->damage( $e => $self->strength );
                $arena->destroy_element($self);
            }
            
            my $dist = find_distance($self->position,$e->position);
            if ($dist < 20000)  {
                my $dir = find_direction( $self->position , $e->position );
                my $offset = $dir - $self->direction ;
                $offset /= 10;
                my $new = abs( $self->direction - $dir ) / 2;
                $self->direction(   $dir );
            }
        }
    }
}

sub hook_destroy {
    my ($self,$arena) = @_;
    $arena->add_element( 
        new Droidbattles::Effect::RocketDebris
            position => [ @{ $self->position } ],
            direction => $self->direction,
            velocity  => $self->velocity / 3,
            maxage => 10,
            
    );
}

1;
