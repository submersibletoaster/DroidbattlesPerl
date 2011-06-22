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
    
    
    my @drones;
    push @drones, new Droidbattles::Droid
                    position => [-60000 + rand(120000), -60000 + rand(120000)],
                    direction => rand(360),
                    velocity => rand(50) + 50 ,
                    armor => 40,
                    size => 1500
                        for 1..10;
                        
                        
    my @rocketeers;
    push @rocketeers , new Droidbattles::Droid
                    position => [-60000 + rand(120000), -60000 + rand(120000)],
                    direction => rand(360),
                    velocity => rand(50) + 50 ,
                    armor => 100,
                    size => 3000
                        for 1..10;
                  
    $_->add_routine( sub{ rockets(@_,100+rand(10)) } ) for @rocketeers;
    $_->add_routine( sub{ steer(shift,0.2+rand(0.05) ) } ) for @rocketeers;
    $_->add_routine(sub{ triggerhappy(@_,15+rand(5) ) } ) for @rocketeers; 
      
      
   
    
    
    ## Fill the arena
    $arena->add_element( 
     $_
    ) for (
        $physics,
        $bounds,

        @rocketeers,
        @drones
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
