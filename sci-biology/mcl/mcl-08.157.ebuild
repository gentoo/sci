# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="A Markov Cluster Algorithm implementation"
HOMEPAGE="http://micans.org/mcl/"
SRC_URI="http://micans.org/mcl/src/mcl-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="+blast"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	econf $(use_enable blast) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
