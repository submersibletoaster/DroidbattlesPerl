package Droidbattles::Arena::Functions;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw( 
    find_distance
    is_inside_box 
    is_inside_circle 
    circles_overlap 
);

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
                    ($point->[0] - $origin->[0] ) ** 2 
                  + ($point->[1] - $origin->[1] ) ** 2
                );
                
    if ( $distance <= $radius ) {
        return 1;
    } else { return 0 }
    
}





1;
