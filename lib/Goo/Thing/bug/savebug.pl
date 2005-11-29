#!/usr/bin/perl

##############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton + Dr Sven Baum
# Filename:     editbug.pl
# Description:  Add a new bug to the goo database
#
# Date          Change
# -----------------------------------------------------------------------------
# 24/10/2005    Version 1
#
###############################################################################

use strict;

use lib '/home/search/shared/bin';

use CGIScript;
use GooEmailer;
use GooDatabase;
#use Goo::TeamManager;
use CGI::Carp('fatalsToBrowser');

my $cgi   = CGIScript->new();
my $bugid = $cgi->{bugid};
my $title = $cgi->{title};

addBugToDatabase($cgi);

# send the email alert!!!
# $taskid = addTaskToDatabase($cgi);
if ($cgi->{importance} > 9) {

    # keep us update about important tasks
    GooEmailer::sendEmail("goo\@turbo10.com",
                          "nigel\@turbo10.com, sven\@turbo10.com",
                          "Important Task: $cgi->{title} [$cgi->{bugid}]",
                          $cgi->{description});

}

# do a redirect back to the list
print "Location: ./buglist.pl?company=$cgi->{company}\n\n";


###############################################################################
#
# addBugToDatabase - return a select list with something selected
#
###############################################################################

sub addBugToDatabase {

    my ($cgi) = @_;

    my $query = GooDatabase::prepareSQL(<<EOSQL);

    replace into bug  ( bugid,
						title,
                        			description,
                      				status,

						foundon,
						foundby,
						fixedby,

						fixedon,
			                        importance,
                       				company)
   			 values            (?, ?, ?, ?, 
						?, ?, ?, 
						?, ?, ?)

EOSQL

    GooDatabase::bindParam($query, 1, $cgi->{bugid});
    GooDatabase::bindParam($query, 2, $cgi->{title});
    GooDatabase::bindParam($query, 3, $cgi->{description});
    GooDatabase::bindParam($query, 4, $cgi->{status});

    # if we don't have a date this must be the first time
    GooDatabase::bindParam($query, 5, $cgi->{foundon} || GooDatabase::getDate());
    GooDatabase::bindParam($query, 6, $cgi->{foundby});
    GooDatabase::bindParam($query, 7, $cgi->{fixedby});

    # record the fixed on date is somebody has fixed it
    my $fixedon = "";

    if (($cgi->{status} eq "killed") && ($cgi->{fixedby} ne "nobody")) {
        StaffManager::sendEmail("Burt the Bug Buster <burt\@turbo10.com>",
                                "$cgi->{finishedby} finished: $cgi->{title} [$cgi->{bugid}]",
                                $cgi->{description});
        $fixedon = GooDatabase::getDate();
    }

    GooDatabase::bindParam($query, 8,  $fixedon);
    GooDatabase::bindParam($query, 9,  $cgi->{importance});
    GooDatabase::bindParam($query, 10, $cgi->{company});

    # what is the pain associated with this bug???
    GooDatabase::execute($query);
}



__END__

=head1 NAME

savebug.pl - Add a new bug to the goo database

=head1 SYNOPSIS

savebug.pl

=head1 DESCRIPTION

=head1 METHODS

=over

=item addBugToDatabase

return a select list with something selected

=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

