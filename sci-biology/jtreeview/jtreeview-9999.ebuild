# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 git-r3

DESCRIPTION="Viewer for Microarray Data in PCL or CDT formats"
HOMEPAGE="http://jtreeview.sourceforge.net
	https://bitbucket.org/TreeView3Dev/treeview3"
EGIT_REPO_URI="https://bitbucket.org/TreeView3Dev/treeview3.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="" # builds and executes fines
IUSE=""

DEPEND=">virtual/jdk-1.7:*"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

src_prepare(){
	chmod u+x ./gradle* || die
	eapply_user
}

src_compile(){
	# work around gradle writing $HOME/.gradle, requiring $HOME/.git and $HOME/.m2/
	# https://github.com/samtools/htsjdk/issues/660#issuecomment-232155965
	# make jure SDK-1.8 is available, JRE-1.8 is not enough
	GRADLE_USER_HOME="${WORKDIR}" ./gradlew || die
}

src_install(){
	cd build/libs || die
	java-pkg_dojar *.jar
	java-pkg_dolauncher ${PN}
}
