# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Stringent short-read aligner supporting filters and various output formats"
HOMEPAGE="https://github.com/magnusmanske/snpomatic"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/magnusmanske/snpomatic.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/magnusmanske/snpomatic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e 's/^CXX=/#CXX=/;s/^CXXFLAGS=/#CXXFLAGS=/' -i Makefile || die
}

src_install(){
	dobin findknownsnps
	dodoc doc/Manual.doc
}
