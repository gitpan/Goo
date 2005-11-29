#!/usr/bin/perl

package Goo::Thing::pm::Perl5ModuleInspector;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2003
# All rights reserved
#
# Author:       Nigel Hamilton
# Filename: 	Perl5ModuleInspector.pm
# Description:  Generate documentation on a perl file based on documentation
#               standards like this file as an example
#
# Date          Change
# ----------------------------------------------------------------------------
# 22/3/2003     Version 1
#
##############################################################################

use strict;
use Goo::Object;
use Goo::FileUtilities;

# use ModuleLocations;

our @ISA = ("Goo::Object");


##############################################################################
#
# new - constructor
#
##############################################################################

sub new {

    my ($class, $filename) = @_;

    my $this = $class->SUPER::new();

    # append filename to the end if need be
    # if ($filename !~ /\.pm$/) { $filename .= ".pm"; }

    unless ($filename) { die("No filename to generate documentation."); }

    $this->{filename} = $filename;    # the full filename + path
    $this->{program} = Goo::FileUtilities::get_file_as_string($filename);

    return $this;

}


##############################################################################
#
# get_program - return the fully slurped file
#
##############################################################################

sub get_program {

    my ($this) = @_;

    return $this->{program};

}


##############################################################################
#
# get_uses_list - return a list of all the modules that this script uses
#
##############################################################################

sub get_uses_list {

    my ($this) = @_;

    my @modules = $this->{program} =~ m/^use\s+([\w\:]+)/mg;

    # don't include strict or other pragmas
    return grep { $_ !~ /(strict|^[a-z])/ } @modules;

}


##############################################################################
#
# get_method_description - return this description of a method
#
##############################################################################

sub get_method_description {

    my ($this, $method) = @_;

    $this->{program} =~ m/\#\s+$method(.*?)sub/si;

    my $description = $1;

    return "" unless ($description);

    $description =~ s/\#/ /g;
    $description =~ s/\-/ /g;
    $description =~ s/[\n\r]+/ /g;
    $description =~ s/\s+/ /g;

    return $description;

}


##############################################################################
#
# get_template_list - return a list of templates, forms, emails, pages, subforms
#
##############################################################################

sub get_template_list {

    my ($this) = @_;

    my @templates = ();

    my @suffixes = ('.frm', '.tpl', '.page', '.email');

    foreach my $suffix (@suffixes) {
        while ($this->{program} =~ m/['"](\w+$suffix)["']/gi) {

            # print "pushing $1 onto list \n";
            push(@templates, $1);
        }
    }

    # print join('return ing this ----', @templates);
    return @templates;

}


##############################################################################
#
# get_methods - return a list of methods in the script
#
##############################################################################

sub get_methods {

    my ($this) = @_;

    my @methods = $this->{program} =~ m/sub\s+(\w+)/mgi;

    # add a main method
    unshift(@methods, "main");

    return @methods;

}


##############################################################################
#
# get_method_signature - return a signature for a method
#
##############################################################################

sub get_method_signature {

    my ($this, $method) = @_;

    # hard wire a description for the special main method
    return "Main body" if ($method eq "main");

    return $this->{signatures}->{$method};

}


##############################################################################
#
# calculate_method_signatures - return a hash of method signatures
#                keyed on method name
#
##############################################################################

sub calculate_method_signatures {

    my ($this) = @_;

    $this->{signatures} = {};

    # there is always a main method
    $this->{signatures}->{main} = "use strict";

    foreach my $method ($this->get_methods()) {

        # match the method and signature
        $this->{program} =~ m/sub\s+$method\s+\{\s+my\s+\((.*?)\)/is;
        $this->{signatures}->{$method} = $1;

    }

}


##############################################################################
#
# get_full_path - return the full path
#
##############################################################################

sub get_full_path {

    my ($this) = @_;

    return $this->{filename};

}


##############################################################################
#
# get_filename - return the filename
#
##############################################################################

sub get_filename {

    my ($this) = @_;

    $this->{filename} =~ m|.*/(.*?)$|;

    return $1;

}


##############################################################################
#
# get_description - get the module description
#
##############################################################################

sub get_description {

    my ($this) = @_;

    $this->{program} =~ m/Description:\s+(.*?)\# (Date|Version)/s;

    my $description = $1;

    # strip comments
    $description =~ s/\#/ /g;

    # strip whitespace
    $description =~ s/\s+/ /g;

    return $description;

}


##############################################################################
#
# has_constructor - does the program have a constructor?
#
##############################################################################

sub has_constructor {

    my ($this) = @_;

    my @constructor = grep { $_ eq "new" } $this->get_methods();

    return scalar(@constructor) == 1;

}


##############################################################################
#
# get_matching_line_number - return the number of the line that matches
#
##############################################################################

sub get_matching_line_number {

    my ($this, $regex) = @_;

    my @lines = split(/\n/, $this->{program});

    my $linecount = 0;

    foreach my $line (@lines) {

        $linecount++;

        if ($line =~ /$regex/) {

            # add 5 to get into the body of the method
            return $linecount + 5;
        }

    }

}


##############################################################################
#
# get_author - return the name of the author
#
##############################################################################

sub get_author {

    my ($this) = @_;

    $this->{program} =~ m/Author:\s+(\w+)\s+(\w+)/;

    return $1 . " " . $2;

}


1;


__END__

=head1 NAME

Goo::Thing::pm::Perl5ModuleInspector - Generate documentation on a perl file based on documentation

=head1 SYNOPSIS

use Goo::Thing::pm::Perl5ModuleInspector;

=head1 DESCRIPTION



=head1 METHODS

=over

=item new

constructor

=item get_program

return the fully slurped file

=item get_uses_list

return a list of all the modules that this script uses

=item get_method_description

return this description of a method

=item get_template_list

return a list of templates, forms, emails, pages, subforms

=item get_methods

return a list of methods in the script

=item get_method_signature

return a signature for a method

=item calculate_method_signatures

return a hash of method signatures

=item get_full_path

return the full path

=item get_filename

return the filename

=item get_description

get the module description

=item has_constructor

does the program have a constructor?

=item get_matching_line_number

return the number of the line that matches

=item get_author

return the name of the author


=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

