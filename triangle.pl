#!/usr/bin/perl

use strict;
use warnings;

sub triangle_maker {
    my @number_list = @_;
    push @number_list, 0;
    unshift @number_list, 0;
    my @next_list;
    foreach my $index (1 .. (scalar @number_list - 1)) {
        my $number = $number_list[$index] + $number_list[($index - 1)];
        push @next_list, $number;
    }
    return @next_list;
}

sub triangle_printer {
    my @number_list = @{$_[0]};
    for my $line (1 .. $_[1]) {
        print "@number_list\n";
        @number_list = triangle_maker(@number_list);
    }
}

my @a = (1);
my $b = 10;

triangle_printer(\@a, $b);


