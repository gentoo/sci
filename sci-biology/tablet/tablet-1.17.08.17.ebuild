# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit java-pkg-2 java-ant-2 python-r1

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="Viewer of next generation sequence assemblies and alignments"
HOMEPAGE="https://ics.hutton.ac.uk/tablet"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/cropgeeks/tablet.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/cropgeeks/tablet/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=""
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=virtual/jdk-1.8:*"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.8:*
	>=dev-java/commons-compress-1.4.1"
# contains bundled sqlite-jdbc-3.8.6.jar, samtools-linux64.jar, htsjdk-2.11.0.jar
# sqlite-jdbc-3.8.6.jar is not dev-db/sqlite:3 and samtools-linux64.jar is not sci-biology/samtools either

S="${WORKDIR}"

src_install() {
	java-pkg_dojar lib/tablet.jar
	java-pkg_dolauncher ${PN}
	java-pkg_dojar lib/tablet-resources.jar
	java-pkg_dojar lib/flamingo.jar
	java-pkg_dojar lib/scri-commons.jar
	java-pkg_dojar lib/samtools*.jar
	java-pkg_dojar lib/htsjdk*.jar # is htsjdk-2.11.0 in tablet-1.17.08.17
	java-pkg_dojar lib/sqlite-jdbc*.jar

	echo "PATH=${EPREFIX}/opt/Tablet" > 99Tablet
	doenvd 99Tablet
}
