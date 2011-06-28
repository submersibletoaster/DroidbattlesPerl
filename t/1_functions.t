use strict;
use warnings;
use Test::More tests => 9;


use Droidbattles::Arena::Functions qw(
    find_distance
    find_direction
 );
 
 
ok( find_distance( [0,0],[3,4] ) == 5 , 'Find distance' );

cmp_ok( find_direction( [0,0], [1,1] ) ,'==',  45 , 'Find direction first quadrant' );

cmp_ok( find_direction( [0,0], [1,-1] ) ,'==',  135 , 'Find direction second quadrant' );

cmp_ok( find_direction( [0,0], [-1,-1] ) ,'==',  225 , 'Find direction third quadrant' );


cmp_ok( find_direction( [0,0], [-1,1] ) ,'==',  315 , 'Find direction fourth quadrant' );


cmp_ok( find_direction( [0,0] , [0,1] ) , '==', 0  , 'Find direction north' );

cmp_ok( find_direction( [0,0] , [0,-1] ) , '==', 180  , 'Find direction south' );

cmp_ok( find_direction( [0,0] , [1,0] ) , '==', 90  , 'Find direction east' );

cmp_ok( find_direction( [0,0] , [-1,0] ) , '==', 270  , 'Find direction west' );