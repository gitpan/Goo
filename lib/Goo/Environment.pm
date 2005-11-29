package Goo::Environment;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo::Environment.pm
# Description:  Provide info about the environment the program is running in
#
# Date          Change
# -----------------------------------------------------------------------------
# 07/06/2004    Auto generated file
# 07/06/2004    needed to know the IP address of the current maching
# 02/02/2005    Detect if we are in a CGI environment
# 06/02/2005    Added test to see if this is a cronjob
# 15/08/2005    Added method: getUser
#
###############################################################################

use strict;
use Goo::Object;
use base qw(Goo::Object);


###############################################################################
#
# is_sparky - are we running under sparky?
#
###############################################################################

sub is_sparky {

    return exists($ENV{'SPARKY'});

}


###############################################################################
#
# is_development - are we running on dev.trexy.com?
#
###############################################################################

sub is_development {

    #   return 1;
    # try to avoid a hostname look up here
    return $ENV{'SERVER_NAME'} =~ /localhost/ || $ENV{'DESKTOP_SESSION'} eq 'kde';

}


###############################################################################
#
# is_cgi - is this a cgi script?
#
###############################################################################

sub is_cgi {

    return exists($ENV{'GATEWAY_INTERFACE'});

}


###############################################################################
#
# is_cronjob - is this running as a cronjob?
#
###############################################################################

sub is_cronjob {

    return exists($ENV{'TERM'});

}


###############################################################################
#
# is_command_line - is this running on command line?
#
###############################################################################

sub is_command_line {

    return exists($ENV{'TERM'});

}


###############################################################################
#
# get_ipaddress - which machine is this running on?
#
###############################################################################

sub get_ipaddress {

    my ($this) = @_;

    my $hostname = `hostname -i`;

    $hostname =~ s/\s+//g;

    return $hostname;

}


###############################################################################
#
# get_user - who is using this program?
#
###############################################################################

sub get_user {

    return $ENV{'USER'};

}

1;


__END__

=head1 NAME

Goo::Environment - provide info about the environment the program is running in

=head1 SYNOPSIS

use Goo::Environment;

=head1 DESCRIPTION



=head1 METHODS

=over

=item is_sparky

are we running under sparky?

=item is_development

are we running on dev.trexy.com?

=item is_cgi

is this a cgi script?

=item is_cronjob

is this running as a cronjob?

=item is_command_line

is this running on command line?

=item get_ipaddress

which machine is this running on?

=item get_user

who is using this program?


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

