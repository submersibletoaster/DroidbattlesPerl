package Droidbattles::Arena::Functions;
use strict;
use warnings;
use Carp 'croak','confess';
use parent 'Exporter';
our @EXPORT_OK = qw( 
    find_distance
    find_direction
    is_inside_box 
    is_inside_circle 
    circles_overlap 
    translate_xy_dir_dist
);
use Math::Trig;

use constant X=>0;
use constant Y=>1;
use constant BOTRAD_MOD => 1024 ;

my @BOTRAD=( map { $_ / 1024 * pi * 2 } 0..BOTRAD_MOD );

sub bot2rad ($) { 
    $BOTRAD[int($_[0])] || croak "$_[0] is out of range"; 
}


sub is_inside_box {
    my ($point,$Xsize,$Ysize) = @_;
    confess "No position" unless defined $point->[X];
    
    abs $point->[X] < $Xsize
    and
    abs $point->[Y] < $Ysize ;
}

sub find_distance {
    my ($point,$origin) = @_;
    my $distance = sqrt(
                ($point->[0] - $origin->[0] ) ** 2 
              + ($point->[1] - $origin->[1] ) ** 2
            );
    return $distance;
}

sub find_direction {
    my ($origin,$point) = @_;
    my $dist = find_distance($point,$origin);
    my $dx = $point->[X] - $origin->[X];
    my $dy = $point->[Y] - $origin->[Y];

    my $rad;
    my $offset;
    if ( $dx == 0 and $dy == 0 ) {
        # co-incident default to north
        return 0;
    } elsif ( $dx == 0 and $dy < 0 ) {
        return 180;
    } elsif ( $dx == 0 and $dy > 0 ) {
        return 0;
    }
    elsif ( $dy == 0 and $dx < 0 ) {
        return 270;
    } elsif ( $dy == 0 and $dx > 0 ) {
        return 90;
    }
  
    if ($dx > 0) {
        if ( $dy > 0 ) {
            $rad = atan($dx/$dy);
            $offset = 0;
        } else {
            $rad =  atan(-$dy/$dx);
            $offset = 90;
        }
            
    } else {
        if ( $dy < 0 ) {
                $rad = atan(-$dx/-$dy);
                $offset = 180;
        } else {
                $rad = atan($dy/-$dx);
                $offset = 270;
        }
            
    }
    
    my $dir = rad2deg($rad);
    return $dir + $offset;
    
}

sub circles_overlap {
    my ($pri,$pri_rad,$sec,$sec_rad) = @_;
    my $bail = $pri_rad + $sec_rad;
    
    my $dist = sqrt(
      ($pri->[Y] - $sec->[Y] ) ** 2 + ( $pri->[X] - $sec->[X] ) ** 2 
    );
    
    $dist <= $bail;
    
}

sub is_inside_circle {
    my ($point,$origin,$radius) = @_;
    # unless ( 
        # is_inside_box( $point , 
            # $origin->[X] - $point->[X], 
            # $origin->[Y] - $point->[Y],
            # )
        # ) {
            # return 0;
        # }
    $radius = $radius ** 2;
    my $distance = ($point->[X] - $origin->[X] ) ** 2 
                  + ($point->[Y] - $origin->[Y] ) ** 2
                ;
                
    if ( $distance <= $radius ) {
        return 1;
    } else { return 0 }
    
}

sub translate_xy_dir_dist {
        my ($x,$y,$dir,$dist) = @_;
        my ($dx,$dy) = 
            (
                sin(deg2rad $dir) * $dist, 
                cos(deg2rad $dir) * $dist,
            );
            #warn sprintf "Adjust %.2f => %.2f ", $x, $y;
        $x+= $dx;
        $y+= $dy;
        return [$x,$y];
}



1;
