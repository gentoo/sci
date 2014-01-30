# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 java-ant-2

[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="The Apollo genome editor is a Java-based application for browsing and annotating genomic sequences."
HOMEPAGE="http://gmod.org/wiki/Apollo"
if [ "$PV" == "9999" ]; then
	#SRC_URI="http://gmod.svn.sourceforge.net/viewvc/gmod/apollo/?view=tar" # Apollo_unix.sh
	ESVN_REPO_URI="https://gmod.svn.sourceforge.net/svnroot/gmod/apollo/trunk"
	#KEYWORDS="~amd64 ~x86"
else
	SRC_URI="http://apollo.berkeleybop.org/current/installers/Apollo_unix.sh"
	#KEYWORDS="~amd64 ~x86"
fi

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="dev-vcs/subversion
		>=virtual/jdk-1.5
		>=dev-java/sun-jdk-1.5
		dev-java/ant-core
		dev-lang/perl"
RDEPEND=">=virtual/jre-1.5
		${DEPEND}"

src_unpack() {
	subversion_src_unpack || die
}

src_compile() {
	cd src/java || die
	ant compile || die
}

src_install() {
	java-pkg_dojar jars/apollo.jar || die

	echo "PATH=/opt/Apollo" > 99Apollo
	doenvd 99Apollo || die
}
