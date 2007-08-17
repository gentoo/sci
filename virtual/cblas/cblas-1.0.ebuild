# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Virtual for Basic Linear Algebra Subprograms C (CBLAS) implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| (
		>=sci-libs/cblas-reference-20030223-r4
		>=sci-libs/blas-atlas-3.7.37
		>=sci-libs/gsl-1.9-r1
		>=sci-libs/mkl-9.1.023
	)"
DEPEND=""
