# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="Stringent short-read aligner supporting filters and various output formats"
HOMEPAGE="https://github.com/magnusmanske/snpomatic"
# http://snpomatic.sourceforge.net/snpomatic_manual.pdf
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/magnusmanske/snpomatic.git"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's/^CXX=/#CXX=/;s/^CXXFLAGS=/#CXXFLAGS=/' -i Makefile || die
}

src_install(){
	dobin findknownsnps
	dodoc doc/Manual.doc
}
