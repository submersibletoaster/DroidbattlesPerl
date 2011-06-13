package Droidbattles::Arena::Functions;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw( is_inside_box is_inside_circle );

use constant X=>0;
use constant Y=>1;

sub is_inside_box {
    my ($point,$Xsize,$Ysize) = @_;

    abs $point->[X] < $Xsize
    and
    abs $point->[Y] < $Ysize ;
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
