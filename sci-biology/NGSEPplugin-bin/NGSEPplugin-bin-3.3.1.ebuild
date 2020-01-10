# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="NGSEP with Eclipse Plugin (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home
	https://github.com/NGSEP/NGSEPplugin"
SRC_URI="https://sourceforge.net/projects/ngsep/files/OnlyPlugin/NGSEPplugin_3.3.1.201903140636.jar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.7:*
	sci-biology/NGSEPcore-bin"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}"

src_install(){
	java-pkg_dojar "${DISTDIR}"/*.jar
}
