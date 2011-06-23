package Droidbattles::Arena::Functions;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw( 
    find_distance
    is_inside_box 
    is_inside_circle 
    circles_overlap 
    translate_xy_dir_dist
);
use Math::Trig;

use constant X=>0;
use constant Y=>1;

sub is_inside_box {
    my ($point,$Xsize,$Ysize) = @_;

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
    my ($point,$origin) = @_;
    my $dist = find_distance($point,$origin);
    
    
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
    
    my $distance = sqrt(
                    ($point->[X] - $origin->[X] ) ** 2 
                  + ($point->[Y] - $origin->[Y] ) ** 2
                );
                
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
