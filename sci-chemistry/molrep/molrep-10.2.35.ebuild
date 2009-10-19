# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.gz
	 test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test extra-test"

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
	einfo "Starting tests ..."
	export PATH="${WORKDIR}/test-framework/scripts:${S}/bin:${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	export CCP4_SCR="${T}"
	ccp4-run-thorough-tests -v test_molrep || die "nomal test failed"

	use extra-test && \
		cd "${S}"/molrep_check && \
			ewarn "Can take a long, long time ..." && \
			ewarn "Go, take a coffee, lunch, go to sleep and have breakfast ..." && \
				sed 's:\.\.:\.:g' -i em.bat && \
				mkdir out && \
				mkdir scr && \
				MR_TEST="${S}/bin" bash em.bat && \
				MR_TEST="${S}/bin" bash mr.bat || \
				die "extra-test failed"
}

src_install() {
	dobin bin/${PN} || die

	dodoc readme doc/${PN}.rtf || die
}
