#!/usr/bin/perl

package Goo::Thing::pm::GoLiveCommand;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author: 		Nigel Hamilton
# Filename:		GoLiveCommand.pm
# Description: 	Send a file Live!
#
# Date	 		Change
# ----------------------------------------------------------------------------
# 27/05/02		Version 1 - used for debugging
#               Added Clone method - needed for mod_perl persistent environment
# 24/07/04      DataDumper was hanging around - removed in case of RAM consumption
# 01/08/05		Factored out of ProgramEditor as part of the new Goo
#
##############################################################################

use strict;
use Goo::Object;
use Goo::Prompter;

use base qw(Goo::Object);


###############################################################################
#
# run - send module(s) live
#
###############################################################################

sub run { 
	
	my ($this, $thing) = @_; 
	
	my $golive_command = $GOLIVE; 

	# what commands do you use to send a file live: rsync, ftp, svn?
	# here it the place to put them!	
	# Goo::Prompter::confirm("Publish $this->{filename} to production?"); 

} 

1;


__END__

=head1 NAME

Goo::Thing::pm::GoLiveCommand - Send a file Live!

=head1 SYNOPSIS

use Goo::Thing::pm::GoLiveCommand;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

send module(s) live


=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

