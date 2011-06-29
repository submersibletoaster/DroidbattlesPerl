package Droidbattles::Effect::OutOfBounds;
use strict;
use warnings;
use parent qw( Droidbattles::Effect );
use Droidbattles::Arena::Functions
    'is_inside_box';

use Class::XSAccessor
    accessors => [qw(
        x_lower
        x_upper
        y_lower
        y_upper
    )], 
    false => ['is_collidable'],
    predicates => {
        has_position => 'position'
        
    };
    

sub step {
    my $self = shift;
    my $arena = shift;
    
    foreach my $e ( $arena->get_elements ) {
        next if $self eq $e;
        next unless $e->has_position;
        # Push droids back in bounds
        if ( $e->isa( 'Droidbattles::Droid' ) ) {
            
            my $pos = $e->position;
            
            # limit X
            if ($pos->[0] <= - $self->range->[0] ) {
                $pos->[0] = - $self->range->[0] ;
            }
            if ($pos->[0] >= $self->range->[0]) {
                $pos->[0] = $self->range->[0];
            }

            # limit Y
            if ($pos->[1] <= - $self->range->[1] ) {
                $pos->[1] = - $self->range->[1];
            }
            if ($pos->[1] >= $self->range->[1] ) {
                $pos->[1] = $self->range->[1];
            }
            
        } 
        elsif ( ! is_inside_box( $e->position , @{ $self->range } ) ) {
            $arena->destroy_element( $e , 'Out of bounds' );
        }
    }
    
}



1;
