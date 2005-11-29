#!/usr/bin/perl

package Goo::Exiter;

############################################################################### 
# Nigel Hamilton - exit from a script
#									    
# Copyright Nigel Hamilton 2005
# All Rights Reserved						    
#								    
# Author: 		Nigel Hamilton					 
# Filename:		Goo::Exiter.pm
# Description: 	Exit from The Goo
#
# 
# Date 			Change		 
# -----------------------------------------------------------------------------
# 06/07/2005	Version 1
#
###############################################################################

use Goo::Object;
use Goo::Prompter;

our @ISA = qw(Goo::Object);


############################################################################### 
#
# run - exit from the goo
#								    
############################################################################### 

sub run {
	
	Goo::Prompter::say("");

	# pretty simple - let's exit!
	exit;

}

1;







__END__

=head1 NAME

Goo::Exiter - Exit from The Goo

=head1 SYNOPSIS

use Goo::Exiter;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

exit from the goo


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

