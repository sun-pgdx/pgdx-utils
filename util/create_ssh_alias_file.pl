#!/usr/bin/env perl
use strict;
use File::Copy;

my $prefix = 'pgdx-pr';

my $outfile = '/tmp/ssh-aliases.txt';

my $username = getlogin();

my $target = "/home/$username/ssh-aliases.txt";

open (OUTFILE, ">$outfile") || die "Could not open output file '$outfile' in write mode : $!";

for (my $i = 0; $i < 50 ; $i++){
    my $cmd = "alias ssh-$i='ssh $prefix$i'";
    print OUTFILE $cmd . "\n";
}

close OUTFILE;
print "Wrote file '$outfile'\n";

if (-e $target){
    my $bakfile = $target . '.' . time() . '.bak';
    copy($target, $bakfile) || die "Could not copy '$target' to '$bakfile' :$ !";
}

copy($outfile, $target) || die "Could not copy '$outfile' to '$target' : $!";

print  "Add the following line to your ~/.bashrc:\n";
print "source ~/ssh-aliases.txt\n";
exit(0);
