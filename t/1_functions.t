use strict;
use warnings;
use Test::More tests => 9;


use Droidbattles::Arena::Functions qw(
    find_distance
    find_direction
    bot2rad
    rad2bot
 );
 
 
ok( find_distance( [0,0],[3,4] ) == 5 , 'Find distance' );

cmp_ok( find_direction( [0,0], [1,1] ) ,'==',  896 , 'Find direction first quadrant' );

cmp_ok( find_direction( [0,0], [1,-1] ) ,'==',  128 , 'Find direction second quadrant' );

cmp_ok( find_direction( [0,0], [-1,-1] ) ,'==',  384 , 'Find direction third quadrant' );


cmp_ok( find_direction( [0,0], [-1,1] ) ,'==',  640 , 'Find direction fourth quadrant' );


cmp_ok( find_direction( [0,0] , [0,1] ) , '==', 768  , 'Find direction north' );

cmp_ok( find_direction( [0,0] , [0,-1] ) , '==', 256  , 'Find direction south' );

cmp_ok( find_direction( [0,0] , [1,0] ) , '==', 0  , 'Find direction east' );

cmp_ok( find_direction( [0,0] , [-1,0] ) , '==', 512  , 'Find direction west' );