# Copyright 1999-2011 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Gambit: Software Tools for Game Theory"

HOMEPAGE="http://www.gambit-project.org/doc/index.html"

SRC_URI="mirror://sourceforge/gambit/${P}.tar.gz
	"
	#http://econweb.tamu.edu/gambit/doc/${PN}-manual-${PV}.pdf
	#http://econweb.tamu.edu/gambit/doc/${PN}-manual-${PV}.tar.gz

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

#IUSE="wxwindows" 
IUSE="X" 

DEPEND="X? ( >=x11-libs/wxGTK-2.6 
		=x11-libs/gtk+-1.2* )
		"

RDEPEND=""

src_compile() {
	# disable 
	local myconf
	if use amd64
		then
		myconf='--disable-enumpoly'
		fi
	econf "${myconf}" \
		"$(use_enable X gui)" ||die
	emake ||die
}

src_install() {
	emake DESTDIR="${D}" install ||die
	dodoc NEWS README* AUTHORS ChangeLog
}

