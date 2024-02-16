# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PV="${PV//./-}"
MY_P="${PN}${MY_PV}"

DESCRIPTION="An interactive, extensible software system for experimenting with matroids"
HOMEPAGE="http://userhome.brooklyn.cuny.edu/skingan/matroids/software.html"
SRC_URI="
	http://userhome.brooklyn.cuny.edu/skingan/matroids/${MY_P}.tar.gz -> ${P}.tar.gz
	http://userhome.brooklyn.cuny.edu/skingan/matroids/${PN}UserManual${MY_PV}.pdf
"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=virtual/jdk-1.7:*"
RDEPEND=">=virtual/jre-1.7:*"

# The source uses 'enum' as an identifier, therefore:
JAVA_PKG_WANT_SOURCE="1.7"
JAVA_PKG_WANT_TARGET="1.7"
S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-bezier.patch"
)

src_prepare () {
	mkdir classes || die

	# change path names
	sed -i -e 's:NAME = ":NAME = "/usr/share/Oid/:' MatroidToolkit.java || die
	# replace all enum, since after 1.4 java it is a keywords
	sed -i -e 's:enum:enum_as_a_key_is_no_longer_allowed:g' \
		Oid/PGFactory.java  \
		DisplayGeom.java \
		VisRank3ModularCuts.java || die

	default
}

src_compile () {
	ejavac -d classes @Oid/filelist.unix
	ejavac -d classes @filelist
}

src_install () {
	jar cef Oid Oid.jar -C classes . || die "Failed to create jar"

	java-pkg_dojar Oid.jar
	java-pkg_dolauncher
	dodoc "${DISTDIR}"/${PN}UserManual${MY_PV}.pdf

	insinto /usr/share/Oid
	doins matroid*.txt
}
