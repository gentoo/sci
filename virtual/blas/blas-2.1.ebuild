# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Virtual for FORTRAN 77 BLAS implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"
RDEPEND="|| (
		>=sci-libs/blas-reference-20110417
		>=dev-cpp/eigen-3.1.2
		sci-libs/atlas[fortran]
		sci-libs/openblas
		>=sci-libs/acml-4.4
		sci-libs/gotoblas2
		>=sci-libs/mkl-10.3
	)
	doc? ( >=app-doc/blas-docs-3.2 )"
DEPEND=""
