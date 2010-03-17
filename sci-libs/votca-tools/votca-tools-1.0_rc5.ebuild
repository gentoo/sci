# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"
SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz
	http://www.votca.org/downloads/${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost"

RDEPEND="sci-libs/fftw:3.0
	dev-libs/expat
	sci-libs/gsl
	boost? ( >=dev-libs/boost-1.33.1 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/"${PF}"-disable-la-files.patch
	epatch "${FILESDIR}"/"${PF}"-aclocal.patch

	eaclocal || die "eaclocal failed"
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf="--disable-la-files"

	use boost \
		&&  myconf="${myconf} $(use_with boost) --disable-votca-boost" \
		||  myconf="${myconf} $(use_with boost) --enable-votca-boost"

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NOTICE CHANGELOG

	sed -n -e 's/^export //' -e '/^VOTCA\(BIN\|LDLIB\)/p' \
		"${D}"/usr/bin/VOTCARC.bash >> "${T}/80${PN}"
	doenvd "${T}/80${PN}"
	rm -f "${D}"/usr/bin/VOTCARC*
}

pkg_postinst() {
	env-update
}

pkg_postrm() {
	env-update
}
