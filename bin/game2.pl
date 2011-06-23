#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use SDL;
use SDL::Video;
use SDL::Surface;
use SDLx::Surface;
use SDL::Rect;
use SDL::Event;
use SDL::Events;
use Data::Dumper;
use Math::Trig;

use lib 'lib', 't/lib';
use SDLx::App;
use SDLx::Controller;

use t::lib::Game1;


my $arena = new t::lib::Game1;

my $game = SDLx::App->new(
     w => 800, h => 800,
    d => 32,
    title => 'Droidbattles',
    dt=>1/50 , min_t => 3/50, delay=> 0
);


$game->add_show_handler( \&draw );
$game->add_move_handler( sub { $arena->simulate } );
$game->add_event_handler( \&on_event );
$game->run;

sub on_event {
    my $event = shift;
    
    if ( $event->type == SDL_QUIT ) {
        $_[0]->stop;
    }    
}


sub draw {
    my ($time,$app) = @_;
    
    my $factor =  $app->w / ( 2 ** 16 * 2 );
    my $offset  = 2 ** 16 ;
    my $rescale = sub { 
        my $p = shift;
        my $c = [@$p];
        $c->[0] += $offset;
        $c->[1] += $offset;
        
        $c->[0] *= $factor;
        $c->[1] *= $factor;
        

        my $sx = shift;
        my $sy = shift;
        $sx *= $factor;
        $sy *= $factor;
        
        #$c->[0] -= $sx/2;
        #$c->[1] -= $sy/2;
        
        @$c, $sx , $sy;
    };
    
    # Blank
    $app->draw_rect( [0, 0, $app->w, $app->h ],
                 [0, 0, 0 ,0] 
    );

    # Need a co-ord transform from Arena to Pixels
    foreach my $e ( $arena->get_elements ) {
        
        if ($e->isa('Droidbattles::Droid') ) {
                my ($x,$y,$sx) = $rescale->($e->position,$e->size,$e->size);
                
                $app->draw_circle_filled( 
                        [$x,$y],$sx,
                        [0,0,255, 127+ $e->armor / 100 * 128]
                );
        }
        
        if ($e->isa('Droidbattles::Effect::Plasmaround')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            $app->draw_circle_filled( [$x,$y, ] , $sx , [0,200,0,200] );
        }
        
        if ($e->isa('Droidbattles::Effect::Rocket')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            $app->draw_circle_filled( [$x,$y, ] , $sx , [255,255,255,200] );
        }
        if ($e->isa('Droidbattles::Effect::Missile')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            $app->draw_circle_filled( [$x,$y, ] , $sx , [255,255,0,200] );
        }
        
              
        if ($e->isa('Droidbattles::Effect::RocketDebris')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            my $factor = abs( $e->maxage - $e->age ) ;
            next unless $factor;
            $factor /= $e->maxage;
            $app->draw_circle_filled( [$x,$y, ] , $sx , 
                [55,55,55,  255 * $factor ] );
        }
        
        if ($e->isa('Droidbattles::Effect::PlasmaDebris')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            my $factor = abs( $e->maxage - $e->age ) ;
            next unless $factor;
            $factor /= $e->maxage;
            $app->draw_circle_filled( [$x,$y, ] , $sx , 
                [55,255,255,  128 * $factor ] );
        }
        
        if ($e->isa('Droidbattles::Effect::Debris')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
            my $factor = abs( $e->maxage - $e->age ) ;
            next unless $factor;
            $factor /= $e->maxage;
            $app->draw_circle_filled( [$x,$y, ] , $sx , 
                [200,90,10,  128 * $factor ] );
        }
        
    }
    $app->update;
    #SDL::Video::flip($app);

    return 0;
    
}
