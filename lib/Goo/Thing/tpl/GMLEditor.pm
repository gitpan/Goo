package GMLEditor; 

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author: 	Nigel Hamilton
# Filename:	GMLEditor.pm
# Description: 	Edit a program interactively as fast as possible
#
# Date	 	Change
# -----------------------------------------------------------------------------
# 23/06/2005	Version 1 
# 01/08/2005	Simplified due to new architecture
#
###############################################################################

use strict;

use Object;
use TextEditor;
use base qw(Object);


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
	TextEditor::edit($thing->get_full_path(), $line_number);

}

1;


__END__

=head1 NAME

GMLEditor - Edit a program interactively as fast as possible

=head1 SYNOPSIS

use GMLEditor;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

execute


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

