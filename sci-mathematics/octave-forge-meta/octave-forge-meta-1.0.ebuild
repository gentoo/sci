# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Octave forge meta package to pull in all separate octave-forge packages"
LICENSE="GPL-2"
HOMEPAGE="http://octave.sourceforge.net"
SLOT="0"

IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| ( <sci-mathematics/octave-3.2 sci-mathematics/octave-forge-quaternion )
	sci-mathematics/octave-forge-audio
	sci-mathematics/octave-forge-bioinfo
	sci-mathematics/octave-forge-combinatorics
	sci-mathematics/octave-forge-communications
	sci-mathematics/octave-forge-control
	sci-mathematics/octave-forge-data-smoothing
	sci-mathematics/octave-forge-econometrics
	sci-mathematics/octave-forge-financial
	sci-mathematics/octave-forge-fixed
	sci-mathematics/octave-forge-general
	sci-mathematics/octave-forge-gsl
	sci-mathematics/octave-forge-ident
	sci-mathematics/octave-forge-image
	sci-mathematics/octave-forge-informationtheory
	sci-mathematics/octave-forge-io
	sci-mathematics/octave-forge-irsa
	sci-mathematics/octave-forge-linear-algebra
	sci-mathematics/octave-forge-miscellaneous
	sci-mathematics/octave-forge-nnet
	sci-mathematics/octave-forge-octcdf
	sci-mathematics/octave-forge-octgpr
	sci-mathematics/octave-forge-odebvp
	sci-mathematics/octave-forge-odepkg
	sci-mathematics/octave-forge-optim
	sci-mathematics/octave-forge-optiminterp
	sci-mathematics/octave-forge-outliers
	sci-mathematics/octave-forge-parallel
	sci-mathematics/octave-forge-physicalconstants
	sci-mathematics/octave-forge-plot
	sci-mathematics/octave-forge-signal
	sci-mathematics/octave-forge-sockets
	sci-mathematics/octave-forge-specfun
	sci-mathematics/octave-forge-special-matrix
	sci-mathematics/octave-forge-splines
	sci-mathematics/octave-forge-statistics
	sci-mathematics/octave-forge-strings
	sci-mathematics/octave-forge-struct
	sci-mathematics/octave-forge-symbolic
	sci-mathematics/octave-forge-time
	sci-mathematics/octave-forge-video
	!amd64? ( sci-mathematics/octave-forge-vrml )
	sci-mathematics/octave-forge-zenity"
