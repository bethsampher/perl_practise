#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use File::Spec::Functions;
use CrispressoRunner;
use Text::CSV::Hashify;
use threads;
use Thread::Queue;


sub create_crispresso {
    my $spreadsheet = $ARGV[0] or die "Please also type the path of the csv file in the folder.";
    my $folder = dirname($spreadsheet);
    my $counter = 0;
    my @processes;
    my $spreadsheet_reader = Text::CSV::Hashify->new( {
            file => "$spreadsheet",
            format => "aoh" });
    my $spreadsheet_data = $spreadsheet_reader->all;
    opendir(my $folder_handle, $folder) or die "Could not open folder.";
    my @filelist = readdir($folder_handle);
    closedir($folder_handle);
    foreach my $filename (@filelist) {
        if ($filename =~ /^(\d+)_S\1_L001_R1_001\.fastq$/) {
            my $barcode = $1;
            my $filename_two = "${barcode}_S${barcode}_L001_R2_001.fastq";
            my $path1 = catfile($folder, $filename);
            my $path2 = catfile($folder, $filename_two);
            foreach my $data_hash (@$spreadsheet_data) {
                my @parameters = ("/usr/local/bin/CRISPResso",
                    "-r1", $path1, "-r2", $path2,
                    "-a", $data_hash->{Amplicon},
                    "-g", $data_hash->{Crispr},
                    "-w", "50",
                    "-o", "S${barcode}exp$data_hash->{Experiment}",
                    "--hide_mutations_outside_window_NHEJ");
                    if ((defined $data_hash->{HDR}) and ($data_hash->{HDR} ne "")) {
                        push @parameters, ("-e", $data_hash->{HDR});
                    }
                    if (($barcode >= $data_hash->{min_index}) and ($barcode <= $data_hash->{max_index})) {
                        my $CRobject = new CrispressoRunner($data_hash->{Experiment}, $barcode, \@parameters);
                        push @processes, $CRobject;
                        $counter++
                    }
                    if ($counter >= 2) {
                        return @processes;
                    }
                }
            }
        }
    }

my @CRobject_list = create_crispresso;
foreach my $CRobject (@CRobject_list) {
    $CRobject->run;
}

