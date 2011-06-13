package Droidbattles::Arena;
use strict;
use warnings;
use Class::XSAccessor
    constructor => 'new',
    accessors => [qw(
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
    
    
    
    
}

sub destroy_element {
    my ($self,$e,$reason) = @_;
    
    # hook destroy too?
    #warn "Destroy element $e, $reason";
    my $class =ref $e;
    @{ $self->{elements}{$class} } =
        grep { $_ ne $e } @{ $self->{elements}{$class} };
    
}

sub get_actors {
    my $self = shift;
    my @el = grep { $_->isa('Droidbattles::Actor') }
        map { @$_  } values %{$self->{elements}};
    
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
    
    # Loop over elements 

    foreach my $element( map { @$_  } values %{$self->{elements}} ) {
        #warn "sim\t$element\n";
        $element->step($self);
        
    }
    
    $self->ticks( $self->ticks + 1 );
    
    return;

}




1;