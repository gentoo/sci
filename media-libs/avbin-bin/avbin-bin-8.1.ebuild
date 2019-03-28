# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A thin wrapper around FFmpeg"
HOMEPAGE="http://avbin.github.io/"
SRC_URI="
	amd64? ( mirror://github/AVbin/AVbin/avbin-linux-x86-64-v${PV}.tar.bz2 )
	x86? ( mirror://github/AVbin/AVbin/avbin-linux-x86-32-v${PV}.tar.bz2 )"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

pkg_setup(){
	if [ "${ABI}" == "amd64" ]; then
		S="${WORKDIR}"/avbin-linux-x86-64-v${PV}
	elif [ "${ABI}" == "x86" ]; then
		S="${WORKDIR}"/avbin-linux-x86-32-v${PV}
	fi
}

src_install() {
	ln -s libavbin.so.${PV} libavbin.so || die
	dolib.so libavbin.so*
}
