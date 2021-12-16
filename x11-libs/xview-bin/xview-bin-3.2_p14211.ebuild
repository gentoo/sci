# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

RPMVER="3.2p1.4-21.1"

DESCRIPTION="The X Window-System-based Visual/Integrated Environment - binary package"
HOMEPAGE="https://archive.physionet.org/physiotools/xview/"
SRC_URI="https://archive.physionet.org/physiotools/xview/i386-Fedora/xview-${RPMVER}.fc8.i386.rpm"

LICENSE="XVIEW"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

QA_PREBUILT="*"

src_install() {
	dolib.so usr/*/lib/*.so.*
}
