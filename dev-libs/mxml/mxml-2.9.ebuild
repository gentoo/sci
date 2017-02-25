# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Mini-XML: A lightweight ANSI C XML library"
HOMEPAGE="http://www.msweet.org/projects.php?Z3"
SRC_URI="http://www.msweet.org/files/project3/${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	emake install DSTROOT="${D}"
	dodoc README ANNOUNCEMENT CHANGES
}
