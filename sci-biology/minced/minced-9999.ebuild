# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 java-pkg-2

DESCRIPTION="Short Palindromic Repeat finder tool (for CRISPRs)"
HOMEPAGE="https://github.com/ctSkennerton/minced/tree/master"
EGIT_REPO_URI="https://github.com/ctSkennerton/minced.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

src_compile(){
	default
}

src_install(){
	java-pkg_dojar minced.jar
	java-pkg_dolauncher
	dodoc README
}
