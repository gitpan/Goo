package Goo;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo.pm
# Description:  Stick Things together with The Goo
#
#               See: http://thegoo.org
#
# Date          Change
# -----------------------------------------------------------------------------
# 27/03/2004    Auto generated file
# 27/03/2004    Reduce work, bugs, documentation, and maintenance
# 29/10/2004    Used filename suffixes to determine what to do - added a lot of
#               the Goo's basic functionality in one go!
# 02/02/2005    Returned to add more functions
# 07/02/2005    Moved dynamic "use" to "require" to stop connecting to the Master
#               DB on startup for faster running
# 10/02/2005    Added a program editor for fast edits and test updates.
#               Added a ProgramCloner and ProgramEditor
# 16/06/2005    Added meta-goo descriptions in /home/search/goo - dramatically
#               simplified the code for this program.
# 01/08/2005    Meta details stored in Config files help to simplify this part
#               of the code even more - this unifies the command-line and [E]dit
#               processing steps.
# 17/10/2005    Added method: loadMaker
# 23/11/2005    Added check_environment() to help with CPAN-friendly install
#
###############################################################################

use strict;

use File::NCopy qw(copy);

use Goo::Object;
use Goo::Loader;
use Goo::Prompter;
use Goo::TrailManager;
use Goo::LiteDatabase;

use base qw(Goo::Object);

our $VERSION = '0.04';


###############################################################################
#
# check_environment - is everything set up OK?
#
###############################################################################

sub check_environment {

    # store the DB in ~/.goo
    my $database_directory = $ENV{HOME} . "/.goo";

    # in the file goo-trail.db
    my $database_file = $database_directory . "/goo-trail.db";

    if (-e $database_file) {

        # establish the connection to the database and bail out
        Goo::LiteDatabase::get_connection($database_file);
        return;
    }

    # no database yet - let's make one
    # check if the ~/.goo directory is present?
    if (!-d $database_directory) {    		# if there is no directory
        if (-e $database_directory) {   	# but a file with the name .goo
            rename $database_directory, "$database_directory.wtf";    # move it
        }

        mkdir $database_directory;      # make the directory

        # so this is our 1st time invocation: copy files from skeletton
        copy(\1, '/usr/lib/Goo/*', $database_directory);
    }

    close DATA if (open DATA, ">>$database_file"); # make the db file ("touch")

    # connect to the database for the first time
    Goo::LiteDatabase::get_connection($database_file);

    # create all the tables
    Goo::TrailManager::create_database();

}


###############################################################################
#
# doAction - edit a template etc
#
###############################################################################

sub do_action {

    my ($this, $action, $filename, @parameters) = @_;

    # special exception for makers - need to remove this later
    if ($action =~ /M/i) {

        $filename = "$ENV{HOME}/.goo/things/goo/$filename";

        if (-e $filename) {
            return
                unless Goo::Prompter::confirm(
                                            "The file $filename already exists. Continue making?",
                                            "N");
        }

        my $maker = Goo::Loader::get_maker($filename);
        $maker->run($filename);

    } else {

        # if the filename exists in the current directory
        my $thing = Goo::Loader::load($filename);

        # can the Thing do the action?
        if ($thing->can_do_action($action)) {

            # print "thing can do $action \n";
            # dynamically call the matching method
            $thing->do_action($action, @parameters);

        } else {

            Goo::Prompter::stop("Goo invalid action $action for this Thing: $filename.");

        }

    }

}


###############################################################################
#
# BEGIN - is everything set up OK?
#
###############################################################################

sub BEGIN {

    # check and set up the environment
    check_environment();

}


1;


__END__

=head1 NAME

Goo - Stick Things together with The Goo

=head1 SYNOPSIS

use Goo;

=head1 DESCRIPTION



=head1 METHODS

=over

=item doAction

edit a template etc


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

