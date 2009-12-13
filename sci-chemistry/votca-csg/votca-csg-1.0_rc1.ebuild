# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools bash-completion

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"
SRC_URI="http://www.votca.org/downloads/votca-csg-1.0_rc1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sci-libs/fftw:3.0
	dev-libs/libxml2
	sci-libs/gsl
	>=dev-libs/boost-1.33.1
	sci-libs/votca-tools
	>=sci-chemistry/gromacs-4.0.5-r1
	dev-lang/perl
	app-shells/bash"

RDEPEND="${DEPEND}"

pkg_setup() {
	export CPPFLAGS="${CPPFLAGS} -I/usr/include/gromacs"
}

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README

	sed -n -e '/^CSG\(BIN\|SHARE\)/p' "${D}"/usr/bin/CSGRC.bash > "${T}/80votca-csg"
	doenvd "${T}/80votca-csg"
	sed -n '/^_csgopt/,$p' "${D}"/usr/bin/CSGRC.bash > "${T}"/completion.bash
	dobashcompletion "${T}"/completion.bash ${PN}
	rm -f "${D}"/usr/bin/CSGRC*
}

pkg_postinst() {
	env-update && source /etc/profile
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
}
