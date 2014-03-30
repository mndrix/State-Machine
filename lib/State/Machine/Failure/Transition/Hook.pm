# State::Machine::Transition Hook Failure Class
package State::Machine::Failure::Transition::Hook;

use Bubblegum::Class;
use Bubblegum::Constraints -minimal;

extends 'State::Machine::Failure::Transition';

# VERSION

has hook => (
    is       => 'ro',
    isa      => _string,
    required => 1
);

1;
