package t::lib::Game1;

use strict;
use warnings;
use Droidbattles::Arena;
use Droidbattles::Arena::Functions;
use Droidbattles::Effect::OutOfBounds;
use Droidbattles::Effect::Newton2D;
use Droidbattles::Effect::Plasmaround;
use Droidbattles::Effect::Rocket;
use Droidbattles::Droid;

sub new {
    my $class = shift;
    my $arena = new Droidbattles::Arena @_;
    my $bounds = new Droidbattles::Effect::OutOfBounds 
                                range => [ 2 ** 16 , 2 ** 16 ];
                                
    my $physics = new Droidbattles::Effect::Newton2D;
    my $testdroid = new Droidbattles::Droid
                                    position => [ 0,40000 ],
                                    direction=> rand(360),
                                    velocity => 0,
                                    size => 3000;
                        
    my $otherdroid = new Droidbattles::Droid
                                    position => [-40000,-20000],
                                    direction => rand(360),
                                    velocity => 90,
                                    size => 3000;
                                    
    my $otherdroid2 = new Droidbattles::Droid
                                    position => [40000,20000],
                                    direction => rand(360),
                                    velocity => 90,
                                    size => 3000;
                                    
                                    
    my $plasmaround = new Droidbattles::Effect::Plasmaround
                                        origin => [-61000,0],
                                        direction => 90;
                                        
    $testdroid->add_routine(\&triggerhappy);
        $testdroid->add_routine(sub{ rockets(@_,100) } );
    $otherdroid->add_routine(sub{ triggerhappy(@_,15) } );
    $otherdroid->add_routine(sub{ steer(shift,0.21) } );
    $otherdroid->add_routine(sub{ rockets(@_,150) } );
        
    
     $otherdroid2->add_routine(sub{ triggerhappy(@_,25) } );
    $otherdroid2->add_routine(sub{ steer(shift,-0.18) } );
    $otherdroid2->add_routine(sub{ rockets(@_,100) } );
    
    
    ## Fill the arena
    $arena->add_element( 
     $_
    ) for (
        $physics,
        $bounds,
        $testdroid,
        $otherdroid,
        $otherdroid2,
        $plasmaround
    );
    return $arena;
}


sub triggerhappy { 
            my $self = shift ; my $arena = shift; my $beat= shift;
            $beat ||= 50;
            $arena->add_element(
            new Droidbattles::Effect::Plasmaround
                origin => [ @{ $self->position } ],
                direction => $self->direction,
                owner => $self
        ) if $arena->ticks % $beat == 0;
}

sub steer { 
        my $self = shift;
        $self->direction( $self->direction + shift );
}

sub rockets {
    my ($self,$arena,$beat) = @_;
    $arena->add_element(
        new Droidbattles::Effect::Rocket
            origin => [ @{ $self->position } ],
            direction => $self->direction,
            distance => 60000,
            strength => 400,
    ) if $arena->ticks % $beat == 0;
    
}

1;
