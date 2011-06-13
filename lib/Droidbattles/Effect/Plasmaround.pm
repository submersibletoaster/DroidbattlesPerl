package Droidbattles::Effect::Plasmaround;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );

use Class::XSAccessor
    replace => 1,
    accessors => [qw( strength origin )];

use Droidbattles::Arena::Functions qw( is_inside_circle );

    
sub new {
    my $class = shift;
    
    my $self = $class->SUPER::new(@_);
    $self->velocity( 800 );
    # Set effect position to be COPY of origin
    $self->position( [ @{$self->origin} ] );
    $self->owner( '(null)' ) unless $self->owner;
    
    
    return $self;
}

sub apply {
    my ($self,$e,$arena) = @_;
    
    
}

sub step {
    my ($self,$arena) = @_;
    
    foreach my $e ( $arena->get_actors ) {
        next if ($self->owner eq $e );
        
        if ( is_inside_circle( $self->position, $e->position, 3096) ) {
            warn "Plasma HIT $e";
            $arena->destroy_element( $self );
            $arena->damage( $e => 15 );
        }
        
    }
}

1;
