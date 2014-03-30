# ABSTRACT: State Machine State Transition Class
package State::Machine::Transition;

use Bubblegum::Class;
use State::Machine::Failure;
use State::Machine::State;
use Try::Tiny;

use Bubblegum::Constraints -minimal;

# VERSION

has 'name' => (
    is       => 'ro',
    isa      => _string,
    required => 1
);

has 'result' => (
    is       => 'rw',
    isa      => _object,
    required => 1
);

has 'hooks' => (
    is      => 'ro',
    isa     => _hashref,
    default => sub {{
        before => [],
        during => [],
        after  => []
    }}
);

has 'executable' => (
    is      => 'rw',
    isa     => _integer,
    default => 1
);

has 'terminated' => (
    is      => 'rw',
    isa     => _integer,
    default => 0
);

sub execute {
    my $self = _object shift;
    return if !$self->executable;

    my @schedules = (
        $self->hooks->get('before'),
        $self->hooks->get('during'),
        $self->hooks->get('after'),
    );

    $self->terminated(0);
    for my $schedule (@schedules) {
        if (isa_arrayref $schedule) {
            for my $task ($schedule->list) {
                next if $self->terminated or !$task->typeof('code');
                $task->call($self, @_);
            }
        }
    }

    return $self->result;
}

sub hook {
    my $self = _object shift;
    my $name = _string shift;
    my $code = _coderef shift;
    my $list = $self->hooks->get($name);

    unless ($list->typeof('array')) {
        # transition add-hook failure
        State::Machine::Failure->raise(
            class      => 'transition/hook',
            message    => "Unrecognized hook ($name) in transition.",
            transition => $self,
            hook       => $name,
        );
    }

    $list->push($code);
    return $self;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use State::Machine::Transition;

    my $trans = State::Machine::Transition->new(
        name   => 'resume',
        result => State::Machine::State->new(name => 'awake')
    );

    $trans->hook(during => sub {
        # do something during resume
    });

=head1 DESCRIPTION

State::Machine::Transition represents a state transition and it's resulting
state.

=has executable

    my $executable = $trans->executable;
    $trans->executable(1);

The executable flag determines whether a transition can be execute.

=has hooks

    my $hooks = $trans->hooks;

The hooks attribute contains the collection of triggers and events to be fired
when the transition is executed. The C<hook> method should be used to configure
any hooks into the transition processing.

=has name

    my $name = $trans->name;
    $name = $trans->name('suicide');

The name of the transition. The value can be any scalar value.

=has result

    my $state = $trans->result;
    $state = $trans->result(State::Machine::State->new(...));

The result represents the resulting state of a transition. The value must be a
L<State::Machine::State> object.

=has terminated

    my $terminated = $trans->terminated;
    $trans->terminated(1);

The terminated flag determines whether a transition in-execution should
continue (i.e. processing hooks). This flag is reset on each execution an is
meant to be called from within a hook.

=method hook

    $trans = $trans->hook(during => sub {...});
    $trans->hook(before => sub {...});
    $trans->hook(after => sub {...});

The hook method registers a new hook in the append-only hooks collection to be
fired when the transition is executed. The method requires an event name,
either C<before>, C<during>, or C<after>, and a code reference.

=cut
