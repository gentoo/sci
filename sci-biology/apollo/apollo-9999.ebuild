# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2 subversion

DESCRIPTION="Apollo genome editor"
HOMEPAGE="http://gmod.org/wiki/Apollo"
ESVN_REPO_URI="https://gmod.svn.sourceforge.net/svnroot/gmod/apollo/trunk"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS=""

RDEPEND="
	>=virtual/jre-1.5:*
	dev-lang/perl
	"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5:*
	dev-java/ant-core
	"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	cd src/java || die
	ant compile || die
}

src_install() {
	java-pkg_dojar jars/apollo.jar

	echo "PATH=/opt/Apollo" > 99Apollo
	doenvd 99Apollo
}
