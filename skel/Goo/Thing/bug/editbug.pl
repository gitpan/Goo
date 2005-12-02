#!/usr/bin/perl
# -*- Mode: cperl; mode: folding; -*-

##############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton + Sven Baum
# Filename:     editbug.pl
# Description:  Add a new bug to the goo database
#
# Date          Change
# -----------------------------------------------------------------------------
# 24/10/2005    Version 1
#
###############################################################################

use strict;

use lib "$ENV{GOOBASE}/shared/bin";
use CGIScript;
use GooEmailer;
use GooDatabase;
use StaffManager;
use CGI::Carp('fatalsToBrowser');


my $cgi   = CGIScript->new();
my $bugid = $cgi->{bugid};
my $title = $cgi->{title};

print "Content-type: text/html\n\n";
print getForm(GooDatabase::getRow("bug", "bugid", $bugid));


###############################################################################
#
# getForm - return the form to show the bug in detail
#
###############################################################################

sub getForm {

    my ($bug) = @_;

    my $found_by_list = getSelectList("foundby", $bug->{foundby}, qw(nigel megan sven rena));
    my $fixed_by_list =
        getSelectList("fixedby", $bug->{fixedby}, qw(nobody nigel megan sven rena));
    my $company_list    = getSelectList("company",    $bug->{company},    qw(turbo10 trexy));
    my $importance_list = getSelectList("importance", $bug->{importance}, 1 .. 10);
    my $status_list     = getSelectList("status",     $bug->{status},     qw(alive killed));

    my $FormID;
    if ($bug->{bugid}) {
        $FormID = "Form BugID " . $bug->{bugid};
    } else {
        $FormID = "Form to report a new Bug";
    }

    my $form = <<FORM;
	<html>
	<head>
	<title>Edit Bug</title>
	</head>
	<body>
	<form action="./savebug.pl?company=$cgi->{company}" method=GET>
	<input type=hidden name="bugid" value="$bug->{bugid}"><br>
	<input type=hidden name="foundon" value="$bug->{foundon}"><br>
	<input type=hidden name="fixedon" value="$bug->{fixedon}"><br>
	<table border=0 cellpadding=5 cellspacing=5 align="left">
			 <tr>
			 		 <td width="100" align="left"><h4>$FormID</h4></td>
					 <td width="400" align="left"><h4>$bug->{title}</h4></td>
				</tr>
				<tr>
			 		 <td width="100" align="left">Found by</td>
					 <td width="400" align="left">$found_by_list</td>
				</tr>
				<tr>
			 		 <td width="100" align="left">Fixed by</td>
					 <td width="400" align="left">$fixed_by_list</td>
				</tr>
				<tr>
			 		 <td width="100" align="left">Company</td>
					 <td width="400" align="left">$company_list</td>
				</tr>
				<tr>
                                         <td width="100" align="left">Status</td>
                                         <td width="400" align="left">$status_list</td>
                                </tr>
				<tr>
			 		 <td width="100" align="left">Bug Title</td>
					 <td width="400" align="left"><input type=text size=70 name=title value="$bug->{title}"></td>
				</tr>
				<tr>
			 		 <td width="100" align="left">Importance</td>
					 <td width="400" align="left">$importance_list</td>
				</tr>
				<tr>
			 		 <td width="100" align="left" valign="top">Description <br>(why/what/where/how/when?)</td>
					 <td width="400" align="left"><textarea cols=60 rows=17 name="description">$bug->{description}</textarea></td>
				</tr>
				<tr>
			 		 <td width="100" align="left"><a href="buglist.pl?company=$cgi->{company}"><< Go Back</a></td>
					 <td width="400" align="left"><input type="submit" value="Add Bug">&nbsp;</td>
				</tr>
</table>

</form>
</body>
</html>
FORM

    return $form;


}


###############################################################################
#
# getSelectList - return a select list with something selected
#
###############################################################################

sub getSelectList {

    my ($name, $selected_value, @options) = @_;

    my $list = "<select name='$name'>";

    foreach my $option (@options) {

        my $selected = ($option eq $selected_value) ? "selected" : "";

        $list .= "<option value='$option' $selected>$option</option>";

    }

    return $list . "</select>";

}



__END__

=head1 NAME

editbug.pl - Add a new bug to the goo database

=head1 SYNOPSIS

editbug.pl

=head1 DESCRIPTION

=head1 METHODS

=over

=item getForm

return the form to show the bug in detail

=item getSelectList

return a select list with something selected

=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

