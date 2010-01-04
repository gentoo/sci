# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"

inherit autotools base flag-o-matic

DESCRIPTION="Object-oriented libraries for the organisation of crystallographic data and the performance of crystallographic computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
# Transform 4-digit year to 2 digits
SRC_URI="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper-2.1-${PV:2:${#PV}}-ac.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="debug"

RDEPEND="
	sci-libs/ccp4-libs
	sci-libs/fftw"
DEPEND="${RDEPEND}"

S=${WORKDIR}/clipper-2.1

PATCHES=(
#	"${FILESDIR}"/as-needed.patch
	"${FILESDIR}"/${PV}-missing-var.patch
	)

src_prepare() {
	base_src_prepare

	# ccp4 provides these, and more.
	sed -i -e "s:examples::g" "${S}"/Makefile.am

	AT_M4DIR="config" eautoreconf
}

src_configure() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	econf \
		--enable-ccp4 \
		--enable-cif \
		--enable-cns \
		--enable-contrib \
		--enable-minimol \
		--enable-mmdb \
		--enable-phs \
		--with-mmdb=/usr \
		$(use_enable debug) \
		|| die
}

src_test() {
	emake \
		-C examples \
		check || die
}

src_install() {
	base_src_install
	dodoc README ChangeLog NEWS || die
}
