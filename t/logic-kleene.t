#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

plan tests => 99;

use_ok("Logic::Kleene", 0.05);

sub not_ok {
  my ($flag, $string) = @_;
  if ($flag) {
    ok(0,$string);
  } else {
    ok(1,$string);
  }
}

my $a = kleene(1);
ok(defined $a);
ok($a);

my $b = kleene(0);
ok(defined $b);
ok(!$b);

my $c = kleene();
ok(defined $c);
ok(!defined $c->to_bool);
not_ok(!$c);

my $d = undef;

not_ok(!$a);
ok(!$b);
not_ok(!$c);
not_ok(!!$c);

not_ok(not $a);
ok(not $b);
not_ok(not $c);
not_ok(not not $c);


ok($a | $a);
ok($a | $b);
ok($a | $c);
ok($a | 1);
ok($a | undef);
ok($a | 0);
ok(1 | $a);
ok(undef | $a);
ok(0 | $a);
ok(!($b | $b));
not_ok(($b | $c));
not_ok(($c | $c));

ok($a & $a);
ok(!($a & $b));
not_ok(!($a & $c));
ok(($a & 1));
not_ok(($a & undef));
ok(!($a & 0));
ok((1 & $a));
not_ok(($d & $a));
ok(!(0 & $a));
ok(!($b & $b));
not_ok(($b & $c));
not_ok(($c & $c));

ok(!($a ^ $a));
ok(($a ^ $b));
ok(!($b ^ $b));
not_ok(!($a ^ $c));
not_ok(!($c ^ $c));
ok(!($a ^ 1));
ok(($a ^ 0));
not_ok(!($a ^ undef));
ok(!(1 ^ $a));
ok((0 ^ $a));
not_ok(!(undef ^ $a));

ok($a || $a);
ok($a || $b);
ok($a || $c);
ok($a || 1);
ok($a || undef);
ok($a || 0);
ok(1 || $a);
ok(undef || $a);
ok(0 || $a);

ok($a && $a);
ok(!($a && $b));
not_ok(!($a && $c));
ok(($a && 1));
not_ok(($a && undef));
ok(!($a && 0));
ok((1 && $a));
not_ok((undef && $a));
ok(!(0 && $a));

ok($a or $a);
ok($a or $b);
ok($a or $c);
ok($a or 1);
ok($a or undef);
ok($a or 0);
ok(1 or $a);
ok(undef or $a);
ok(0 or $a);

ok($a and $a);
ok(!($a and $b));
not_ok(!($a and $c));
ok(($a and 1));
not_ok(($a and undef));
ok(!($a and 0));
ok((1 and $a));
not_ok((undef and $a));
ok(!(0 and $a));

ok($a >= $a);
ok($c >= $c);
ok($b >= $b);

ok($a > $b);
ok($a > $c);
ok($c < $a);
ok($c > $b);
ok($b < $a);
ok($b < $c);

ok("$a" eq "1");
ok("$b" eq "0");
ok("$c" eq "");  # this should output a warning

