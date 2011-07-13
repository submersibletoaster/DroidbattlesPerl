package Droidbattles::Droid;
use strict;
use warnings;
use Math::Trig;
use Carp 'croak';
use parent qw( Droidbattles::Actor );
use Droidbattles::Effect::Debris;
use Droidbattles::Effect::Damage;

# 
 use Class::XSAccessor
    accessors => [qw(
        routines
        
     )];

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->armor( 10 ) unless $self->armor;
    
    return $self;
    
}

sub add_routine {
    my ($self,$r) = @_;
    $self->routines([]) unless $self->routines;
    push @{ $self->routines } , $r or croak 'routine undefined'; 
}

sub step {
    my ($self,$arena) = @_;
    
    # foreach my $cpu ( $self->hardware->cpus ) {
        # $cpu->step($arena);
    # }

    if ($self->routines ) {
        $_->($self,$arena) for @{ $self->routines } ;
    }
    
    my $collides = $arena->qt->getEnclosedObjects($self->collision_box);
    foreach my $hit ( @$collides ) {
        next if $hit eq $self->id;
        my $e = $arena->get_object_by_id($hit) || next;
        $e->hook_collision( $arena, $self) 
    }
    
}

sub hook_destroy {
    my ($self,$arena) = @_;
    $arena->add_element(
                new Droidbattles::Effect::Debris
                    position => [ map { $_ + 100-rand(200) } @{ $self->position } ],
                    direction => $self->direction + ( 256 - rand(512)),
                    velocity => $self->velocity || rand(100) ,
                    size => $self->size * rand(1)+0.5 ,
            
            ) for  1..int($self->size/100);
}

sub hook_damage {
    my ($self,$arena,$damage) = @_;
    $arena->add_element(
        new Droidbattles::Effect::Damage
            position => [ @{ $self->position } ],
            size => 1,
            range=> $damage * 2
    );
    
}

sub hook_collision {
    my ($self,$arena,$e) = @_;
    
}

1;
