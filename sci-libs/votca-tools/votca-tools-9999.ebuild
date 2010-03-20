# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools mercurial

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-boost doc"

RDEPEND="sci-libs/fftw:3.0
	dev-libs/expat
	sci-libs/gsl
	boost? ( >=dev-libs/boost-1.33.1 )
	doc? ( >=app-text/txt2tags-2.5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

EHG_REPO_URI="https://tools.votca.googlecode.com/hg/"

S="${WORKDIR}/hg"

src_prepare() {
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
	dodoc NOTICE
	if use doc; then
		emake CHANGELOG || die "emake CHANGELOG failed"
		dodoc CHANGELOG
	fi

	sed -n -e '/^VOTCA\(BIN\|LDLIB\)/p' \
		"${D}"/usr/bin/VOTCARC.bash >> "${T}/80${PN}"
	doenvd "${T}/80${PN}"
	rm -f "${D}"/usr/bin/VOTCARC*
}
