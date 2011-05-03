#!/usr/bin/perl -w

##
# Generate files containing site specific settings from config files and templates.
# @author Ralph Jenkin <Ralph.Jenkin@rhombus.com.au>
# @version $Id: configure.pl,v 1.2 2005/04/04 02:26:55 simonwade Exp $
##

use strict;
use Sys::Hostname;

my $configDir = "config";
my $defaultConfig = "$configDir/default.cfg";
my $configurableFilesList = "$configDir/configure-files.txt";
my $fileToConfigure;

my $userConfig;

if( defined $ARGV[0] ) {
	if( $ARGV[0] =~ /.*\.cfg/ ) {
		if( -r $ARGV[0] ) {
			$userConfig = $ARGV[0];
		}
		else {
			print STDERR "ERROR: Config file '".$ARGV[0]."' is not readable\n";
			exit 1;
		}
	}
	elsif( $ARGV[0] ne '-' ) {
		print STDERR "Usage: $0 [user config file] [file to configure]\n";
		exit 1;
	}
}
if( ! defined $userConfig ) {
	my $host = hostname();
	my $user = getpwuid($<);
	$userConfig = "$configDir/$user\@$host.cfg";
}

if( defined $ARGV[1] ) {
	$fileToConfigure = $ARGV[1];
	if ( not -r "$fileToConfigure.in" ) {
		print STDERR "$fileToConfigure.in is not readable\n";
		exit 1;
	}
}

if( not -r $defaultConfig ) {
	print STDERR "Cannot open default config file '$defaultConfig'\n";
	exit 1;
}
elsif( not -r $userConfig ) {
	print STDERR "Cannot open user config file '$userConfig'\n";
	exit 1;
}
elsif( not -r $configurableFilesList ) {
	print STDERR "Cannot open configurable files list $configurableFilesList\n";
	exit 1;
}

my %configVars;

print "Reading '$defaultConfig'\n";
%configVars = &readConfigVars(\%configVars, $defaultConfig);
print "Reading '$userConfig'\n";
%configVars = &readConfigVars(\%configVars, $userConfig);
print "Getting config values:\n\n";
%configVars = &replaceConfigValues(\%configVars);

print "\nConfiguring...\n\n";
if( $fileToConfigure ) {
	&configureFile(\%configVars, $fileToConfigure);
}
else {
	&configureFiles(\%configVars, $configurableFilesList);
}

exit 0;

##
# Read a list of files to be configured, configure each in turn
##
sub configureFiles {
	my $configVarsRef = shift;
	my $configurableFilesList = shift;

	open CONFIGURABLE_FILES, "<$configurableFilesList" 
			or die "Cannot open $configurableFilesList for reading: $!";
	
	while (my $configurableFile = <CONFIGURABLE_FILES>) {
		$configurableFile =~ s/\r?\n$//;
		if ($configurableFile !~ /^\s*$/ and $configurableFile !~ /^\s*#/) {
			if ( -r "$configurableFile.in") {
				&configureFile($configVarsRef, $configurableFile);
			}
			else {
				print STDERR "WARNING: Cannot read configurable file "
						."$configurableFile.in\n";
				exit;
			}
		}
	}
	close CONFIGURABLE_FILES;
}

##
# Read the contents of a configurable file, replace the configurable items and
# write out the replacement
##
sub configureFile {
	my $configVarsRef = shift;
	my $fileName = shift;
	if ( -r "$fileName.in" ) {
		open CONFIGURABLE_FILE, "<$fileName.in" 
				or die "Cannot open $fileName.in for reading: $!";
		open CONFIGURED_FILE, ">$fileName" 
				or die "Cannot open $fileName for writing: $!";

		print "Generating $fileName from $fileName.in...\n";
		while (my $line = <CONFIGURABLE_FILE>) {
			$line = &replaceConfigItems($configVarsRef, $line);
			print CONFIGURED_FILE $line;
		}
		close CONFIGURABLE_FILE;
		close CONFIGURED_FILE;
		
		my @stat = stat "$fileName.in";
		my $mode = $stat[2];
		chmod $mode, $fileName or warn "Couldn't chmod $fileName";
	}
	else {
		print STDERR "WARNING: Cannot read configurable file $fileName.in";
		exit;
	}
}

##
# Replace all config items with their configured config values in a given 
# piece of data
##
sub replaceConfigItems {
	my $configVarsRef = shift;
	my $data = shift;
	while (my ($configItem, $configValue) = each (%{$configVarsRef})) {
		$data =~ s/\@\@$configItem\@\@/$configValue/g;
	}
	return $data;
}

##
# Read the configuration items contained in a given config file and store 
# them in a hash ref
##
sub readConfigVars {
	my $configVarsRef = shift;
	my $fileName = shift;
	open CONFIG_FILE, "<$fileName" or die "Couldn't open config file '$fileName' for reading: $!";
	while( my $configLine = <CONFIG_FILE> ) {
		$configLine =~ s/\r?\n$//;
		if( $configLine !~ /^\s*$/ and $configLine !~ /^\s*#/ ) {
			if( $configLine =~ /(\@?[a-zA-Z0-9_]+)\s+([^\s].*)?$/ ) {
				my $configItemName = $1;
				my $configItemValue = $2;
				if( $configItemName =~ /^\@include/ ) {
					my $i = 0;
					while( defined $$configVarsRef{$configItemName} ) {
						$configItemName = "\@include_".$i++;
					}
				}
				if( not defined $configItemValue ) {
					$configItemValue = "";
				}
				$$configVarsRef{$configItemName} = $configItemValue;
			}
			else {
				print STDERR "WARNING: Unrecognised line in $fileName ignored:\n$configLine\n";
				exit;
			}
		}
	}
	
	close CONFIG_FILE;
	return %{$configVarsRef};
}

##
# Replaces any config items that are referred to in the config item values.
##

sub replaceConfigValues {
	my $configVarsRef = shift;
	
	my @configItemNames = keys %$configVarsRef;
	@configItemNames = sort @configItemNames;
	foreach my $configItemName (@configItemNames) {
		my $configItemValue = $$configVarsRef{$configItemName};
		$$configVarsRef{$configItemName} = &replaceConfigItems($configVarsRef, $configItemValue);
		if( $configItemName =~ /^\@include/ ) {
			print "\tIncluding ".$$configVarsRef{$configItemName}."\n";
			%configVars = &readConfigVars(\%configVars, $$configVarsRef{$configItemName});
		}
		elsif( $$configVarsRef{$configItemName} =~ /^\`(.*)\`$/ ) {
			my $execStr = $1;
			print "\tRunning '$execStr'\n";
			my $value = `$execStr`;
			chop($value);
			$$configVarsRef{$configItemName} = $value;
			print "\tSetting $configItemName = '$value'\n";
		}
		else {
			print "\tSetting $configItemName = '".$$configVarsRef{$configItemName}."'\n";
		}
	}
	
	return %{$configVarsRef};
}

# $Id: configure.pl,v 1.2 2005/04/04 02:26:55 simonwade Exp $
# vim:noai:cindent:cinkeys=0{,0},0),\:,!^F,o,O,e:cino=:ts=2:sw=2:noexpandtab

