# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

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
		abi_x86_64? ( !abi_x86_32? ( >=sci-libs/lapacke-reference-3.5 ) )
		sci-libs/mkl[int64?,${MULTILIB_USEDEP}]
	)
	int64? ( sci-libs/mkl[int64,${MULTILIB_USEDEP}] )
	"
DEPEND=""
