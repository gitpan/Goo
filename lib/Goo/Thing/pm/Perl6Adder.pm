#!/usr/bin/perl
# -*- Mode: cperl; mode: folding; -*-

package Goo::Thing::pm::Perl6Adder;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:  	 	Nigel Hamilton
# Filename: 	Perl6Adder.pm
# Description:  Add stuff to a program
#
# Date      	Change
# ----------------------------------------------------------------------------
# 01/08/05  	Factored out of ProgramEditor as part of the new Goo
# 09/08/2005    This is the first change that has been automatically added.
# 09/08/2005    Added the function that enables me to added changes like this. We
#               also need to test the line wrapping. Does it do a good job of
#               retaining the columns?
# 09/08/2005    I really like the way it handles automated dates - cool!
#
##############################################################################

use strict;

use lib $ENV{GOOBASE};

use Goo::Object;
use Goo::Prompter;
use Goo::Thing::pm::PerlCoder;
use Goo::Thing::pm::MethodMaker;
	
use base qw(Goo::Object);


###############################################################################
#
# run - keep adding a thing to the program
#
###############################################################################

sub run {

    my ($this, $thing, $option) = @_;

	Goo::Prompter::notify("Perl6Adder not implemented yet.");

}


1;


__END__

=head1 NAME

Goo::Thing::pm::Perl6Adder - Add stuff to a program

=head1 SYNOPSIS

use Goo::Thing::pm::Perl6Adder;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

keep adding a thing to the program


=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

