# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit java-pkg-2 java-ant-2 python-r1

# [ "$PV" == "9999" ] && inherit subversion
inherit subversion

DESCRIPTION="Viewer of next generation sequence assemblies and alignments"
HOMEPAGE="http://bioinf.scri.ac.uk/tablet/"
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="http://ics.hutton.ac.uk/svn/tablet/trunk/"
	KEYWORDS=""
else
	ESVN_REPO_URI="http://ics.hutton.ac.uk/svn/tablet/tags/${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Tablet"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=virtual/jdk-1.8:*"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.8:*"
# contains bundled sqlite-jdbc-3.8.6.jar, samtools-linux64.jar, picard.jar
# sqlite-jdbc-3.8.6.jar is not dev-db/sqlite:3 and samtools-linux64.jar is not sci-biology/samtools either
# replacing picard.jar with a symlink to picard.jar from sci-biology.picard does not help either

S="${WORKDIR}"

src_install() {
	java-pkg_dojar lib/tablet.jar
	java-pkg_dolauncher ${PN}
	java-pkg_dojar lib/tablet-resources.jar
	java-pkg_dojar lib/flamingo.jar
	java-pkg_dojar lib/scri-commons.jar
	java-pkg_dojar lib/samtools*.jar
	java-pkg_dojar lib/picard*.jar # is picard-1.113 in tablet-1.16.09.06
	java-pkg_dojar lib/sqlite-jdbc*.jar

	echo "PATH=${EPREFIX}/opt/Tablet" > 99Tablet
	doenvd 99Tablet
}
