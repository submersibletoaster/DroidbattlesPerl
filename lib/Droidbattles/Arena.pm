package Droidbattles::Arena;
use strict;
use warnings;
use Algorithm::QuadTree;
use Class::XSAccessor
    accessors => [qw(
        gameover
        size_x
        size_y
        ticks
        elements
        objects
        qt
    )];


use Data::Dumper;

=head1 NAME

Droidbattles::Arena - The droidbattles gamespace 

=head1 ACCESSORS

=head2 size_x

=head2 size_y

=head2 ticks

Number of ticks the gamespace has been running

=cut

=head1 METHODS

=head2 add_element

Add any type of Droidbattles::Actor to the arena.

=cut

sub new {
    my $class = shift;
    my $self = bless { @_ } , $class;
    $self->objects( [] ) unless $self->objects;
    
    $self->_fresh_quadtree;
    return $self;
    
}

sub add_element {
    my ($self,$e) = @_;
    
    
    
    my $class = ref $e;
    push @{ $self->{elements}{$class} }, $e;
    
    if ($class->is_actor and !exists $self->{actors}{$class} ) {
        $self->{actors}{$class} = $self->{elements}{$class};
    }
    

    my $next_id = $#{ $self->objects } + 1;
    $e->id($next_id);

    push @{ $self->objects } , $e;
    
    $self->qt->add( $e->id , $e->collision_box ) if ($e->is_collidable);
    
    
    
    $e;
    
}

sub destroy_element {
    my ($self,$e,$reason) = @_;
    
    # hook destroy too?
    #warn "Destroy element $e, $reason";
    my $class =ref $e;
    @{ $self->{elements}{$class} } =
        grep { $_ ne $e } @{ $self->{elements}{$class} };
    
    undef ${ $self->objects }[$e->id];
        
    if ($e->can('hook_destroy')) {
        eval {
            $e->hook_destroy( $self , $reason );
            
        };
        
    }
    
}

sub get_actors {
    my $self = shift;
    
    if ( exists $self->{c_actors} && 
        $self->{c_actors}[0] == $self->ticks
        )
         {
        my $cached = $self->{c_actors}[1];
        return @$cached;
    }
    
    my @el = 
        map { @$_  } values %{$self->{actors}};
    
    $self->{c_actors}[0] = $self->ticks;
    $self->{c_actors}[1] = \@el;
    
    
    return @el;
    
}

sub get_elements {
    my $self = shift;
    my @el = map { @$_  } values %{$self->{elements}};
    return @el;
    
}

sub get_object_by_id {
    my ($self,$id) = @_;
    my $objects = $self->objects;
    if ($id > $#{$objects} ) { return }
    return $objects->[$id];
}


=head2 simulate

step the simulation one tick.

=cut

sub simulate {
    my $self=shift;
    $self->ticks(1) unless $self->ticks;
    $self->ticks(1) if $self->ticks > 65535;

    # No simulation?
    # Loop over elements 
    my $qt = $self->_fresh_quadtree;
    
    $qt->add( $_->id , $_->collision_box ) for 
                        grep { $_->is_collidable  }
                        $self->get_elements;
    
    foreach my $element( map { @$_  } values %{$self->{elements}} ) {

        $element->step($self);
        
    }
    
    $self->ticks( $self->ticks + 1 );
    my (@droids) = 
                grep  { $_->isa('Droidbattles::Droid') } 
                map { @$_  } values %{$self->{elements}};
                
    
    if (scalar @droids == 1) {
        $self->gameover( $self->gameover + 1);
        die "The winner is $droids[0]" if $self->gameover > 500;
    
    }
    
    
    
    return;

}

sub _fresh_quadtree {
    my $self = shift;
    
   my $qt = Algorithm::QuadTree->new(
            -xmin => - $self->size_x,
            -xmax => $self->size_x,
            -ymin => -$self->size_y, 
            -ymax => $self->size_y ,
            -depth => 4,
            
    );
    $self->qt( $qt );
    
}

sub damage {
    my ($self,$e,$d) = @_;
    if ($e->armor) { 
        $e->armor( $e->armor - $d );
        $self->destroy_element( $e ) if $e->armor <= 0;
    }
    
}


1;
