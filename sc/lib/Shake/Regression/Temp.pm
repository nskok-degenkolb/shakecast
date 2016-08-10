package Regression::Temp;

# Put temporary or test regressions here.
# Currently: HazusPGV regression.
#
# V 2.0 5-27-2003 vq
# New format for amplitudes functions: 
#  <hash> = $obj->maximum($lat,$lon[,$dist][,$type]);
#  <hash> = $obj->random($lat,$lon[,$dist][,$type]);

# Module to generate PGA/PGV/SA for a given a distance and magnitude.
# Regression from Boore, Joyner, and Fumal, 1997, SRL, Vol. 68, p. 128.
# V1.0 1-8-00 djw
# as module 5-31-00 cws
# Change to HAZUS PGV equation 12-23-01 vq 
#
# Regression from Boore, Joyner and Fumal, 1997, SRL, Volume 68, p. 128.
# with the form: 
#
#        ln (PGA,PSV) = B1 + B2(M-6) + B3(M-6)**2 - B5*ln(R) - Bv*ln(Vs/Va),
#
#	 where R = sqrt(Rjb**2 + h**2)
#
# PGV is computed from 1-Hz PSA using Newmark-Hall 1982 equation as used in HAZUS.
# Distance is JB definition (Rjb, see SRl V68, No. 1, p10.)

# NOTE that the routines in this module scale the values to return %g instead
# of g, and scale up the values by 15% to estimate a maximum value rather than
# a random component (Boore, Campbell, personal communication)
#
# vq 072302 Fault type dependence

use strict;
use Shake::Regression::Common_reg;
use Shake::Source;
use Shake::Distance;
use vars qw( $Vs $SCALE_PEAK %CONSTANTS %SIGMA );
use Carp;

$Vs=724.; # BC NEHRP

# multiply by 1.15 to get maximum rather than random 
# component as derived (Boore, Campbell, personal communication)
$SCALE_PEAK = 1.15;

# Strike-slip coefficients
$CONSTANTS{SS} = 
  {'pga'   => { B1 => -0.313, B2 =>  0.527, B3 =>  0.000, 
		B5 => -0.778, Bv => -0.371, Va =>  1396, 
		h  =>  5.57 },
   'psa03' => { B1 =>  0.598, B2 =>  0.769, B3 => -0.161, 
		B5 => -0.893, Bv => -0.401, Va =>  2133, 
		h  =>  5.94 },
   'psa10' => { B1 => -1.133, B2 =>  1.036, B3 => -0.032, 
		B5 => -0.798, Bv => -0.698, Va =>  1406, 
		h  =>  2.90 },
   # using 2.0 sec coefficients for SA 3.0 sec
   'psa30' => { B1 => -1.699, B2 =>  1.085, B3 => -0.085, 
		B5 => -0.812, Bv => -0.655, Va =>  1795, 
		h  =>  5.85 },
  };

# Thrust-slip coefficients
$CONSTANTS{RS} = 
  {'pga'   => { B1 => -0.117, B2 =>  0.527, B3 =>  0.000, 
		B5 => -0.778, Bv => -0.371, Va =>  1396, 
		h  =>  5.57 },
   'psa03' => { B1 =>  0.803, B2 =>  0.769, B3 => -0.161, 
		B5 => -0.893, Bv => -0.401, Va =>  2133, 
		h  =>  5.94 },
   'psa10' => { B1 => -1.009, B2 =>  1.036, B3 => -0.032, 
		B5 => -0.798, Bv => -0.698, Va =>  1406, 
		h  =>  2.90 },
   # using 2.0 sec coefficients for SA 3.0 sec
   'psa30' => { B1 => -1.801, B2 =>  1.085, B3 => -0.085, 
		B5 => -0.812, Bv => -0.655, Va =>  1795, 
		h  =>  5.85 },
  };

# Default coefficients
$CONSTANTS{ALL} = 
  {'pga'   => { B1 => -0.242, B2 =>  0.527, B3 =>  0.000, 
		B5 => -0.778, Bv => -0.371, Va =>  1396, 
		h  =>  5.57 },
   'psa03' => { B1 =>  0.700, B2 =>  0.769, B3 => -0.161, 
		B5 => -0.893, Bv => -0.401, Va =>  2133, 
		h  =>  5.94 },
   'psa10' => { B1 => -1.080, B2 =>  1.036, B3 => -0.032, 
		B5 => -0.798, Bv => -0.698, Va =>  1406, 
		h  =>  2.90 },
   # using 2.0 sec coefficients for SA 3.0 sec
   'psa30' => { B1 => -1.743, B2 =>  1.085, B3 => -0.085, 
		B5 => -0.812, Bv => -0.655, Va =>  1795, 
		h  =>  5.85 },
  };

# standard deviation values
# Note, the standard deviation values are defined in log-amplitude 
# space, so when applied in liner-amplitude space they are
# multiplicative rather than additive factors.
%SIGMA = ('pga'   => 0.520,
	  'pgv'   => 0.558, # sigma_pgv computed from sigma_psa10
	  'psa03' => 0.522,
	  'psa10' => 0.613,
	  'psa30' => 0.672,
	 );

sub new {
  my $class = shift;
  my $lat   = shift;
  my $lon   = shift;
  my $mag   = shift;
  my $source_type;
  
  # ignore the magnitude min, max range if passed as arguments
  
  my $self = { lat=>$lat, lon=>$lon, mag =>$mag };

  # If there is a fault model specified, extract it.
  foreach (@_) { 
    $self->{fault} = $_ if (ref $_ eq 'ARRAY');
    $source_type = $_->type if (ref $_ eq 'Source');
  }
  
  if (!defined $source_type) {
    print "Regression: No source mechanism specified. Using default.\n";
  }
  elsif ($source_type =~ /SS|RS|ALL/i) {
    print "Regression: Source mechanism: $source_type.\n";
  }
  else {
    print "Regression: Unknown source mechanism '$source_type'. Using default.\n";
  }
  $source_type = 'ALL' unless (defined $source_type);
  $self->{type} = $source_type;

  $self->{ bias } = { pga   => 1,
		      pgv   => 1,
		      psa03 => 1,
		      psa10 => 1,
		      psa30 => 1 };
  
  bless $self, $class;
}


# Complete suite of "maximum component" amplitude values at the given 
# lat, lon location (magnitude and source coordinates were loaded when the 
# regression object was created). Values returned as a hash with keys of:
#   pga, pgv, psa03, psa10, psa30
### Multiply by $SCALE_PEAK to get maximum rather than random 
### component as derived (Boore, Campbell, personal communication)
sub maximum {
  my ($this,$lat,$lon,$dist,$type) = @_;

  if ($dist =~ /^pga|pgv|acc|vel|psa/) {
    $type = $dist;
    $dist = undef;
  }

  my $Rjb = (defined $dist) ? $dist : dist_rjb($lat,$lon,$this);

  my $M = $this->{'mag'};
  my(%hash);
  
  my $source_type = $this->{type} ;
  my $cons = $CONSTANTS{$source_type};

  #-----------------------------------------------------------------------
  # For PGA, SA 0.3 sec, SA 1.0 sec, SA 3.0 sec (using 2.0 sec coefficients) 
  # scale "g" to %g
  #-----------------------------------------------------------------------
  if (not defined $type or $type eq 'pga') {
    $hash{pga}   = _psa_formula($M,$Rjb,%{$cons->{'pga'}}) * 
      100 * $SCALE_PEAK;
  } 
  if (not defined $type or $type eq 'psa03') {
    $hash{psa03} = _psa_formula($M,$Rjb,%{$cons->{'psa03'}}) * 
      100 * $SCALE_PEAK;
  } 
  if (not defined $type or $type eq 'psa10' or $type eq 'pgv') {
    $hash{psa10} = _psa_formula($M,$Rjb,%{$cons->{'psa10'}}) * 
      100 * $SCALE_PEAK unless ($hash{psa10});
    $hash{pgv}   = $hash{psa10} * 37.27*2.54/100;
  }
  if (not defined $type or $type eq 'psa30') {
    $hash{psa30} = _psa_formula($M,$Rjb,%{$cons->{'psa30'}}) * 
                   100 * $SCALE_PEAK;
  } 
  return(%hash);
}

# Complete suite of "random component" amplitude values at the given lat, 
# lon location (magnitude and source coordinates were loaded when the 
# regression object was created). Values returned as a hash with keys of:
#   pga, pgv, psa03, psa10, psa30
### These are values for some random component rather than the maximum,
### therefore they do *not* have the $SCALE_PEAK multiplicative factor
### (Boore, Campbell, personal communication)
sub random {
  my ($this,$lat,$lon,$dist,$type) = @_;

  if ($dist =~ /^pga|pgv|acc|vel|psa/) {
    $type = $dist;
    $dist = undef;
  }

  my $Rjb = (defined $dist) ? $dist : dist_rjb($lat,$lon,$this);

  my $M   = $this->{'mag'};
  my(%hash);

  my $source_type = $this->{type} ;
  my $cons;

  $source_type = 'ALL' unless ($source_type);
  $cons = $CONSTANTS{$source_type};
  
  #-----------------------------------------------------------------------
  # For PGA, SA 0.3 sec, SA 1.0 sec, SA 3.0 sec (using 2.0 sec coefficients) 
  # scale "g" to %g
  #-----------------------------------------------------------------------
  if (not defined $type or $type eq 'pga') {
    $hash{pga}   = _psa_formula($M,$Rjb,%{$cons->{'pga'}}) * 100;
  } 
  if (not defined $type or $type eq 'psa03') {
    $hash{psa03} = _psa_formula($M,$Rjb,%{$cons->{'psa03'}}) * 100;
  } 
  if (not defined $type or $type eq 'psa10' or $type eq 'pgv') {
    $hash{psa10} = _psa_formula($M,$Rjb,%{$cons->{'psa10'}}) * 100 
      unless ($hash{psa10});
    $hash{pgv}   = $hash{psa10} * 37.27*2.54/100;
  } 
  if (not defined $type or $type eq 'psa30') {
    $hash{psa30} = _psa_formula($M,$Rjb,%{$cons->{'psa30'}}) * 100;
  }
  return(%hash);
}

# Complete suite of standard deviation for the parameters given by peak().
# Values returned as a hash with the same keys as returned by peak().
sub sd {
  my $this  = shift;

  my(%hash,$key);

  %hash = ();
  foreach $key (keys %SIGMA) {
    if (not defined $SIGMA{$key}) {
      $hash{$key} = undef;
      next;
    }

    if ($key eq 'pgv') {
      $hash{$key} = 10**($SIGMA{$key});
    }
    else {
      $hash{$key} = exp($SIGMA{$key});
    }
  }

  return %hash;
}

# Get/Store a set of values for the bias of the regression relative to
# to the data. $bias is a reference to a hash with keys of
#   pga, pgv, psa03, psa10, psa30
# and values of the bias amount for each parameter type.
sub bias {
  my $this = shift;

  if (@_) {
    my $bias = shift;
    
    if (ref $bias ne "HASH") {
      return;
    }

    $this->{bias} = $bias;
  }

  $this->{bias};
}

##################################################################
# Subroutines intended for internal use. Not part of external API
##################################################################

sub _psa_formula {
  my $M   = shift;
  my $Rjb = shift;
  my %c   = @_;
  my($R,$psa);

  $R = sqrt($Rjb**2 + $c{h}**2);
  $psa = exp($c{B1} + $c{B2}*($M-6.) + $c{B3}*($M-6.)**2 + $c{B5}*log($R) +
	     $c{Bv}*log($Vs/$c{Va}));

  return $psa;
}

1;
