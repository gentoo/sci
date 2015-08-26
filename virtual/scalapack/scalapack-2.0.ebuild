# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for ScaLAPACK implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"
RDEPEND="|| (
		>=sci-libs/scalapack-${PV}
		>=sci-libs/mkl-10.3
	)
	doc? ( >=app-doc/scalapack-docs-2.0 )"
DEPEND=""
