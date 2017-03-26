# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for LAPACK C implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="int64"

RDEPEND="
	|| (
		abi_x86_64? ( !abi_x86_32? ( >=sci-libs/lapacke-reference-${PV} ) )
		sci-libs/mkl[int64?,${MULTILIB_USEDEP}]
	)
	int64? ( sci-libs/mkl[int64,${MULTILIB_USEDEP}] )
	"
DEPEND=""
