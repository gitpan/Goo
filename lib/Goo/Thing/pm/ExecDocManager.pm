# -*- Mode: cperl; mode: folding; -*-

package Goo::Thing::pm::ExecDocManager;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo::Thing::pm::ExecDocManager.pm
# Description:  Process ThereDocs embedded in Things
#
# Date          Change
# -----------------------------------------------------------------------------
# 16/08/2005    Auto generated file
# 16/08/2005    Needed a way to jump from Here to There
#
###############################################################################

use strict;

use Goo::Prompter;
use Goo::FileUtilities;

# an execdoc is a small snippet of code you want to execute on it's own
# in the current program
my $exec_doc_start 	= qr/!!>/;    # execute code here 
my $exec_doc_end 	= qr/<!!/;


###############################################################################
#
# process - given a string, look for there_docs and then do things if you find one!
#
###############################################################################

sub process {

    my ($thing) = @_;

    # get the contents afresh
    my $contents = Goo::FileUtilities::getFileAsString($thing->get_full_path());

    # bail out if no ThereDoc is present
    return unless ($contents =~ /$exec_doc_start/);

    # match the string the ThereDoc is targetting
    $contents =~ /$exec_doc_start(.*)$exec_doc_end/ms;

    my $target = $1;

    eval($1);

    if ($@) {
        Goo::Prompter::notify("Error occurred: $@");
    }

    Goo::Prompter::notify("Execute code complete.");

    # go back to editing
    $thing->do_action("J", $exec_doc_start);

}

1;


__END__

=head1 NAME

Goo::Thing::pm::ExecDocManager - Process ThereDocs embedded in Things

=head1 SYNOPSIS

use Goo::Thing::pm::ExecDocManager;

=head1 DESCRIPTION



=head1 METHODS

=over

=item process

given a string, look for there_docs and then do things if you find one!


=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

