# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A thin wrapper around FFmpeg"
HOMEPAGE="http://code.google.com/p/avbin/"
SRC_URI="amd64? ( http://avbin.googlecode.com/files/avbin-linux-x86-64-${PV}.tar.gz )
	x86? ( http://avbin.googlecode.com/files/avbin-linux-x86-32-${PV}.tar.gz )"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	if use amd64; then
		cd "${WORKDIR}"/avbin-linux-x86-64-${PV}
	elif use x86; then
		cd "${WORKDIR}"/avbin-linux-x86-32-${PV}
	fi

	ln -s libavbin.so.${PV} libavbin.so
	dolib libavbin.so*
}
