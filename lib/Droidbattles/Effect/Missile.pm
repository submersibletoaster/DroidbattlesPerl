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
    velocity => 150,
    size => 200,
    strength => 100,
    range => 9000,
}



sub step {
    my ($self,$arena) = @_;
    $self->range( $self->range - 1);
    
    if ($self->range <= 0 ) {
        $arena->destroy_element($self,'out of range');
    } else {
    
        my $nearby = $arena->qt->getEnclosedObjects(
                $self->position->[0] - 20000,
                $self->position->[1] - 20000,
                $self->position->[0] + 20000,
                $self->position->[1] + 20000,
        );
        
        foreach my $hit ( @$nearby ) {
            my $e = $arena->get_object_by_id($hit) || next;
            next unless $e->is_actor;
            next if $self->owner eq $e;
            
            my $dist = find_distance($self->position,$e->position);
            if ($dist < 20000)  {
                my $dir = find_direction( $self->position , $e->position );
                my $offset = $dir - $self->direction ;
                $offset /= 10;
                my $new = abs( $self->direction - $dir ) / 2;
                $self->direction(   $dir );
                last;
            }
        }
    }
    
}

sub hook_collision {
    my ($self,$arena,$e) = @_;
    return if $self->owner eq $e;
    
    if ( circles_overlap( $self->position, $self->size , $e->position, $e->size ) ) {
        warn "Missile collision with $e";
        $arena->damage( $e => $self->strength );
        $arena->destroy_element($self);
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
