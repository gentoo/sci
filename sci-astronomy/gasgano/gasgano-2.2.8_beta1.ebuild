# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils versionator autotools java-pkg-2

MYPV="$(replace_all_version_separators '_')"
MYPV="$(delete_version_separator 3 ${MYPV})"

PDOC=VLT-PRO-ESO-19000-1932-V4

DESCRIPTION="ESO astronomical data file organizer"
HOMEPAGE="http://www.eso.org/sci/data-processing/software/gasgano/"
SRC_URI="ftp://ftp.eso.org/pub/dfs/${PN}/${PN}-src-${MYPV}.tar.gz
	doc? ( ${HOMEPAGE}/${PDOC}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5
	dev-java/gnu-regexp
	dev-java/junit
	dev-java/jal"

S="${WORKDIR}/${PN}-${MYPV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-ext.patch
	sed -i \
		-e 's:gasgano/config:/usr/share/gasgano/config:g' \
		gasgano/src/org/eso/gasgano/properties/GasProp.java || die
	sed -i \
		-e 's:share/:share/gasgano/lib/:g' \
		scripts/gasgano || die
	eautoreconf
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	java-pkg_dojar dfs/src/dfs.jar javacpl/src/javacpl.jar \
		external/jConnect40.jar
	java-pkg_newjar gasgano/src/gasgano.jar
	emake -C scripts DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS
	insinto /usr/share/${PN}/config
	doins -r gasgano/config/*.rul || die
	make_desktop_entry gasgano "Gasgano FITS Organizer"
	if use doc; then
		insinto /usr/share/doc/${PF}
		newins "${DISTDIR}"/${PDOC}.pdf user-manual.pdf
	fi
}
