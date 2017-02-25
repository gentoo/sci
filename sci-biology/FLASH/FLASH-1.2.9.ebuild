# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Paired-end mates merge from fragments"
HOMEPAGE="http://sourceforge.net/projects/flashpage"
SRC_URI="http://downloads.sourceforge.net/project/flashpage/FLASH-1.2.9.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install(){
	dobin flash
	dodoc NEWS README
}
