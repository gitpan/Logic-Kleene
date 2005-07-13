=head1 NAME

logic::kleene - Kleene three-valued logic

=head1 SYNOPSIS

  use logic::kleene;

  $a = !kleene::logic->new( somefunction() );

  if ($a && $b) { ... } 

=head1 DESCRIPTION

This module implements Kleene three-valued logic via overloading.

The third value is between true and false, and is equivalent to
an undefined value (as when a program has not yet returned a
value).

=head1 AUTHOR

Robert Rothenberg <rrwo at cpan.org>

=head2 Suggestions and Bug Reporting

Feedback is always welcome.  Please use the CPAN Request Tracker at
L<http://rt.cpan.org> to submit bug reports.

=head1 LICENSE

Copyright (c) 2005 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

package logic::kleene;

require 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use overload 
  "bool" => \&to_bool,
  "!"    => \&kleene_neg,
  "and"  => \&kleene_and,
  "or"   => \&kleene_or,
  "&&"   => \&kleene_and,
  "||"   => \&kleene_or,
  "^"    => \&kleene_xor,
  "&"    => \&kleene_and,
  "|"    => \&kleene_or;


use Memoize;

BEGIN { memoize(\&new); }

sub new {
  my $class = shift || __PACKAGE__;
  my $value = shift;
  if (defined $value) {
    $value = ($value)? 1 : 0;
  } else {
    $value = 0.5;
  }
  my $self = \$value;
  bless $self, $class;
}

sub to_bool {
  my $self = shift;
  my $value = $$self;
  if ($value != 0.5) {
    return $value;
  } else {
    return;
  }
}

sub kleene_or {
  my ($a,$b) = @_;
  $a = __PACKAGE__->new($a) unless (UNIVERSAL::isa($a, __PACKAGE__));
  $b = __PACKAGE__->new($b) unless (UNIVERSAL::isa($b, __PACKAGE__));
  if ($$a >= $$b) {
    return $a;
  } else {
    return $b;
  }
}

sub kleene_and {
  my ($a,$b) = @_;
  $a = __PACKAGE__->new($a) unless (UNIVERSAL::isa($a, __PACKAGE__));
  $b = __PACKAGE__->new($b) unless (UNIVERSAL::isa($b, __PACKAGE__));
  if ($$a <= $$b) {
    return $a;
  } else {
    return $b;
  }
}

sub kleene_neg {
  my ($a) = @_;
  $a = __PACKAGE__->new($a) unless (UNIVERSAL::isa($a, __PACKAGE__));
  if ($$a != 0.5) {
    return __PACKAGE__->new(1-$$a);
  } else {
    return $a;

  }
}

sub kleene_xor {
  my ($a,$b) = @_;
  return kleene_neg(kleene_and(
    kleene_or(kleene_neg($a),$b), kleene_or(kleene_neg($b),$a)
  ));
}


1;

