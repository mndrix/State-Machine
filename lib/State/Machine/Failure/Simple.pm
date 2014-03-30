# State::Machine::Simple Config Failure Class
package State::Machine::Failure::Simple;

use Bubblegum::Class;
use Bubblegum::Constraints -minimal;

extends 'State::Machine::Failure';

# VERSION

has config => (
    is       => 'ro',
    isa      => _arrayref,
    required => 1
);

1;
