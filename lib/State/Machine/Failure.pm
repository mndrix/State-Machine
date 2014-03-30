# State::Machine Failure Class
package State::Machine::Failure;

use Bubblegum::Class;
use Class::Forward;

use Bubblegum::Constraints -minimal;
use Class::Load 'load_class';

extends 'Bubblegum::Exception';

# VERSION

has 'explain' => (
    is  => 'ro',
    isa => _string,
);

sub raise {
    my ($class, %args) = @_;
    shift && unshift @_, my $goto = clsf _string $args{class};
    load_class($goto) && goto $goto->can('throw');
}

1;
