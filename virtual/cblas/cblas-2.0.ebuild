# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Virtual for BLAS C implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="|| (
		>=sci-libs/cblas-reference-20110218
		sci-libs/openblas
		>=sci-libs/gsl-1.15-r3[-cblas-external]
		>=sci-libs/gotoblas2-1.13
		>=sci-libs/atlas-3.9.34
		>=sci-libs/mkl-10.3
	)"
DEPEND=""
