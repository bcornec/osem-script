#!/usr/bin/perl -w
#
use strict;
use DBI;

my $dbh = DBI->connect("DBI:mysql:database=osem;host=localhost", "osem", $ENV{''}, {'RaiseError' => 1});
