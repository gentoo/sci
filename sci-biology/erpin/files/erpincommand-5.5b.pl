#!/usr/bin/perl

# This script requires that binaries: ev, cfgs, tstat from the Erpin distribution
# are present in the default program path

$cfglow = 500; #max configs per step in stepwise search

#Evalues are for 10Mb (computed using ev command)
#$mineval    will not extend motifs further when this Evalue is reached
#$mineval2   Second search threshold (when relaxing)
#$maxeval    FINAL search threshold. All motifs should be lower
#typical:
#$mineval = 1e-7;
#$mineval2 = 1e-4;  
#$maxeval = 1e-3;  
#----------------------------------------------------------------------

$mineval = 1e-3; 
$mineval2 = 1e-2;
$maxeval = 1e-1;  

$maxpcw = 100;
$evalreduc = 1; #evalue reduction for training sets below 25 sequences


if ($#ARGV < 0) {
    print STDERR "erpincommand.pl <epn file> \n";
    print STDERR "Erpin command finder\n";
    exit;
}

$epnfile = $ARGV[0];

$p="ev";
if (($x = system ($p))==-1) {
    print STDERR "Can't find program \"$p\"\n";
    print STDERR "This program from the Erpin distribution must be present in your default path\n";
    exit;
}

$p="cfgs";
if (($x = system ($p))==-1) {
    print STDERR "Can't find program \"$p\"\n";
    print STDERR "This program from the Erpin distribution must be present in your default path\n";
    exit;
}

$p="tstat";
if (($x = system ($p))==-1) {
    print STDERR "Can't find program \"$p\"\n";
    print STDERR "This program from the Erpin distribution must be present in your default path\n";
    exit;
}

if (!open(F, $epnfile)) {
    print STDERR "Can't open \"$epnfile\"\n";
    exit;
}

if ($ARGV[2] =~ m/-watch/g) {
    $watch = 1;
}

close F2;

#--------------------------------------------------
# Analyze structure lines
#--------------------------------------------------

while (($line = <F>) && ($line !~ /^>/)) {}

$i=0;
while (($line = <F>) && ($line !~ /^>/)) {
    chop $line;
    $s[$i]= $line;
    $i++;
}

close F;

#foreach $x (@s){
#    print $x, "\n";
#}

$j=length($s[0]);
$k=0;
$k1=0;

$preve=-1;
for ($i=0; $i<$j; $i++) {
    $e="";
    foreach $x (@s){
        $e.=substr($x,$i,1);
    }
    # list with only left strand of helices
    if (!exists ($elts{$e})) {
        $oelts[$k]=$e;
        $elts{$e}=1;
        $k++;
    }
    # list with all helix strand
    if ($e != $preve) {
        $oeltsall[$k1]=$e;
        $preve=$e;
        $k1++;
    }
    $preve=$e;
}

$nbelts = $k;
#print "$k elts\n";

$firste=$oelts[0];
$laste=$oelts[$#oelts];
$lasteall=$oeltsall[$#oeltsall];

#---locates helices
$i=0;
foreach $e (@oeltsall) {
    if (exists ($pos5{$e})){
        #---it's a helix!
        $pos3{$e}=$i;
    }else{
	$pos5{$e}=$i;
    }
    $i++;
}

#print "\n";
#foreach $e (@oeltsall) {
#    print " $e($pos5{$e})";
#    if (exists ($pos5{$e})){
#       print "H($pos5{$e})";
#    }
#}
#print "\n";


$i=0;
foreach $e (@oeltsall) {
    if (!exists ($pos3{$e})){
        $lastss=$e;
    }else{
        $flankss{$e}=$lastss;
    }
}

foreach $e (@oeltsall) {
    print STDERR $e, " ";
}
print STDERR "\n";

$out = `tstat $epnfile \-$firste,$lasteall -umask $lasteall`;
$out =~ /(\d+)\s+sequences of length/;
$nbseqs=$1;

print STDERR "$nbseqs seqs in set\n";

#---------------------------------------------------------
# Select best EV elements
#---------------------------------------------------------

$rootev = "ev $epnfile \-$firste,$lasteall ";

$mask = "";
$beste=10e50;
$bestevforthisrun=10e100;
$message="";

while (((keys %elts) != ()) && ($beste > $mineval) && ($beste < 10e100) ) {
    $beste=10e200;
    foreach $e1 (keys %elts) {
        $command = $rootev . $mask. " -add $e1";
        $out = `$command`;
        $out =~ /data:\s*([\de\.\-\+]+)/;
        $ev=$1;
        if (($ev != 0) && ($ev<$beste)){
            $beste1=$e1;
            $beste=$ev;
        }
    }
    $mask .= " -add $beste1";
    print STDERR "$mask -> E= $beste\n";
    if ($beste<$bestevforthisrun){
        $bestevforthisrun=$beste;
        $bestmaskforthisrun=$mask;
        $nbseqinbest++;
    }
    delete $elts{$beste1};
#    print STDERR "KEYS:", join (" ",keys %elts), "\n";
    push (@searchorder, $beste1);
}

if ($bestevforthisrun > $mineval) {
    $message .= "Step 1: No E-value better than $mineval  (E= $bestevforthisrun) / 10Mb";
    for ($i=$nbelts; $i>$nbseqinbest; $i--){
        pop(@searchorder);
    }
}else{
    $message .= "OK (E= $bestevforthisrun)";
}

#---------------------------------------------------------
# Reorder using heuristic:
#---------------------------------------------------------

@searchorder = sort (@searchorder);

#fills SS & H lists
foreach $e (@searchorder) {
    if (!exists ($pos3{$e})){  # strand!
        push (@SS, $e);
    }else{
        push (@H, $e);
    }
}

@SS = reverse @SS;


#-- sort helices by position of 3' strand
@sorted = sort mysort @H;
@H = reverse @sorted;

#print "\nH: ", join (" ", @H), "\n";
#print "SS: ", join (" ", @SS), "\n\n";

if (@SS) {
    $e= pop (@SS);
}else{
    $e= pop (@H);
}

push (@reorder,$e);

while (@H || @SS){
    $x=$H[$#H];
    if (@H && (($flankss{$x} < $prevss) || !@SS)) {
        $e= pop (@H);
        push (@reorder,$e);
    }else{
        if (@SS){
            $e= pop (@SS);
            push (@reorder,$e);
            $prevss=$e;
        }
    }
}

#print "Search elts: ", join (" ", @reorder), "\n";

@searchorder = @reorder;


#---------------------------------------------------------
# Define search steps using cfgs function
#---------------------------------------------------------

$steps=1;
$rootcfgs = "cfgs $epnfile \-$firste,$lasteall";
$masks = " -add";

foreach $e (@searchorder) {
    $command = $rootcfgs . $masks. " $e";
    #print "---------------------------------------\n$command\n";
    $out = `$command`;
    #print $out;
    @x = $out =~ /config\.number:\s*(\d+)/g;
    $cfg = $1;
    #print "---> $cfg\n";
    if ($cfg < $cfglow) {
        $masks .= " $e";
    } else {
        $masks .= " -add $e";
        $steps++;
    }
}

#---------------------------------------------------------
# Adds begin and end of motif to ensure full match
#---------------------------------------------------------

#$masks .= " -add $firste $lasteall";

#---------------------------------------------------------
# modifies cutoffs
#---------------------------------------------------------

$command = $rootev . $masks . $laststep;
$out = `$command`;
$out =~ /Cutoff:\s+(.*)/mg;

@cuts = split (" ", $1);

#$out =~ /data:\s*([\de\.\-\+]+)/g;
#$newev=$1;
#print STDERR "New EV: $newev\n";

$ev = $bestevforthisrun;
$newcut = 100;
$newpcw=1;
foreach $c (@cuts){
    $cutoffs .= " $newcut\%";
}

#-------- Relax motif

while (($ev < $mineval2) && ($newpcw < $maxpcw)) {
    $cutoffs =" -cutoff";
    if ($nbseqs > 25) {
        $newpcw += 10;
        $newcut += 1;
        foreach $c (@cuts){
            $cutoffs .= " $newcut\%";
        }
    }else{
        $newpcw += 10;
        $evalreduc++;
        foreach $c (@cuts){
            $c2 = $c - $evalreduc;
            $cutoffs .= " $c2";
        }
    }
    $command = $rootev . $masks . $laststep . " -pcw $newpcw".  $cutoffs;
    print STDERR $command, "\n";
    $out = `$command`;
    $out =~ /data:\s*([\de\.\-\+]+)/g;
    $ev=$1;
    print STDERR "New EV: $ev\n";
}

#-------- Tighten motif

while (($ev > $maxeval) && ($newcut > 90)) {
    $cutoffs =" -cutoff";
    $newcut -= 1;
    foreach $c (@cuts){
	$cutoffs .= " $newcut\%";
    }
    $command = $rootev . $masks . $laststep . " -pcw $newpcw".  $cutoffs;
    print STDERR $command, "\n";
    $out = `$command`;
    $out =~ /data:\s*([\de\.\-\+]+)/g;
    $ev=$1;
    print STDERR "New EV: $ev\n";
}

if ($ev > $maxeval) {
    $message .= " - Step 2: No E-value better than $maxeval (E=$ev) /10Mb";
}

#with region from $leftmost to last
$leftmost = 99999;
$pos5{$leftmost} = 99999;
foreach $e (@searchorder) {
    if ($pos5{$e} < $pos5{$leftmost}){
        $leftmost=$e;
    }
}

$erpincommand = "erpin $epnfile DATABASE \-$leftmost,$lasteall $masks -pcw $newpcw $cutoffs";

print  "$message\n";
print  "BEST ERPIN COMMAND:\n";
print  "$erpincommand \n\n";


sub mysort{
    $xa = $flankss{$a};
    $xb = $flankss{$b};

    $xa <=> $xb ;
}
