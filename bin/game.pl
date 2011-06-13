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
use SDLx::Controller;

use t::lib::Game1;


my $arena = new t::lib::Game1;

my $app = init();
my $game = SDLx::Controller->new( dt=>1/50 , min_t => 1/50, delay=> 0);
$game->add_show_handler( sub { draw($arena,shift) } );
$game->add_move_handler( sub { $arena->simulate } );
$game->add_event_handler( \&on_event );
$game->run;

sub on_event {
    my $event = shift;
    
    if ( $event->type == SDL_QUIT ) {
        $_[0]->stop;
    }    
}
sub init {

        # Initing video
        # Die here if we cannot make video init
        Carp::confess 'Cannot init  ' . SDL::get_error()
                if ( SDL::init(SDL_INIT_VIDEO) == -1 );

        # Create our display window
        # This is our actual SDL application window
        my $a = SDL::Video::set_video_mode(
                800, 800, 32,
                SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_HWACCEL
        );

        Carp::confess 'Cannot init video mode 800x600x32: ' . SDL::get_error()
                unless $a;

        return $a;
}

sub draw {
    my $arena = shift;
    
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
    SDL::Video::fill_rect(
        $app,
        SDL::Rect->new( 0, 0, $app->w, $app->h ),
        SDL::Video::map_RGB( $app->format, 0, 0, 0 )
    );

    # Need a co-ord transform from Arena to Pixels
    foreach my $e ( $arena->get_elements ) {
        
        if ($e->isa('Droidbattles::Droid') ) {
            #warn join ' , ' , @{ $e->position };
            #warn join ' , ' , $rescale->( $e->position );
            
            SDL::Video::fill_rect(
                $app,
                SDL::Rect->new( $rescale->( $e->position , 50, 50 ) ),
                SDL::Video::map_RGB( $app->format, 0, 0, 255 )
            );
        }
        
        if ($e->isa('Droidbattles::Effect::Plasmaround')) {
            my ($x,$y,$sx,$sy) = $rescale->($e->position,5,5);
            #$app->draw_circle_filled( $x,$y,$sx , [255,255,0,200] );
            SDL::Video::fill_rect(
                    $app,
                    SDL::Rect->new(
                            $rescale->( $e->position , 5,5 )
                    ),
                    SDL::Video::map_RGB( $app->format, 255, 0, 0 )
            );
        }
    }
    SDL::Video::flip($app);

    return 0;
    
}
