# ABSTRACT: State Machine State Class
package State::Machine::State;

use Bubblegum::Class;
use Function::Parameters;
use State::Machine::Failure::Transition::Unknown;
use State::Machine::Transition;
use Try::Tiny;

use Bubblegum::Constraints -typesof;

# VERSION

has 'name' => (
    is       => 'ro',
    isa      => typeof_string,
    required => 1
);

has 'next' => (
    is       => 'rw',
    isa      => typeof_string,
    required => 0
);

has 'transitions' => (
    is      => 'ro',
    isa     => typeof_hashref,
    default => sub {{}}
);

method add_transition {
    my $trans = pop;
    my $name  = shift;

    if ($trans->isa('State::Machine::Transition')) {
        $name //= $trans->name;
        $self->transitions->set($name => $trans);
        return $trans;
    }

    # transition not found
    State::Machine::Failure::Transition::Unknown->throw(
        transition_name => $name,
    );
}

method remove_transition {
    my $name = shift;

    if ($self->transitions->get($name->asa_string)) {
        return $self->transitions->delete($name);
    }

    # transition not found
    State::Machine::Failure::Transition::Unknown->throw(
        transition_name => $name,
    );
}

1;

=encoding utf8

=head1 SYNOPSIS

    use State::Machine::State;

    my $state = State::Machine::State->new(
        name => 'sleep',
        next => 'resume'
    );

=head1 DESCRIPTION

State::Machine::State represents a state and it's transitions.

=has name

    my $name = $state->name;
    $name = $state->name('inspired');

The name of the state. The value can be any scalar value.

=has next

    my $transition_name = $state->next;
    $transition_name = $state->next('create_art');

The name of the next transition. The value can be any scalar value. This value
is used in automating the transition from one state to the next.

=has transitions

    my $transitions = $state->transitions;

The transitions attribute contains the collection of transitions the state can
apply. The C<add_transition> and C<remove_transition> methods should be used to
configure state transitions.

=method add_transition

    $trans = $state->add_transition(State::Machine::Transition->new(...));
    $state->add_transition(name => State::Machine::Transition->new(...));

The add_transition method registers a new transition in the transitions
collection. The method requires a L<State::Machine::Transition> object.

=method remove_transition

    $trans = $state->remove_transition('transition_name');

The remove_transition method removes a pre-defined transition from the
transitions collection. The method requires a transition name.

=cut
