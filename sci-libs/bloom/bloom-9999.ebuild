# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="C++ Bloom Filter Library"
HOMEPAGE="https://code.google.com/p/bloom"
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://bloom.googlecode.com/svn/trunk"
else
	SRC_URI=""
fi

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#-c++#$(tc-getCC)#;s#-O3#${CXXFLAGS}#" -i Makefile || die
	sed -e "s#-pedantic-errors -ansi -Wall -Wextra -Werror -Wno-long-long##" -i Makefile || die
}
