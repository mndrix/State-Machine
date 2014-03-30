# State::Machine Transition Failure Class
package State::Machine::Failure::Transition;

use Bubblegum::Class;
use Bubblegum::Constraints -minimal;

extends 'State::Machine::Failure';

# VERSION

has transition => (
    is       => 'ro',
    isa      => _object,
    required => 1
);

1;
