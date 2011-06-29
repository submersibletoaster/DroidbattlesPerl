package Droidbattles::Effect::Plasmaround;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );
use Droidbattles::Effect::PlasmaDebris;
use Class::XSAccessor
    replace => 1,
    accessors => [qw( strength origin )];

use Droidbattles::Arena::Functions qw( is_inside_circle circles_overlap );

    
sub new {
    my $class = shift;
    
    my $self = $class->SUPER::new(@_);
    $self->position( [ @{$self->origin} ] );
    $self->owner( '(null)' ) unless $self->owner;
    
    return $self;
}

sub defaults {
    $_[0]->SUPER::defaults,
    velocity => 700,
    size => 800,
}

sub apply {
    my ($self,$e,$arena) = @_;
    
    
}

sub step {};

sub hook_collision {
    my ($self,$arena,$e) = @_;
    return if $self->owner eq $e;
    if ( circles_overlap( $self->position, $self->size , $e->position, $e->size ) ) {
        warn "Plasma HIT $e";
        $arena->destroy_element($self);
        $arena->damage( $e => 15 );
    }
}

sub hook_destroy {
    my ($self,$arena) = @_;
    $arena->add_element(
                new Droidbattles::Effect::PlasmaDebris
                    position => [ @{ $self->position } ],
                    direction => rand(360),
                    velocity => $self->velocity ,
                    size => $self->size,
            
            ) for  1..3;
    
}

1;
