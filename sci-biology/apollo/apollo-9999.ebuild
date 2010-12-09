# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="The Apollo genome editor is a Java-based application for browsing and annotating genomic sequences."
HOMEPAGE="http://gmod.org/wiki/Apollo"
if [ "$PV" == "9999" ]; then
	#SRC_URI="http://gmod.svn.sourceforge.net/viewvc/gmod/apollo/?view=tar" # Apollo_unix.sh
	ESVN_REPO_URI="https://gmod.svn.sourceforge.net/svnroot/gmod/apollo/trunk"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI="http://apollo.berkeleybop.org/current/installers/Apollo_unix.sh"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-vcs/subversion
		>=dev-java/sun-jdk-1.5
		dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack || die
}

src_compile() {
	cd src/java || die
	ant compile || die
}

src_install() {
	java-pkg_dojar jars/apollo.jar || die
}
