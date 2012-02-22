#!/usr/bin/perl

use warnings;
use strict;

my %wobble_hash = ();
my @y_array = ('C', 'T');
my @s_array = ('C', 'G');
my @h_array = ('A', 'C', 'T');
my @r_array = ('A', 'G');
$wobble_hash{'Y'} = \@y_array;
$wobble_hash{'S'} = \@s_array;
$wobble_hash{'H'} = \@h_array;
$wobble_hash{'R'} = \@r_array;
my @fixed_strings = ();

unless($ARGV[0])
{
    print "no input file provided\nUSAGE:\t./wobble2.pl <FILE>\n";
}
open(IN, '<', $ARGV[0]) or die $!;

my @bad_strings = ();
while(my $line = <IN>)
{
   chomp $line;
   push(@bad_strings,$line);
}

foreach my $string (@bad_strings)
{

   @fixed_strings = fixOneChar($string);  
   foreach my $fs (@fixed_strings)
   {	
      print "$fs\n";
   }
}

######################
# SUBS
#####################

sub fixOneChar
{
   my ($string) = @_;
   my @characters = split //, $string;
   my $base_string = "";
   my $end_string = "";
   my $mode = "find";
   my @return_array = ();

   foreach my $char (@characters)
   {
       if($mode eq "found")
       {
           $end_string = $end_string . $char;
           next;
       }

       if(exists $wobble_hash{$char})
       {
           # we need to make some new strings
           foreach my $wc (@{$wobble_hash{$char}})
           { 
               my $fixed_string = $base_string.$wc;
               push @return_array, $fixed_string;
           }
           $mode = "found";
       }
       else
       {
           $base_string = $base_string . $char;
       }
   }

   if($mode eq "find")
   {
      # we never found any wobbles
      return ($string);
   }
   else
   {
       my @mike_is_a_fool_at_naming_arrays = ();
       # $# gives you the size of the array
       foreach my $i (0..$#return_array)
       {
           $return_array[$i] = $return_array[$i] . $end_string;
           my @tmp_return_array = fixOneChar($return_array[$i]);
           foreach my $final_string (@tmp_return_array)
           {
               push @mike_is_a_fool_at_naming_arrays, $final_string;
           }
       }
       return @mike_is_a_fool_at_naming_arrays;
   }
}

sub revcomp
{
   my ($seq) = @_;
   $seq =~ tr/ACGTacgt/TCGAtcga/;
   return reverse $seq;
}
