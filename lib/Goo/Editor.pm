package Goo::Editor;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo::Editor.pm
# Description:  Edit a program interactively as fast as possible
#
# Date          Change
# -----------------------------------------------------------------------------
# 23/06/2005    Version 1
# 01/08/2005    Simplified due to new architecture
#
###############################################################################

use strict;

use Goo::Object;
use Goo::TextEditor;
use Goo::ThereDocManager;

use base qw(Goo::Object);


###############################################################################
#
# run - execute
#
###############################################################################

sub run {

    my ($this, $thing, $line_number) = @_;

    # sometimes we need to make an intelligent jump
    # maybe this will be handled by the JumpManager
    # in the future - in the shortterm this provides
    # some magic
    # need to provide a line number here
    # so we can jump directly
    Goo::TextEditor::edit($thing->get_full_path(), $line_number);

    # analyse for ThereDocs > > >
    my ($theredoc_line_number, $target_thing, $target_action, $target_line_number) =
        Goo::ThereDocManager->new()->process($thing->get_full_path());

    if ($target_thing) {
        $target_thing->do_action($target_action, $target_line_number);
    }

}

1;


__END__

=head1 NAME

Goo::Editor - Edit a program interactively as fast as possible

=head1 SYNOPSIS

use Goo::Editor;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

execute


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

