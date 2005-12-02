#!/usr/bin/perl
# -*- Mode: cperl; mode: folding; -*-

##############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton + Sven Baum
# Filename:     buglist.pl
# Description:  Show a list of bugs
#
# Date          Change
# -----------------------------------------------------------------------------
# 24/10/2005    Version 1
#
###############################################################################

use strict;

use lib "$ENV{GOOBASE}/shared/bin";
#use lib '/home/search/trexy/bin';
use CGIScript;
use GooDatabase;
use TabHeaderWidget;

my $cgi     = CGIScript->new();
my $company = $cgi->{company} || "trexy";

my $list = getList($company);

print <<HTML;
Content-type: text/html

<html>
<head>
<style type="text/css">body,td,a,p,.h{font-family:verdana, arial; font-size: 8pt;}
A:hover{color:#330066;}
.atb{font-size:9pt; color: white; font-weight:bold; backround-color: #3EAA54;}
</style>
</head>
<body>
<center>
$list
</center>
</body>
</html>
HTML


###############################################################################
#
# getList - return a list of bugs
#
###############################################################################

sub getList {

    my ($company) = @_;

    $company = lc($company);

    my $query = GooDatabase::executeSQL(<<EOSQL);

		select 		*
		from		bug
		where		company	= "$company"
		order by 	status  asc, 
					importance 	desc, 
					foundon desc

EOSQL

    # limit 200
    my $other_company;
    if ($company eq "trexy") {
        $other_company = "turbo10";
    } else {
        $other_company = "trexy";
    }

    my $bgcolor = bgcolor($other_company);

    my $thw = TabHeaderWidget->new();
    $thw->addTab("Trexy Tasks", "window.location='./tasklist.pl?company=trexy'");
    $thw->addTab("Turbo10 Tasks", "window.location='./tasklist.pl?company=turbo10'");

    if ($cgi->{company} eq "trexy") {
        $thw->addTab("Trexy Bugs", "", "#3EAA54");
    } else {
        $thw->addTab("Trexy Bugs", "window.location='./buglist.pl?company=trexy'");
    }

    if ($cgi->{company} eq "turbo10") {
        $thw->addTab("Turbo10 Bugs", "", "#330066");
    } else {
        $thw->addTab("Turbo10 Bugs", "window.location='./buglist.pl?company=turbo10'");
    }

    $thw->addTab("Add New Bug", "window.location='./editbug.pl?company=$company'");

    my $tabs = $thw->getContents();

    my $list = <<TABLE;
	$tabs
    <table>
    <tr>
         <td height=30 width=70 align="center" style="font-style:normal; font-size:small; font-weight=bold;">Importance</td>
         <td height=30 width=70 align="center" style="font-style:normal; font-size:small; font-weight=bold;">Status</td>
         <td height=30 width=350 align="center" style="font-style:normal; font-size:small; font-weight=bold;">Bug</td>
         <td height=30 width=90 align="center"  style="font-style:normal; font-size:small; font-weight=bold;">Found by</td>
         <td height=30 width=70 align="center"  style="font-style:normal; font-size:small; font-weight=bold;">Found Date</td>
         <td height=30 width=90 align="center"  style="font-style:normal; font-size:small; font-weight=bold;">Fixed by</td>
	 <td height=30 width=70 align="center"  style="font-style:normal; font-size:small; font-weight=bold;">Fixed Date</td>
	 <td height=30 width=60 align="right" style="font-style:normal; font-size:small; font-weight=bold;">BugID</td>
    </tr>
TABLE

    while (my $row = GooDatabase::getResultHash($query)) {
        my $datefound = conv_date($row->{foundon});
        my $datefixed = conv_date($row->{fixedon});
        my $style     = style($row->{status});
        my $link      = style_link($row->{status});
        $list .= <<ROW;

	<tr>
		<td align="center" $style>$row->{importance}</td>
		<td align="center" $style>$row->{status}</td>
		<td align="left"><a href="./editbug.pl?company=$company&bugid=$row->{bugid}" $link>$row->{title}</a></td>
		<td align="center" $style>$row->{foundby}</td>
		<td align="center" $style>$datefound</td>
		<td align="center" $style>$row->{fixedby}</td>
                <td align="center" $style>$datefixed</td>
		<td align="right" $style>$row->{bugid}</td>
	</tr>
ROW

    }

    return $list .= "</table>";
}

sub conv_date {
    my $date = shift;
    $date =~ s/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d:\d\d:\d\d)/$3-$2-$1/;
    return $date;
}

sub style {
    my $state = shift;
    my $color;
    if ($state eq "killed") {
        $color = 'style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
                         font-size: 10pt;
                         font-style: normal;
                         font-variant: normal;
                         font-weight: normal;
                         color: #AFAFAF;"';
    } else {
        $color = 'style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
                         font-size: 10pt;
                         font-style: normal;
                         font-variant: normal;
                         font-weight: normal;
                         color: #000000;"';
    }
    return $color;
}

sub style_link {
    my $state = shift;
    my $color;
    if ($state eq "killed") {
        $color = 'style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
                         font-size: 10pt;
                         font-style: normal;
                         font-variant: normal;
                         font-weight: normal;
                         color: #AAABFF;"';
    } else {
        $color = 'style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
                         font-size: 10pt;
                         font-style: normal;
                         font-variant: normal;
                         font-weight: normal;
                         color: #0002FB;"';
    }
    return $color;
}

sub bgcolor {
    my $highlight = shift;
    my $color;
    if ($highlight eq $cgi->{company}) {
        $color =
            'bgcolor="#FFFFBB" align="center" style="color:#153AA4; border: 1px solid #153AA4"';
    } else {
        $color =
            'bgcolor="#FFC891" align="center" style="color:#153AA4; font-weight: bold; border: 1px solid #153AA4"';
    }
}



__END__

=head1 NAME

buglist.pl - Show a list of bugs

=head1 SYNOPSIS

buglist.pl

=head1 DESCRIPTION

=head1 METHODS

=over

=item getList

return a list of bugs

=back

=head1 AUTHOR

Nigel Hamilton <nigel@trexy.com>

=head1 SEE ALSO

