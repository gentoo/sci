# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for BLAS C implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="int64"

RDEPEND="
	|| (
		>=sci-libs/cblas-reference-20110218-r1[int64?,${MULTILIB_USEDEP}]
		>=sci-libs/openblas-0.2.11[int64?,${MULTILIB_USEDEP}]
		>=sci-libs/gsl-1.16-r2[-cblas-external,${MULTILIB_USEDEP}]
		>=sci-libs/gotoblas2-1.13[int64?,${MULTILIB_USEDEP}]
		sci-libs/mkl[int64?,${MULTILIB_USEDEP}]
		abi_x86_64? ( !abi_x86_32? ( >=sci-libs/atlas-3.9.34 ) )
	)
	int64? (
		|| (
			>=sci-libs/openblas-0.2.11[int64,${MULTILIB_USEDEP}]
			>=sci-libs/cblas-reference-20110218-r1[int64,${MULTILIB_USEDEP}]
			>=sci-libs/gotoblas2-1.13[int64,${MULTILIB_USEDEP}]
			sci-libs/mkl[int64,${MULTILIB_USEDEP}]
		)
	)"
DEPEND=""
