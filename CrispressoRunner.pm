package CrispressoRunner;
use strict;
use warnings;
use IPC::Run3;


sub new {
    my ($class, $experiment, $barcode, $parameters) = @_;
    my $self = {
        experiment => $experiment,
        barcode => $barcode,
        parameters => $parameters
    } ;
    bless $self, $class;
    return $self;
}

sub run {
    my ($self) = @_;
    my $cmd = $self->{parameters};
    my $stdout = "$self->{experiment}_$self->{barcode}.out";
    my $stderr = "$self->{experiment}_$self->{barcode}.err";
    run3 $cmd, undef, $stdout, $stderr;
}
1;







