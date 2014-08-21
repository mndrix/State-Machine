# State::Machine::Transition Unknown Failure Class
package State::Machine::Failure::Transition::Unknown;

use Bubblegum::Class;
use Function::Parameters;

extends 'State::Machine::Failure';

# VERSION

method _build_message {
    "Transition unknown."
}

1;
