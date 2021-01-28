# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PV="${PV//./-}"
MY_P="${PN}${MY_PV}"

DESCRIPTION="An interactive, extensible software system for experimenting with matroids"
HOMEPAGE="https://sites.google.com/site/wwwmatroids/"
SRC_URI="
	https://sites.google.com/site/wwwmatroids/${MY_P}.tar.gz -> ${P}.tar.gz
	https://sites.google.com/site/wwwmatroids/${PN}UserManual${MY_PV}.pdf
"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=virtual/jdk-1.4:*"
RDEPEND=">=virtual/jre-1.4:*"

# The source uses 'enum' as an identifier, therefore:
JAVA_PKG_WANT_SOURCE="1.4"
S="${WORKDIR}"

src_prepare () {
	mkdir classes || die

	# change path names
	sed -i -e 's:NAME = ":NAME = "/usr/share/Oid/:' MatroidToolkit.java || die

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
	dodoc "${DISTDIR}"/OidUserManual4-0.pdf

	insinto /usr/share/Oid
	doins matroid*.txt
}
