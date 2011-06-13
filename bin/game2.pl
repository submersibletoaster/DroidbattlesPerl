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
     w => 500, h => 500,
    d => 32,
    title => 'Pretty Flowers',
    dt=>1/50 , min_t => 1/50, delay=> 0
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
        $c->[0] -= $sx/2;
        $c->[1] -= $sy/2;
        
        @$c, $sx , $sy;
    };
    
    # Blank
    $app->draw_rect( [0, 0, $app->w, $app->h ],
                 [0, 0, 0 ,0] 
    );

    # Need a co-ord transform from Arena to Pixels
    foreach my $e ( $arena->get_elements ) {
        
        if ($e->isa('Droidbattles::Droid') ) {

                $app->draw_rect( 
                        [$rescale->( $e->position, 50, 50 )],
                        [0,0,255,255]
                );
        }
        
        if ($e->isa('Droidbattles::Effect::Plasmaround')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,5,5);
            $app->draw_circle_filled( [$x,$y, ] , $sx , [0,200,0,200] );
        }
    }
    SDL::Video::flip($app);

    return 0;
    
}
