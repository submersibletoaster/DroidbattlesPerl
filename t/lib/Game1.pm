package t::lib::Game1;

use strict;
use warnings;
use Droidbattles::Arena;
use Droidbattles::Arena::Functions 'find_distance', 'find_direction';

use Droidbattles::Effect::OutOfBounds;
use Droidbattles::Effect::Newton2D;
use Droidbattles::Effect::Plasmaround;
use Droidbattles::Effect::Rocket;
use Droidbattles::Effect::Missile;
use Droidbattles::Effect::Beam;


use Droidbattles::Droid;

sub new {
    my $class = shift;
    my $arena = new Droidbattles::Arena 
                        size_x=> 2** 15,
                        size_y => 2 ** 15,
                        @_;
    my $bounds = new Droidbattles::Effect::OutOfBounds 
                                range => [ $arena->size_x , $arena->size_y ];
                                
    my $physics = new Droidbattles::Effect::Newton2D;
    
    my $sx = $arena->size_x;
    my $sy = $arena->size_y;
    my $rand_position = sub { [ -$sx + rand($sx*2) , -$sy + rand($sy*2) ] };
    
    my @drones;
    push @drones, new Droidbattles::Droid
                    position => $rand_position->() ,
                    direction => rand(360),
                    velocity => rand(50) + 50 ,
                    armor => 40,
                    size => 500
                        for 1..10;
    $_->add_routine(\&wander) for @drones;
                        
                        
    my @rocketeers;
    push @rocketeers , new Droidbattles::Droid
                    position => $rand_position->() ,
                    direction => rand(360),
                    velocity => rand(50) + 50 ,
                    armor => 500,
                    size => 1000
                        for 1..5;
                  
    $_->add_routine( sub{ rockets(@_,100+rand(10)) } ) for @rocketeers;
    $_->add_routine( sub{ steer(shift,0.2+rand(0.05) ) } ) for @rocketeers;
    $_->add_routine(sub{ triggerhappy(@_,15+rand(5) ) } ) for @rocketeers; 
      
    $_->add_routine( sub{ missiles(@_,int(100+rand(50))) } ) for @rocketeers;

    my @beamers;
    push @beamers , new Droidbattles::Droid
                    position => $rand_position->(),
                    direction => rand(360),
                    velocity => rand(50) + 50 ,
                    armor => 500,
                    size => 1000
                        for 1..5;
    $_->add_routine( \&wander  ) for @beamers;
    $_->add_routine( sub { beam(@_,15000) } ) for @beamers;
     $_->add_routine( sub{ missiles(@_,int(200+rand(50))) } ) for @beamers;

      
   
    
    
    ## Fill the arena
    $arena->add_element( 
     $_
    ) for (
        $physics,
        $bounds,

        @rocketeers,
        @beamers,
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
        ) if $arena->ticks % int($beat) == 0;
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
            distance => 30000+rand(10000),
            strength => 400,
    ) if $arena->ticks % int($beat) == 0;
    
}

sub beam {
    my ($self,$arena,$range) = @_;
    foreach my $e ( $arena->get_actors ) {
        next if $e eq $self;
        my $d = find_distance( $e->position , $self->position );
        my $dir = find_direction( $self->position , $e->position  );
        if ($d < $range) {
            $arena->add_element(
                new Droidbattles::Effect::Beam
                    origin => [@{ $self->position } ],
                    range => $d,
                    direction => $dir,
                    owner => $self,
            );
            last;
        }
    }
    
}

sub missiles {
    my ($self,$arena,$beat) = @_;
        $arena->add_element(
        new Droidbattles::Effect::Missile
            origin => [ @{ $self->position } ],
            direction => $self->direction + 90,
            owner => $self
    ) if $arena->ticks % $beat == 0;
    
}

sub wander {
    my ($self,$arena) = @_;
    if ( int(rand(200) + rand(200)) == 200 ) {
        $self->direction(rand(360));
    }
    
}

1;
