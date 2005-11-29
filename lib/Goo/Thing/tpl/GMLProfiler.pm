# -*- Mode: cperl; mode: folding; -*-

package GMLProfiler;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:     Nigel Hamilton
# Filename:    GMLProfiler.pm
# Description:     Profile an GML Thing
#
# Date         Change
# -----------------------------------------------------------------------------
# 27/06/2005    Auto generated file
# 27/06/2005    Needed to see a get a snapshot of a Thing
#
###############################################################################

use strict;

use lib $ENV{GOOBASE};

use GML;
use Object;
use Prompter;
use Goo::Prompter;
use Data::Dumper;

use base qw (Object);


###############################################################################
#
# run - display a profile of an xml thing
#
###############################################################################

sub run {

    my ($this, $thing) = @_;

    # can only display an existing Thing!
    my $fields = GML::read($thing->get_full_path());

    Goo::Prompter::show_header($thing->{filename});

    Prompter::say($fields->{title} . "\t\t" . $fields->{description});

    Prompter::say();

}


1;


__END__

=head1 NAME

GMLProfiler - Profile an GML Thing

=head1 SYNOPSIS

use GMLProfiler;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

display a profile of an xml thing


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

