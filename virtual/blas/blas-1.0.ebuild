# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Virtual for Basic Linear Algebra Subprograms FORTRAN 77 (BLAS) implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
RDEPEND="|| (
		sci-libs/blas-reference
		sci-libs/blas-atlas
		sci-libs/blas-goto
		sci-libs/mkl
		sci-libs/acml
	)"
DEPEND=""
