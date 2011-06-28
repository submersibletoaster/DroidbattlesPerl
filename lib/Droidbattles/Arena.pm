package Droidbattles::Arena;
use strict;
use warnings;
use Class::XSAccessor
    constructor => 'new',
    accessors => [qw(
        gameover
        size_x
        size_y
        ticks
        elements
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

sub add_element {
    my ($self,$e) = @_;
    
    
    # Hook for this?
    
    my $class = ref $e;
    push @{ $self->{elements}{$class} }, $e;
    
    if ($class->is_actor and !exists $self->{actors}{$class} ) {
        $self->{actors}{$class} = $self->{elements}{$class};
    }
    
    $e;
    
}

sub destroy_element {
    my ($self,$e,$reason) = @_;
    
    # hook destroy too?
    #warn "Destroy element $e, $reason";
    my $class =ref $e;
    @{ $self->{elements}{$class} } =
        grep { $_ ne $e } @{ $self->{elements}{$class} };
        
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


=head2 simulate

step the simulation one tick.

=cut

sub simulate {
    my $self=shift;
    $self->ticks(1) unless $self->ticks;
    $self->ticks(1) if $self->ticks > 65535;

    # No simulation?
    # Loop over elements 

    foreach my $element( map { @$_  } values %{$self->{elements}} ) {
        #warn "sim\t$element\n";
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

sub damage {
    my ($self,$e,$d) = @_;
    if ($e->armor) { 
        $e->armor( $e->armor - $d );
        $self->destroy_element( $e ) if $e->armor <= 0;
    }
    
}


1;
