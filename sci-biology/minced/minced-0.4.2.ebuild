# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

DESCRIPTION="Short Palindromic Repeat finder tool (for CRISPRs)"
HOMEPAGE="https://github.com/ctSkennerton/minced"
SRC_URI="https://github.com/ctSkennerton/minced/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

src_install(){
	java-pkg_dojar minced.jar
	java-pkg_dolauncher
	einstalldocs
}
