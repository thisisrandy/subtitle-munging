#!/usr/bin/perl

# Script to adjust srt offsets
# USAGE: subfix.pl <subfile.srt> <delta in seconds, neg/fractional okay (fractions in ms)>

use warnings;

sub adjust {
	($diff, $h, $m, $s, $ms) = @_;
	$sms = "$s.$ms";
	$sms += $diff;
	$ms = ($sms - ($s = int($sms)))*1000;
	if($ms < 0) {
		$ms += 1000;
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
	return ($h, $m, $s, $ms);
}

open FILE, "<" . (shift) or die $!;

die "Must specify non-zero delta" unless ($diff = shift);

while(<FILE>) {
	if(/(\d+):(\d+):(\d+)[,\.](\d+) --> (\d+):(\d+):(\d+)[,\.](\d+)/) {
		($h1, $m1, $s1, $ms1, $h2, $m2, $s2, $ms2) = ($1, $2, $3, $4, $5, $6, $7, $8);
		($h1, $m1, $s1, $ms1) = adjust($diff, $h1, $m1, $s1, $ms1);
		($h2, $m2, $s2, $ms2) = adjust($diff, $h2, $m2, $s2, $ms2);

		printf "%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d\n", $h1, $m1, $s1 ,$ms1, $h2, $m2, $s2, $ms2;
	} else {
		print
	}
}

close FILE;
