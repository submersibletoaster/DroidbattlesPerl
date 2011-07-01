#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';
use Data::Dumper;
use Droidbattles::BASM::Parser;

my $p = new Droidbattles::BASM::Parser;

$p->Run;

print Dumper $p->YYData if @ARGV;
