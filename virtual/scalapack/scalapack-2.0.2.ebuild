# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for ScaLAPACK implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc int64"

RDEPEND="
	|| (
		>=sci-libs/scalapack-${PV}
		sci-libs/mkl[int64?,${MULTILIB_USEDEP}]
	)
	int64? ( sci-libs/mkl[int64,${MULTILIB_USEDEP}] )
	doc? ( >=app-doc/scalapack-docs-2.0 )"
DEPEND=""
