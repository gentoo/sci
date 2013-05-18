# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A lightweight ANSI C XML library"

HOMEPAGE="http://www.minixml.org/"

SRC_URI="http://ftp.easysw.com/pub/mxml/${PV}/mxml-${PV}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/mxml-${PV}

src_install() {
	emake install DSTROOT=${D}
	dodoc README ANNOUNCEMENT CHANGES COPYING
}
