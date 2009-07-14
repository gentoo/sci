# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/clipper/clipper-20070907.ebuild,v 1.1 2007/12/19 18:43:12 dberkholz Exp $

inherit autotools flag-o-matic

DESCRIPTION="Object-oriented libraries for the organisation of crystallographic data and the performance of crystallographic computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
# Transform 4-digit year to 2 digits
SRC_URI="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper-2.1-${PV:2:${#PV}}-ac.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
RDEPEND="sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"
S=${WORKDIR}/clipper-2.1

src_unpack() {
	unpack ${A}
	cd "${S}"

	# ccp4 provides these, and more.
	sed -i -e "s:examples::g" "${S}"/Makefile.am

	epatch "${FILESDIR}"/20081201-as-needed.patch \
		"${FILESDIR}"/${PV}-typo.patch

	AT_M4DIR="config" eautoreconf
}

src_compile() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	# Slot programs with a '-2' suffix
	econf \
		--enable-contrib \
		--enable-phs \
		--enable-mmdb \
		--with-mmdb=/usr \
		--enable-minimol \
		--enable-cif \
		--enable-ccp4 \
		--enable-cns \
		|| die
	# We don't have a cctbx ebuild yet
	#		--enable-cctbx \

	emake || die
}

src_test() {
	cd examples
	emake || die
	./maketestdata || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README ChangeLog NEWS
}
