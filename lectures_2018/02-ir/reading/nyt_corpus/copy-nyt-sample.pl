#!/usr/bin/perl

# Copy a set of files from the NYT Annotated Corpus on my external hard disk to
# to the current directory
# File list gets piped to STDIN, one line per file, locations relative to
# the 

$location = "/Volumes/Divan/nyt_corpus/data/";

$usage = "location_base < filelist";

unless (scalar @ARGV < 2) {
    die("Too many argments.\nUsage: $0 $usage\n");
}
if (scalar @ARGV == 1) {
    $location = shift(@ARGV);
    print "Set location to $location";
}

while (<>) {
    chomp; # Remove trailing newline!
    $filename = $_;
    m/(\d+.xml)/; # Match the last part of the file name, which is the
                  # (unique) file serial number, then ".xml"
    $shortname= $1;
    system("cp $location$filename $shortname")
}

