#!/usr/bin/perl

use strict;
use warnings;

my $file = "$ENV{HOME}/projects/test.fa";
open my $dna, "<:encoding(utf8)", $file or die "$file: $!";
my $line_count = 0;
my $total_GC = 0;
my $total_DNA = 0;
my $transcript_count = 1;
my $GC_percentage = 0;
    
while (my $line = <$dna>) {
    chomp $line;
    if ($line =~ m/^>/) {
        if ($total_DNA > 0) {
            $GC_percentage = ($total_GC * 100.0) / $total_DNA;
            printf "%-2d %-5.2f lines: %d\n", $transcript_count, $GC_percentage, $line_count;
            $transcript_count++;
        }
        $total_GC = 0;
        $total_DNA = 0;
        $line_count = 0;
    }
    else {
        my @GC = $line =~ m/[GC]/g; 
        my $GC_count = scalar(@GC);
        my $DNA_count = length($line);
        $line_count++;
        $total_GC += $GC_count;
        $total_DNA += $DNA_count;
    }

}

$GC_percentage = ($total_GC * 100.0) / $total_DNA;
printf "%-2d %-5.2f lines: %d\n", $transcript_count, $GC_percentage, $line_count;



