# -*- Mode: cperl; mode: folding; -*-

package Goo::Thing::pm::ProgramMaker;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:   	Nigel Hamilton
# Filename: 	Goo::Thing::pm::ProgramMaker.pm
# Description:  Auto generate code for all scripts
#
# Date      	Change
# -----------------------------------------------------------------------------
# 07/02/2005    Auto generated file
# 07/02/2005    Needed a superclass
# 08/02/2005    Used the evil map for the first time! and a grep too! and it
#       		didn't feel too bad. ;-)
#
###############################################################################

use strict;

use Goo::Date;
use Goo::Object;
use Goo::Prompter;
use Goo::Template;
use Goo::WebDBLite;
use Goo::Prompter;

use base qw(Goo::Object);

# default to Perl templates - but can be overridden later (e.g., Javascript, Ruby etc)
# page output regions
my $header_template = "perl-header.tpl";
my $main_template   = "perl-main.tpl";
my $method_template = "perl-method.tpl";
my $footer_template = "perl-footer.tpl";
my $master_template = "perl-program.tpl";


###############################################################################
#
# new - set all the values required
#
###############################################################################

sub new {

    my ($class, $params) = @_;

    my $this = $class->SUPER::new();

    # set which templates to use
    $this->set_template("header_template", $header_template);
    $this->set_template("main_template",   $main_template);
    $this->set_template("method_template", $method_template);
    $this->set_template("footer_template", $footer_template);

    return $this;

}


###############################################################################
#
# generate_header - set all the values required in the header of the program
#
###############################################################################

sub generate_header {

    my ($this, $template) = @_;

    # grab the description of the module
    $this->{description} = ucfirst(Goo::Prompter::ask("Enter a description of $this->{name}?"));
    $this->{reason}      = ucfirst(Goo::Prompter::ask("Enter a reason for creating $this->{name}?"));
    $this->{date}        = Goo::Date::get_current_date_with_slashes();
    $this->{year}        = Goo::Date::get_current_year();

    # override the default, if need be
    $template = $template || $header_template;

    $this->{header} .= Goo::Template::replace_tokens_in_string(Goo::WebDBLite::get_template($template), $this);

}


###############################################################################
#
# generate_main - set the main part of the program
#
###############################################################################

sub generate_main {

    my ($this) = @_;

    # what modules does it use?
    my @modules = Goo::Prompter::keep_asking("Enter a module that $this->{name} uses?");

    $this->{modules} = \@modules;

    my @uses;

    # create the uses list in order of module length
    foreach my $module (sort { length($a) <=> length($b) } @{ $this->{modules} }) {
        push(@uses, "use $module;");
    }

    # append so generate can be overridden by subclass
    $this->{main} .= join("\n", @uses);

}


###############################################################################
#
# generate_methods - add methods to the progeam
#
###############################################################################

sub generate_methods {

    my ($this) = @_;

    while (1) {

        my $method = Goo::Prompter::ask("Enter a method for $this->{name}?");

        if ($method eq "") { last; }

        my $description = Goo::Prompter::ask("Enter a description for $method?");

        my @parameters =
            Goo::Prompter::keep_asking("enter a parameter for $method (mandatories first)?");

        # prepend a $ sign if it doesn't have one
        @parameters = map { $_ =~ /\$/ ? $_ : '$' . $_ }
            grep { $_ !~ /this/ } @parameters;

        if ($this->{constructor}) {

            # add this to the parameters - if we have a constructor
            # $this is the first parameter for all OO classes
            unshift(@parameters, '$this');
        }

        $this->{methods} .= $this->generate_method($method, join(', ', @parameters), $description);

    }

}


###############################################################################
#
# generate_method - return a template for a method
#
###############################################################################

sub generate_method {

    my ($this, $method, $signature, $description) = @_;

    my $t = {};

    $method =~ s/\s+//g;    # remove any accidental whitespace

    $t->{method} = $method;

    if ($signature) {
        $t->{signature} = "my ($signature) = \@\_;";
    }

    $t->{description} = $description;

    return Goo::Template::replace_tokens_in_string(Goo::WebDBLite::get_template($method_template), $t);

}


###############################################################################
#
# save - create the program output file
#
###############################################################################

sub save {

    my ($this) = @_;

    my $template = Goo::WebDBLite::get_template($master_template);

    Goo::FileUtilities::write_file($this->{filename},
                             Goo::Template::replace_tokens_in_string($template, $this));

    Goo::Prompter::yell("Program saved: $this->{filename}.");

}


###############################################################################
#
# generate - create the output file
#
###############################################################################

sub generate {

    my ($this) = @_;

    $this->generate_header();
    $this->generate_main();
    $this->generate_methods();
    $this->generate_footer();

    Goo::Prompter::yell("Generated $this->{name}.");

    if (Goo::Prompter::confirm("Save the $this->{name}?")) {
        $this->save();
    }

}


###############################################################################
#
# get_template - get template to use per output region ("footer", "header") etc.
#
###############################################################################

sub get_template {

    my ($this, $region) = @_;

    return $this->{$region};

}


###############################################################################
#
# set_template - set template to use per output region ("footer", "header") etc.
#
###############################################################################

sub set_template {

    my ($this, $region, $template) = @_;

    $this->{$region} = $template;

}

1;


__END__

=head1 NAME

Goo::Thing::pm::ProgramMaker - Auto generate code for all scripts

=head1 SYNOPSIS

use Goo::Thing::pm::ProgramMaker;

=head1 DESCRIPTION



=head1 METHODS

=over

=item new

set all the values required

=item generate_header

set all the values required in the header of the program

=item generate_main

set the main part of the program

=item generate_methods

add methods to the progeam

=item generate_method

return a template for a method

=item save

create the program output file

=item generate

create the output file

=item get_template

get template to use per output region ("footer", "header") etc.

=item set_template

set template to use per output region ("footer", "header") etc.


=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

