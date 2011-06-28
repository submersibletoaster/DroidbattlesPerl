package Droidbattles::Effect::Newton2D;
use strict;
use warnings;
use Math::Trig;
use parent qw( Droidbattles::Effect );
use Droidbattles::Arena::Functions
    'translate_xy_dir_dist';

use Class::XSAccessor
    accessors => [qw(
        
    )];
    

sub step {
    my $self = shift;
    my $arena = shift;
    
    foreach my $e ( $arena->get_elements  ) {
        next unless $e->has_position;
        next unless $e->has_velocity;
        next unless $e->has_direction;
        
        # adjust velocity by acceleration ?
        my $dir = $e->direction;
        
        # # adjust position by direction/velocity
        # my ($x,$y) = 
            # (
                # sin(deg2rad $dir) * $e->velocity, 
                # cos(deg2rad $dir) * $e->velocity,
            # );
        my $pos = translate_xy_dir_dist @{ $e->position } ,  $e->direction, $e->velocity ;
        
        $e->position($pos);
        
    }
}

1;
