# State::Machine::Transition Execution Failure Class
package State::Machine::Failure::Transition::Execution;

use Bubblegum::Class;
use Function::Parameters;

extends 'State::Machine::Failure::Transition';

# VERSION

method _build_message {
    "Transition execution failure."
}

1;
