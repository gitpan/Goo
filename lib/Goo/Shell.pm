# -*- Mode: cperl; mode: folding; -*-

package Goo::Shell;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo::Shell.pm
# Description:  Create a GooShell The Goo>
#
# Date          Change
# -----------------------------------------------------------------------------
# 23/08/2005    Auto generated file
# 23/08/2005    Wanted to do filename completion for "Things"
# 23/08/2005    Added method: X
# 23/08/2005    Deleted method: X
#
###############################################################################

use strict;

use Goo;
use Goo::Prompter;
use Goo::TypeManager;


###############################################################################
#
# do - run the shell in an interactive loop
#
###############################################################################

sub do {

    Goo::Prompter::say();
    Goo::Prompter::yell("Welcome to The Goo");
    Goo::Prompter::say();

    while (1) {

        my $command = Goo::Prompter::prompt("The Goo");

        my ($arg1, $arg2) = split(/\s+/, $command);

        next unless ($arg1);

        exit if ($arg1 =~ /exit|bye|quit/i);

        if ($arg1 =~ /(z|zone)/i) {

            # show the current working zone
            system("perl -I$ENV{GOOBASE}/shared/bin $ENV{GOOBASE}/bin/goo.pl p tail.trail");

        } elsif (Goo::TypeManager::is_valid_thing($arg2)) {

            system("perl -I$ENV{GOOBASE}/bin $ENV{GOOBASE}/bin/goo.pl $arg1 $arg2");

        } else {

            # shell command - do it!
            system("$command");

        }

    }

}


1;


__END__

=head1 NAME

Goo::Shell - Create a GooShell The Goo>

=head1 SYNOPSIS

use Goo::Shell;

=head1 DESCRIPTION



=head1 METHODS

=over

=item do

run the shell in an interactive loop


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

