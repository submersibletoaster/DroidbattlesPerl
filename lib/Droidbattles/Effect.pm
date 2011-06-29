package Droidbattles::Effect;
use strict;
use warnings;

use Class::XSAccessor
    predicates => {
        has_position => 'position',
        has_size => 'size',
        has_velocity => 'velocity',
        has_direction=> 'direction',
        has_owner    => 'owner',
    },
    false => [qw(is_actor  )],
    true  => [qw(is_effect is_collidable )],
    accessors => [qw(
        position
        direction
        velocity
        range
        owner
        size
        id
    )];
 
sub defaults {
    direction => 0 ,
    velocity => 10,
    range => 10,
    size => 10

}

sub collision_box {
    my $self = shift;
    my $pos = $self->position;
    my $size = $self->size;
    $size||=1;
    die "No position! $self" unless defined $pos->[0];
    die "No position! $self" unless defined $pos->[1];
    
    return (
        $pos->[0] - $size,
        $pos->[1] - $size,
        $pos->[0] + $size,
        $pos->[1] + $size
    )
}

sub new {
    my ($class,@args) = @_;
    my %self = ( $class->defaults() , @args );
    return bless \%self, ref($class)||$class;
    
}

sub hook_collision {}

1;
