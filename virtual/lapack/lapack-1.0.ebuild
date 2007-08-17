# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 (LAPACK) implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| (
		>=sci-libs/lapack-reference-3.1.1-r1
		>=sci-libs/lapack-atlas-3.7.37
		>=sci-libs/mkl-9.1.023
		>=sci-libs/acml-3.6.1-r1
		=sci-libs/acml-3.6.0-r1
	)"
DEPEND=""
