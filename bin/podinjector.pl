#!/usr/bin/perl -w
# -*- Mode: cperl; mode: folding; -*-

use strict;
use POSIX qw(O_RDONLY);

my $overwrite = 0;            # overwrite mode flag: default NO

if($ARGV[0] eq '-o') {        # if overwrite mode requested
  $overwrite = 1;             # set flag
  shift @ARGV;                # remove that option from command line
}

my @src = map { [$_,&file2scalar($_,':raw')] } @ARGV;  # read in all given files

&podinject($_) for(@src);     # inject PODs to all read in files

# {{{ file2scalar                  read file to scalar and return it
#
sub file2scalar {
  my $file  = shift;               # ARG1: Filename
  my $mode  = shift || ':utf8';    # ARG2: binmode (default: utf8) - sometimes :raw
  my $content;                     # The array for the return values
  local $/;                        # needed to slurp whole file regardless of \n

  return '' if (!(-r $file));      # bail out if the file is not readable

  sysopen(FH, $file, O_RDONLY);    # open file in read-only mode
  binmode(FH, $mode);              # assume the file is in UTF-8
  $content = <FH>;                 # slurp in whole file
  close FH;                        # close filehandle

  return \$content;                # return reference to content
}
# }}}
# {{{ write_file                   create/write file (and content)
#
sub write_file {
  my $name    = shift;             # ARG1: get filename (path)
  my $content = shift;             # ARG2: get content (reference)
  my $ret     = 1;                 # return value for successfull(1 = default)/unsuccessfull operation

  if(open DATA, '>:raw', $name) {  # if open filename for writing ok
    print DATA $$content;          # save content
    close DATA;                    # close filehandle
  } else {                         # open was not successfull
    $ret = 0;                      # set flag
  }

  return $ret;                     # indicate success/failure
}
# }}}
# {{{ podinject                    inject POD into source
#
sub podinject {
  my $struct = shift;
  my $pod;
  my $new;

  print "do $$struct[0]: analysis ";
  $pod = &analysis($$struct[1]);
  if(defined $$pod{leavealone}) {
    print "skip (has POD).\n";
    return;
  }

  $new = &inject($$struct[1],$pod);
  &write_file($$struct[0],$new);
  print "done.\n";

}
# }}}
# {{{ analysis                     analyze perl source code
#
sub analysis {
  my $srcref = shift;
  my @lines  = split /\n/, $$srcref;
  my %pod;        # hash to hold the information necessary to create POD

  for(@lines) {                              # iterate the source
    if(/^package ([\w:]+);/ &&               # package matched: store its name
       !defined $pod{raw}) {                 # and we didn't have it already
      $pod{raw} = $1;                        # store raw package name
    } elsif(/^# Description:\s+(.*)$/ &&     # description matched: store it
	    !defined $pod{desc}) {           # and we didn't have it already
      $pod{desc} = $1;                       # store description
    } elsif(/^# ([a-zA-Z0-9_]+) - (.*)$/) {  # match subroutine/method description
      push @{$pod{sub}}, [$1,$2];

    } elsif(/^=head1/) {                     # there's some POD
      if($overwrite) {                       # if overwrite was requested
	$overwrite=2;                        # there will be work
      } else {                               # no overwrite requested
	$pod{leavealone} = 1;                # set flag to leave this package alone
      }
    }
  }

  return \%pod;
}
# }}}
# {{{ inject                       inject the pod
#
sub inject {
  my $srcref  = shift;             # ARG1: reference to the perl sourcecode
  my $pod     = shift;             # ARG2: reference to hash containing POD-info
  my $methods = "=over\n\n";       # string to keep methods description

  if($overwrite == 2) {                 # We shall overwrite and really have something to do
    $$srcref =~ s/__END__(.*)$//s;     # truncate source since __END__
  }

  for my $elem (@{$$pod{sub}}) {             # iterate all subs/methods
    my $name = $$elem[0];                    # get method name
    my $desc = $$elem[1];                    # get method description
    $methods .= "=item $name\n\n$desc\n\n";  # deploy POD code
  }

  $$srcref .= << "PODTPL";

__END__

=head1 NAME

$$pod{raw} - $$pod{desc}

=head1 SYNOPSIS

use $$pod{raw};

=head1 DESCRIPTION



=head1 METHODS

$methods
=back

=head1 AUTHOR

Nigel Hamilton <nigel\@turbo10.com>

=head1 SEE ALSO

PODTPL

  return $srcref;
}
# }}}

__END__
