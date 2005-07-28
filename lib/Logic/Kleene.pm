=head1 NAME

Logic::Kleene - Kleene three-valued logic

=begin readme

=head1 REQUIREMENTS

This module requires Perl 5.6.0 or newer. Only core modules are used.

=head1 INSTALLATION

Installation can be done using the traditional F<Makefile.PL> or the
newer F<Build.PL> method .

Using Makefile.PL:

  perl Makefile.PL
  make test
  make install

(On Windows platforms you should use F<nmake> instead.)

Using Build.PL (if you have L<Moddule::Build> installed):

  perl Build.PL
  perl Build test
  perl Build install    

You may see warnings about undefined values during testing. This is normal.

=end readme

=head1 SYNOPSIS

  use Logic::Kleene;

  $a = !kleene( somefunction() );

  if ($a && $b) { ... } 

=head1 DESCRIPTION

This module implements Kleene three-valued logic via overloading.

The third value is between true and false, and is equivalent to
an undefined value (as when a program has not yet returned a
value).

The significant different is that the negation of an undefined value 
is still undefined (and so treated as false).  For example,

  my $status = kleene(somefunction());
  if (!$status) {
    print "somefunction failed";
  }

If the status value is false, then it will print the failure
message, as expected.  But if the status is undefined, then it
will not print the message.

=for readme stop

It is important to note that

  kleene(!$x)

is not equivalent to

  !kleene($x)

since in the first case, C<$x> may not be a Kleene value.

=for readme continue

=begin readme

=head1 REVISION HISTORY

The following changes have been made since the last release:

=for readme include file="Changes" type="text" start="^0.05" stop="^0.04"

=end readme

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

package Logic::Kleene;

require 5.006;

use strict;
use warnings;

our $VERSION = '0.05';

require Exporter;

our @ISA = qw( Exporter );

our %EXPORT_TAGS = ( "all" => [qw( kleene )] );
our @EXPORT = qw( kleene );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{"all"} } );

use overload 
  "0+"   => \&to_bool,
  "bool" => \&to_bool,
  "cmp"  => \&kleene_cmp,
  "<=>"  => \&kleene_cmp,
  "!"    => \&kleene_neg,
  "not"  => \&kleene_neg,
  "and"  => \&kleene_and,
  "or"   => \&kleene_or,
  "&&"   => \&kleene_and,
  "||"   => \&kleene_or,
  "^"    => \&kleene_xor,
  "&"    => \&kleene_and,
  "|"    => \&kleene_or;


my %Singletons = ( );

sub new {
  my $class = shift || __PACKAGE__;
  my $value = shift;
  if (defined $value) {
    return $value if (ref($value) && (UNIVERSAL::isa($value, __PACKAGE__)));
    $value = ($value)? 1 : 0;
  } else {
    $value = 0.5;
  }
  return $Singletons{$value} if (exists $Singletons{$value});
  my $self = \$value;
  bless $self, $class;
  return $Singletons{$value} = $self;
}

sub kleene {
  return __PACKAGE__->new(@_);
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

sub kleene_cmp {
  my ($a,$b) = map { __PACKAGE__->new($_) } @_;
  return ($$a <=> $$b);
}

sub kleene_or {
  my ($a,$b) = map { __PACKAGE__->new($_) } @_;
  if ($$a >= $$b) {
    return $a;
  } else {
    return $b;
  }
}

sub kleene_and {
  my ($a,$b) = map { __PACKAGE__->new($_) } @_;
  if ($$a <= $$b) {
    return $a;
  } else {
    return $b;
  }
}

sub kleene_neg {
  my ($a) = map { __PACKAGE__->new($_) } @_;
  if ($$a != 0.5) {
    return __PACKAGE__->new(1-$$a);
  } else {
    return $a;

  }
}


sub kleene_xor {
  my ($a,$b) = map { __PACKAGE__->new($_) } @_;
  return kleene_neg(kleene_and(
    kleene_or(kleene_neg($a),$b), kleene_or(kleene_neg($b),$a)
  ));
}


1;

