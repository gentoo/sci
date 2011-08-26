# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Virtual for Linear Algebra Package FORTRAN 77 (LAPACK) implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

RDEPEND="|| (
		>=sci-libs/lapack-reference-3.3
		>=sci-libs/atlas-3.8.4[lapack]
		>=sci-libs/mkl-10.3
		>=sci-libs/acml-4.4
	)
	doc? ( >=app-doc/lapack-docs-3.2 )"
DEPEND=""
