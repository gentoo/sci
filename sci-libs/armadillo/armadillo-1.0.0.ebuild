# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit cmake-utils

DESCRIPTION="C++ linear algebra library (matrix maths) aiming towards a good balance between speed and ease of use"
HOMEPAGE="http://arma.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/arma/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack blas boost"

DEPEND="dev-util/cmake
	>=sys-devel/gcc-4.0.0
	lapack? ( virtual/lapack )
	blas? ( virtual/blas )
	boost? ( >=dev-libs/boost-1.34 )"
