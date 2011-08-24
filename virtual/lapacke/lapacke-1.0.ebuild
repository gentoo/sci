# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Virtual for LAPACK C implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""
RDEPEND="|| (
		>=sci-libs/lapacke-reference-1.0
		>=sci-libs/mkl-10.3
	)"
DEPEND=""
