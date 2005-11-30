package Goo::TrailGoBackOne;

###############################################################################
# Nigel Hamilton
#
# Copyright Nigel Hamilton 2005
# All Rights Reserved
#
# Author:       Nigel Hamilton
# Filename:     Goo::TrailGoBackOne.pm
# Description:  Jump backwards in the Goo Trail
#
# Date          Change
# -----------------------------------------------------------------------------
# 21/08/2005    Deleted method: generateProfile
# 21/08/2005    Deleted method: showProfile
# 21/08/2005    Deleted method: getGooTrailTable
#
###############################################################################

use strict;

use Goo::Object;
use Goo::TrailManager;
use base qw(Goo::Object);


###############################################################################
#
# run - go back!!
#
###############################################################################

sub run {

    my ($this, $thing) = @_;

	my $new_thing = Goo::TrailManager::go_back_one();

	# go back!
	$new_thing->do_action("B");

}

1;


__END__

=head1 NAME

Goo::TrailGoBackOne - Jump backwards in the Goo Trail

=head1 SYNOPSIS

use Goo::TrailGoBackOne;

=head1 DESCRIPTION



=head1 METHODS

=over

=item run

go back!!


=back

=head1 AUTHOR

Nigel Hamilton <nigel@turbo10.com>

=head1 SEE ALSO

