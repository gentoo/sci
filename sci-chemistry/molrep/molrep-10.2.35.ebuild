# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.gz"

LICENSE="ccp4"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="
	>=sci-libs/ccp4-libs-6.1.1
	sci-libs/mmdb
	virtual/lapack"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-respect-FLAGS.patch
	)

src_compile() {
	cd "${S}"/src
	emake clean || die
	emake \
		MR_FORT=$(tc-getFC) \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MR_LIBRARY="-L/usr/$(get_libdir) -lccp4f -lccp4c -lmmdb -lccif -llapack -lstdc++ -lm" \
	|| die
}

src_test() {
	ewarn "Can take a long, long time ..."
	ewarn "Go, take a coffee, lunch, go to sleep and have breakfast ..."
	cd molrep_check && \
		sed 's:\.\.:\.:g' -i em.bat && \
		mkdir out && \
		mkdir scr && \
		MR_TEST="${S}/bin" bash em.bat && \
		MR_TEST="${S}/bin" bash mr.bat || \
		die "test failed"
}

src_install() {
	dobin bin/${PN} || die

	dodoc readme doc/${PN}.rtf || die
}
