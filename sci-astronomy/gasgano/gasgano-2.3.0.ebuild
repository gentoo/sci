# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit java-pkg-2

PDOC=VLT-PRO-ESO-19000-1932-V4

DESCRIPTION="ESO astronomical data file organizer"
HOMEPAGE="http://www.eso.org/sci/data-processing/software/gasgano/"
SRC_URI="ftp://ftp.eso.org/pub/dfs/${PN}/${P}.tar.gz
	doc? ( ${HOMEPAGE}/${PDOC}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6
	dev-java/gnu-regexp
	dev-java/junit
	dev-java/jal"

src_prepare() {
	sed -i \
		-e 's:BASE.*=.*:BASE=/usr/share/gasgano:' \
		bin/gasgano || die
}

src_install() {
	dobin bin/* ||  die
	java-pkg_dojar share/*.jar
	insinto /usr/share/${PN}/config
	doins -r config/*.rul || die
	make_desktop_entry gasgano "Gasgano FITS Organizer"
	if use doc; then
		insinto /usr/share/doc/${PF}
		newins "${DISTDIR}"/${PDOC}.pdf user-manual.pdf
	fi
}
