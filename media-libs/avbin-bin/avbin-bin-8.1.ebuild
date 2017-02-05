# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A thin wrapper around FFmpeg"
HOMEPAGE="http://avbin.github.io/"
SRC_URI="
	amd64? ( mirror://github/AVbin/AVbin/avbin-linux-x86-64-v${PV}.tar.bz2 )
	x86? ( mirror://github/AVbin/AVbin/avbin-linux-x86-32-v${PV}.tar.bz2 )"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

pkg_setup(){
	if use amd64; then
		S="${WORKDIR}"/avbin-linux-x86-64-v${PV}
	elif use x86; then
		S="${WORKDIR}"/avbin-linux-x86-32-v${PV}
	fi
}
src_install() {
	ln -s libavbin.so.${PV} libavbin.so || die
	dolib libavbin.so*
}
