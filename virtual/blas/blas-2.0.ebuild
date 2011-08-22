# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Virtual for FORTRAN 77 BLAS implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RDEPEND="|| (
		>=sci-libs/blas-reference-3.3
		>=dev-cpp/eigen-3.0.1-r1
		>=sci-libs/atlas-3.8.4[fortran]
		sci-libs/openblas
		>=sci-libs/acml-4.4
		>=sci-libs/gotoblas2-1.13
		>=sci-libs/mkl-10.3
	)
	doc? ( >=app-doc/blas-docs-3.2 )"
DEPEND=""
