package Droidbattles::Effect::Beam;
use strict;
use warnings;

use parent 'Droidbattles::Effect';
use Droidbattles::Arena::Functions 
    'is_inside_circle', 
    'translate_xy_dir_dist',
    'find_direction';

use Class::XSAccessor
  accessors => [qw(age maxage target)];

sub new {
  my $self = shift->SUPER::new(@_);
  $self->{target} ||= translate_xy_dir_dist( @{ $self->position } , $self->direction , $self->range ); 
  
  return $self;
}

sub defaults {
  shift->SUPER::defaults,
  maxage => 15,
  age => 0,
}

sub step {
  my ($self,$arena) = @_;
  
  my $point = translate_xy_dir_dist( @{ $self->position } , $self->direction , $self->range );
  @{ $self->target } = @$point;
  foreach my $e ( $arena->get_actors ) {
      next if $e eq $self->owner;
      if ( is_inside_circle( $self->position , $e->position , $e->size ) ) {
        $arena->damage( $e => 15 );
      }
  }
  
  $self->age( $self->age+1 );
  $arena->destroy_element( $self ) if $self->age >= $self->maxage;
  
  
}

1;