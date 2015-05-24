# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit alternatives-2

DESCRIPTION="AA"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
"

S="${WORKDIR}"

src_install() {
	cat > aa <<- EOF
	#!/bin/bash
	echo "aa"
	EOF

	dobin aa

	alternatives_for alternatives-2 aa 0 /usr/bin/alternatives aa
}
