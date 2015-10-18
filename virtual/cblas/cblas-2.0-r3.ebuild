# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for BLAS C implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="int64"

RDEPEND="
	int64? (
		|| (
			>=sci-libs/openblas-0.2.11[int64,${MULTILIB_USEDEP}]
			>=sci-libs/cblas-reference-20110218-r1[int64,${MULTILIB_USEDEP}]
		)
	)
	|| (
		>=sci-libs/cblas-reference-20110218-r1[int64?,${MULTILIB_USEDEP}]
		>=sci-libs/openblas-0.2.11[int64?,${MULTILIB_USEDEP}]
		>=sci-libs/gsl-1.16-r2[-cblas-external,${MULTILIB_USEDEP}]
		abi_x86_64? ( !abi_x86_32? ( || (
			>=sci-libs/gotoblas2-1.13
			>=sci-libs/atlas-3.9.34
			>=sci-libs/mkl-10.3
		) ) )
	)"
DEPEND=""
