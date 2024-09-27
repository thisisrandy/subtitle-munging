#!/usr/bin/perl

# Script to adjust ass offsets
# USAGE: subfix.ass.pl <subfile.ass> <delta in seconds, neg/fractional okay (fractions in hs)>

use warnings;

sub adjust {
	($diff, $h, $m, $s, $hs) = @_;
	$shs = "$s.$hs";
	$shs += $diff;
	$hs = ($shs - ($s = int($shs)))*100;
	if($hs < 0) {
		$hs += 100;
		$s--;
	}
	while($s < 0) {
		$s += 60;
		$m--;
		if($m < 0) {
			$m += 60;
			$h--;
		}
	}
	while($s >= 60) {
		$s -= 60;
		$m++;
		if($m >= 60) {
			$m -= 60;
			$h++;
		}
	}
	die "Created negative time" if $h < 0;
	return ($h, $m, $s, $hs);
}

open FILE, "<" . (shift) or die $!;

die "Must specify non-zero delta" unless ($diff = shift);

while(<FILE>) {
	if(/(.*)(\d+):(\d+):(\d+)[\.](\d+),(\d+):(\d+):(\d+)[\.](\d+)(.*)/) {
		($pre, $h1, $m1, $s1, $hs1, $h2, $m2, $s2, $hs2, $post) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
		($h1, $m1, $s1, $hs1) = adjust($diff, $h1, $m1, $s1, $hs1);
		($h2, $m2, $s2, $hs2) = adjust($diff, $h2, $m2, $s2, $hs2);

		printf "%s%02d:%02d:%02d.%02d,%02d:%02d:%02d.%02d%s\n", $pre, $h1, $m1, $s1 ,$hs1, $h2, $m2, $s2, $hs2, $post;
	} else {
		print
	}
}

close FILE;
