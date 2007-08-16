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
		sci-libs/lapack-reference
		sci-libs/lapack-atlas
		sci-libs/mkl
		sci-libs/acml
	)"
DEPEND=""
