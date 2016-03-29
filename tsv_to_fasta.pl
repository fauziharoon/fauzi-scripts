#!/usr/bin/env perl

use strict;
use warnings;

# tsv file
my $fasta_out = $ARGV[1];
open my $fh2, '>', $fasta_out;
my $tsv_file = $ARGV[0];
open my $fh, '<', $tsv_file or die "Couldn't open file $tsv_file";
while (<$fh>)
{
        next if $_ =~ /^#/;
        next if $_ =~ /^GeneID/;
        chomp $_;
        my @columns = split (/\t/, $_);
        print {$fh2} ">$columns[0]\n$columns[2]\n";
}

close ($fh2);
close ($fh);

