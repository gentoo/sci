#!/usr/bin/perl -w

## Very simple perl script to drive the Bambus 2.0 pipeline (as I
## currently understand it).
## http://sourceforge.net/apps/mediawiki/amos/index.php?title=Bambus_2.0/goBambus-perl
## as of 201103021123

use strict;
use Getopt::Long;



## Configure defaults

my $verbose = 1;

my $contig_file = '';
my $fasta_file  = '';
my $mates_file  = '';

my $output_prefix = 'out';

## The threshold used to accept or reject a link between contigs
my $link_redundancy = 1;

## Weather or not to run the (crappy) 'repeat filter' code
my $filter_repeats  = 0;

## Not running dot saves time on 'big' runs
my $run_dot = 1;



## Process command line arguments

GetOptions
  ("contig_file=s"   => \$contig_file,
   "fasta_file=s"    => \$fasta_file,
   "mates_file=s"    => \$mates_file,
   "output_prefix=s" => \$output_prefix,

   "link_redundancy|r=i" => \$link_redundancy,
   "repeat_filter|x"     => \$filter_repeats,
   "dot|d!"              => \$run_dot,
   "verbose+"            => \$verbose,
  )
  or die "failure to communicate\n";

die "-c contig file plz!\n" unless -s $contig_file;
die "-f fasta  file plz!\n" unless -s $fasta_file;
die "-m mates  file plz!\n" unless -s $mates_file;

die "are you crazy?\n"
  if $output_prefix eq '';

warn
  join("\n",
       "contig file     : $contig_file",
       "fasta file      : $fasta_file",
       "mates file      : $mates_file",
       "output prefix   : $output_prefix",
       "link redundancy : $link_redundancy",
       "repeat filter   : $filter_repeats",
       "run dot?        : $run_dot",
       "verbose         : $verbose",
      ), "\n"
  if $verbose > 0;
#exit;



## Run the pipeline

## Get data into bank format

run(qq/
 toAmos
  -s $fasta_file
  -c $contig_file
  -m $mates_file
  -o $output_prefix.afg
/);

## Debugging mates file
#exit;

run(qq/
  bank-transact -cf
    -m $output_prefix.afg
    -b $output_prefix.bnk
/);



## Run the new Bambus pipeline

run(qq/
  clk
    -b $output_prefix.bnk
/);

run(qq/
  Bundler
    -b $output_prefix.bnk
/);

## Repeat filtering?
my $filter_repeats_option_string = '';
if($filter_repeats){
  run(qq/
    MarkRepeats
      -noCoverageRepeats
      -b $output_prefix.bnk
      -redundancy $link_redundancy
       > $output_prefix.repeats
  /);
  
  $filter_repeats_option_string =
    "-repeats $output_prefix.repeats";
}

run(qq/
  OrientContigs
    -noreduce
   $filter_repeats_option_string
    -b $output_prefix.bnk
    -redundancy $link_redundancy
    -prefix $output_prefix
/);



## Generate some additional TEXT output

## ouput a fasta sequence for the contigs from the bank (passed to
## printScaff with -f)

#run(qq/
#  bank2fasta -iid
#    -b $output_prefix.bnk
#     > $output_prefix.contig.fasta
#/);

## Generates the useful .details, .oo, .sum and .stats files
#    -f $output_prefix.contig.fasta
run(qq/
  printScaff -detail -oo -sum
    -e $output_prefix.evidence.xml
    -s $output_prefix.out.xml
    -l $output_prefix.library
    -o $output_prefix
/);

run(qq/
  mv -f
    printScaff.error
    $output_prefix.printScaff.error
/)
  if -s 'printScaff.error';





## UNTANGLE

run(qq/
  untangle
    -e $output_prefix.evidence.xml
    -s $output_prefix.out.xml
    -o $output_prefix.out.untangle.xml
/);

run(qq/
  mv -f
    untangle.error
    $output_prefix.untangle.error
/)
  if -s 'untangle.error';



## Generates the useful .details, .oo, .sum and .stats files
#    -f $output_prefix.contig.fasta
run(qq/
  printScaff -detail -oo -sum -dot
    -e $output_prefix.evidence.xml
    -s $output_prefix.out.untangle.xml
    -l $output_prefix.library
    -o $output_prefix.untangle
/);

run(qq/
  mv -f
    printScaff.error
    $output_prefix.untangle.printScaff.error
/)
  if -s 'printScaff.error';





## FINALLY, DOT

if($run_dot){
  # output before untangle
  run(qq/
    dot -Tps
      $output_prefix.dot
    > $output_prefix.ps
  /);
  
  # output after untangle
  run(qq/
    dot -Tps
      $output_prefix.untangle.dot
    > $output_prefix.untangle.ps
  /);
}

warn "OK\n";





## Yup

sub run{
  my $cmd = shift;
  
  $cmd =~ s/\n/ /g;
  
  print "\n\n\nRUN: $cmd\n\n"
    if $verbose > 0;
  
  `$cmd`;
  
  die if $? != 0;
  
  return 1;
}

