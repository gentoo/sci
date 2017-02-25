# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit scons-utils

MY_P="FRAMEWAVE_${PV}_SRC"

DESCRIPTION="A collection of popular image and signal processing routines"
HOMEPAGE="http://framewave.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-util/scons"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -e "s#\(-install_name /usr\)/local/lib/\${BITNESS}#\1#" \
		-i BuildTools/buildscripts/fwflags_gcc.py || die "sed failed"
}

src_compile() {
	cd Framewave || die

	local bits="32"
	use amd64 && bits="64"

	escons \
		CCFLAGS="${CFLAGS}" bitness="${bits}" variant="release" \
		libtype="shared" ${MAKEOPTS}|| die "make failed"
}

src_install() {
	local bits="32"
	use amd64 && bits="64"

	dolib.so Framewave/build/bin/release_shared_${bits}/*.so*

	doheader Framewave/build/include/*
}
