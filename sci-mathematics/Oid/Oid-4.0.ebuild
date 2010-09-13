# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 versionator

MY_PV=$(replace_version_separator 1 '-')
MY_P="${PN}${MY_PV}"

DESCRIPTION="An interactive, extensible software system for experimenting with matroids"
SRC_URI="http://sites.google.com/site/wwwmatroids/${MY_P}.tar.gz
	doc? ( http://sites.google.com/site/wwwmatroids/${PN}UserManual${MY_PV}.pdf )"
HOMEPAGE="http://sites.google.com/site/wwwmatroids/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

# The source uses 'enum' as an identifier, therefore:
JAVA_PKG_WANT_SOURCE="1.4"

src_prepare () {
	mkdir classes

# change path names
	sed -i -e 's:NAME = ":NAME = "/usr/share/Oid/:' MatroidToolkit.java
}

src_compile () {
	ejavac -d classes @Oid/filelist.unix
	ejavac -d classes @filelist
}

src_install () {
	jar cef Oid Oid.jar -C classes . || die "Failed to create jar"

	java-pkg_dojar Oid.jar
	java-pkg_dolauncher

	use doc && dodoc "${DISTDIR}"/OidUserManual4-0.pdf

	insinto /usr/share/Oid
	doins matroid*.txt
}
