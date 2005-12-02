# -*- Mode: cperl; mode: folding; -*-

package GMLMaker;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author: 	Nigel Hamilton
# Filename:	GMLMaker.pm
# Description: 	Auto generate templates
#
# Date	 	Change
# -----------------------------------------------------------------------------
# 02/08/2005	Version 1
#
###############################################################################

use strict;

use Date;
use Object;
use Prompter;
use Template;
use TextEditor;
use Goo::Prompter;

our @ISA = ("Object");


###############################################################################
#
# generate_body_text - set the main part of the program
#
###############################################################################

sub generate_body_text {

	my ($this, $name) = @_;
	
	if (Prompter::confirm("Edit the main <bodytext> for $name?")) {

		# temporarily edit <bodytext> in tmp
		my $temp_file = "/tmp/$name";

		unlink $temp_file;

		TextEditor::edit($temp_file);

		$this->{bodytext} = FileUtilities::get_file_as_string($temp_file);

		unlink $temp_file;

	} 

	
}


###############################################################################
#
# generate_fields - add fields to the template
#
###############################################################################

sub generate_fields {

	my ($this) = @_;

	while (1) {

                my $field = Prompter::ask("Enter a field?");

		last unless $field;
                
		my $value = Prompter::ask("Enter a value for $field?");

		$this->{tags} .= "<$field>$value</$field>\n";

        }
	
}


###############################################################################
#
# save - create the program output file
#
###############################################################################

sub save {

	my ($this, $fullpath, $filename) = @_;
	
	my $template = <<OUT;
<title>{{title}}</title>
<description>{{description}}</description>
<bodytext>{{bodytext}}</bodytext>
{{tags}}
OUT
	FileUtilities::write_file($fullpath,
				 Template::replace_tokens_in_string($template, $this));

	Prompter::yell("$filename saved: $fullpath");
	
}


###############################################################################
#
# run - create the output file
#
###############################################################################

sub run {

	my ($this, $thing) = @_;

	if (-e $thing->{filename}) {
		exit unless Prompter::confirm("The file $thing->{filename} already exists. Continue making?"); 
	}

	Goo::Prompter::show_header($thing);

        $this->{title} 	     = ucfirst(Prompter::ask("Enter a title for $thing->{filename}?"));
        $this->{description} = ucfirst(Prompter::ask("Enter a description of $thing->{filename}?"));

	$this->generate_body_text($thing->{filename});
	$this->generate_fields();
	
	Prompter::yell("Generated $thing->{filename}.");
	
	if (Prompter::confirm("Save $thing->{filename}?")) {
		$this->save($thing->get_full_path(), $thing->{filename});
	}
	
}


1;


__END__

=head1 NAME

GMLMaker - Auto generate templates

=head1 SYNOPSIS

use GMLMaker;

=head1 DESCRIPTION



=head1 METHODS

=over

=item generate_body_text

set the main part of the program

=item generate_fields

add fields to the template

=item save

create the program output file

=item run

create the output file


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

