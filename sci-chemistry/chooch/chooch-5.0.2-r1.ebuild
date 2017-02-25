# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib toolchain-funcs

DESCRIPTION="Automatically determine values of the anomalous scattering factors"
HOMEPAGE="http://www.gwyndafevans.co.uk/id2.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/${PN}/${PV}/packed/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	sci-libs/gsl
	sci-libs/Cgraph
	sci-libs/pgplot"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}/${P}

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.am.patch
	"${FILESDIR}"/${PV}-aclocal.patch
)

AT_M4DIR="${S}"

DOCS=( doc/${PN}.pdf )

src_configure() {
	local myeconfargs=(
		--with-pgplot-prefix="${EPREFIX}/usr"
		--with-cgraph-prefix="${EPREFIX}/usr"
		--with-gsl-prefix="${EPREFIX}/usr"
		--disable-gsltest
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if	use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
