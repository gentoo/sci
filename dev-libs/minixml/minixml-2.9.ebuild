# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A lightweight ANSI C XML library"
HOMEPAGE="http://www.msweet.org/projects.php?Z3"
SRC_URI="http://www.msweet.org/files/project3/mxml-${PV}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}/mxml-${PV}"

src_install() {
	emake install DSTROOT="${D}"
	dodoc README ANNOUNCEMENT CHANGES
}
