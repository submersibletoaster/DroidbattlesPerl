package Droidbattles::Effect::Beam;
use strict;
use warnings;

use parent 'Droidbattles::Effect';
use Droidbattles::Arena::Functions 
    'is_inside_circle', 
    'translate_xy_dir_dist',
    'find_direction';

use Class::XSAccessor
  replace => 1,
  true => [ 'is_collidable' ],
  accessors => [qw(age maxage origin)];

sub new {
  my $self = shift->SUPER::new(@_);
  $self->{position} = translate_xy_dir_dist( 
    @{ $self->origin  } , $self->direction , $self->range 
  ); 
  return $self;
}

sub defaults {
  shift->SUPER::defaults,
  maxage => 3,
  age => 0,
  size => 10,
}

sub step {
  my ($self,$arena) = @_;
  
  my $point = translate_xy_dir_dist( @{ $self->origin } , $self->direction , $self->range );
  @{ $self->position } = @$point;
    
  $self->age( $self->age+1 );
  $arena->destroy_element( $self ) if $self->age >= $self->maxage;
  
  
}

sub hook_collision {
    my ($self,$arena,$e) = @_;
      return if $e eq $self->owner;
      if ( is_inside_circle( $self->position , $e->position , $e->size ) ) {
         # warn "Beam hit $e";
        $arena->damage( $e => 10 );
      }

  
}

1;