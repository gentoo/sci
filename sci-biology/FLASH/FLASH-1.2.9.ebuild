# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Merge paired-end mates from fragments that are shorter than twice the read length "
HOMEPAGE="http://sourceforge.net/projects/flashpage"
SRC_URI="http://downloads.sourceforge.net/project/flashpage/FLASH-1.2.9.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	dobin flash
	dodoc NEWS README
}
