# State::Machine::Transition Execution Failure Class
package State::Machine::Failure::Transition::Execution;

use Bubblegum::Class;
use Function::Parameters;

use Bubblegum::Constraints -typesof;

extends 'State::Machine::Failure::Transition';

# VERSION

has 'captured' => (
    is       => 'ro',
    isa      => typeof_defined,
    required => 1
);

method _build_message {
    "Transition execution failure."
}

1;
