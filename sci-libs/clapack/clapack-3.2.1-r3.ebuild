# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/clapack/clapack-3.2.1-r2.ebuild,v 1.1 2010/04/25 09:40:16 jlec Exp $

EAPI="3"

inherit eutils multilib toolchain-funcs versionator cmake-utils

DESCRIPTION="f2c'ed version of LAPACK"
HOMEPAGE="http://www.netlib.org/clapack/"
SRC_URI="http://www.netlib.org/${PN}/${P}-CMAKE.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libf2c-20081126[static-libs]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/clapack-${PV}-CMAKE

src_prepare() {
	epatch "${FILESDIR}"/${P}-noblasf2c.patch

	sed \
		-e 's:"f2c.h":<f2c.h>:g' \
		-i SRC/*.c || die
}

src_configure() {
	mycmakeargs=( $(cmake-utils_use_enable test TESTS) )
	cmake-utils_src_configure
}
