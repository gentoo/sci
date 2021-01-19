# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Paired-end mates merge from fragments"
HOMEPAGE="https://sourceforge.net/projects/flashpage/"
SRC_URI="https://downloads.sourceforge.net/project/flashpage/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

src_install(){
	dobin flash
	dodoc NEWS README
}
