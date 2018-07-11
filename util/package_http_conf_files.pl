#!/usr/bin/env perl
use strict;
use File::Copy;
use File::Path;
use File::Basename;
use Sys::Hostname;

use constant DEFAULT_HTTP_DIR => '/etc/httpd/';

use constant DEFAULT_OUTDIR => '/tmp/package_http_conf_files/' . time();

my $indir = $ARGV[0];
if (!defined($indir)){
	$indir = DEFAULT_HTTP_DIR;
	print "indir was not specified and therefore was set to default '$indir'\n";
}

my $outdir = DEFAULT_OUTDIR;
if (!-e $outdir){
	 mkpath($outdir) || die "Could not create output directory '$outdir' : $!";
	 print "Created directory '$outdir'\n";
}


my $outfile = $outdir . '/http-conf-files-' . hostname() . '.tgz';


my $cmd = "find $indir -name '*.conf'";

my @file_list;

eval {
	@file_list = qx($cmd);
};

if ($?){
	die "Encountered some error while attempting to execute '$cmd' : $! $@";
}

chomp @file_list;

foreach my $file (@file_list){
	
	my $target_file = $outdir . '/' . File::Basename::basename($file);
	
	copy($file, $target_file) || die "Could not copy '$file' to '$target_file' : $!";
}	

chdir($outdir) || die "Could not change into directory '$outdir' : $!";

my $cmd = "tar zcvf $outfile *.conf";

eval {
	qx($cmd);
};

if ($?){
	die "Encountered some error while attempting to execute '$cmd' : $! $@";
}


print "Here is the bundle '$outfile'\n";
exit(0);