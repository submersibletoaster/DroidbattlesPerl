package Droidbattles::Droid;
use strict;
use warnings;
use Math::Trig;
use Carp 'croak';
use parent qw( Droidbattles::Actor );
use Droidbattles::Effect::Debris;


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
}


sub hook_destroy {
    my ($self,$arena) = @_;
    $arena->add_element(
                new Droidbattles::Effect::Debris
                    position => [ @{ $self->position } ],
                    direction => $self->direction * ( 45 - rand(90)),
                    velocity => $self->velocity || rand(100) ,
                    size => $self->size * rand(1)+0.5 ,
            
            ) for  1..int($self->size/250);
    
}

1;
