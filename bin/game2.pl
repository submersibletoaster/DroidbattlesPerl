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
use constant ANTIALIAS => 1;

use t::lib::Game1;


my $arena = new t::lib::Game1;

my $game = SDLx::App->new(
     w => 800, h => 800,
    d => 32,
    title => 'Droidbattles',
    dt=>1/50 , min_t => 3/50, delay=> 0.02
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
    
    my $factor =  $app->w / ( $arena->size_x * 2 );
    my $offset  = $arena->size_x;
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
        
        if ( $e->is_actor ) {
            if ($e->isa('Droidbattles::Droid') ) {
                    my ($x,$y,$sx) = $rescale->($e->position,$e->size,$e->size);
                    my $alpha = $e->armor / 100;
                    $alpha = 1 if $alpha > 1;
                    $app->draw_circle_filled( 
                            [$x,$y],$sx,
                            [0,0,255, 127+ $alpha * 128],
                            ANTIALIAS
                    );
            }
        } elsif ( $e->is_effect ) {
            my $type = ref $e;
            if ($type eq 'Droidbattles::Effect::Plasmaround') {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                $app->draw_circle_filled( 
                        [$x,$y, ] , $sx , [0,200,0,200] , ANTIALIAS
                );
            }
            elsif ($type eq 'Droidbattles::Effect::Rocket') {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                $app->draw_circle_filled( 
                        [$x,$y, ] , $sx , [255,255,255,200] , ANTIALIAS
                );
            } 
            elsif ($type eq 'Droidbattles::Effect::Missile' ) {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                    $app->draw_circle_filled( [$x,$y, ] , $sx , 
                    [255,255,0,  255 ] , ANTIALIAS
                );
            }
            elsif ( $type eq 'Droidbattles::Effect::RocketDebris') {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                my $factor = abs( $e->maxage - $e->age ) ;
                next unless $factor;
                $factor /= $e->maxage;
                $app->draw_circle_filled( [$x,$y, ] , $sx , 
                    [55,55,55,  255 * $factor ] , ANTIALIAS
                );
            }
            elsif ($type eq 'Droidbattles::Effect::PlasmaDebris') {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                my $factor = abs( $e->maxage - $e->age ) ;
                next unless $factor;
                $factor /= $e->maxage;
                $app->draw_circle_filled( [$x,$y, ] , $sx , 
                    [55,255,255,  128 * $factor ] , ANTIALIAS
                );
            }
            elsif ($type eq 'Droidbattles::Effect::Debris') {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                my $factor = abs( $e->maxage - $e->age ) ;
                next unless $factor;
                $factor /= $e->maxage;
                $app->draw_circle_filled( [$x,$y, ] , $sx , 
                    [200,90,10,  128 * $factor ] 
                    , ANTIALIAS
                );
            }
            elsif ( $type eq 'Droidbattles::Effect::RocketTrail' ) {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,$e->size,$e->size);
                my $factor = abs( $e->maxage - $e->age ) ;
                next unless $factor;
                $factor /= $e->maxage;
                $app->draw_circle_filled(
                    [$x,$y],$sx ,
                    [255,0,0,127 + (128*$factor)],
                    ANTIALIAS
                )
                
            } elsif ( $type eq 'Droidbattles::Effect::Beam' ) {
                my ($x,$y,$sx,$sy) = $rescale->($e->position,1,1);
                my ($x2,$y2) = $rescale->($e->origin,1,1);
                my $bright = int(rand(255));
                my $factor = $e->age || 1;
                $factor  /= $e->maxage;
                $factor *= $factor;
                $app->draw_line(
                    [$x,$y] , [$x2,$y2] , [  $bright,$bright,255, 250 -200*$factor ] , ANTIALIAS
                );
                
            }
        }

    }
    $app->update;
    #SDL::Video::flip($app);

    return 0;
    
}
