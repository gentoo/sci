# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

MY_PN="autodocksuite"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A suite of automated docking tools"
HOMEPAGE="http://autodock.scripps.edu/"
SRC_URI="mirror://gentoo/${MY_PN}/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gcc-4.3.patch \
		"${FILESDIR}"/${PV}-respect-flags.patch

	for i in autodock autogrid; do
		pushd $i
		eautoreconf
		popd
	done
}

src_configure() {
	for i in autodock autogrid; do
		pushd $i
		econf || die "AutoDock econf failed."
		popd
	done
}

src_compile() {
	emake -C autodock || die
	emake -C autogrid || die
}

src_install() {
	dobin "${S}"/autodock/autodock4 "${S}"/autogrid/autogrid4 \
		|| die "Failed to install autodock binary."

	insinto "/usr/share/autodock"
	doins "${S}"/autodock/{AD4_parameters.dat,AD4_PARM99.dat} \
		 || die "Failed to install shared files."

	dodoc "${S}"/autodock/{AUTHORS,ChangeLog,NEWS,README} \
		|| die "Failed to install documentation."
}

src_test() {
	cd "${S}/autodock/Tests"
	python test_autodock4.py || die "AutoDock tests failed."
	cd "${S}/autogrid/Tests"
	python test_autogrid4.py || die "AutoGrid tests failed."
}

pkg_postinst() {
	einfo "The AutoDock development team requests all users to fill out the"
	einfo "registration form at:"
	einfo
	einfo "\thttp://autodock.scripps.edu/downloads/autodock-registration"
	einfo
	einfo "The number of unique users of AutoDock is used by Prof. Arthur J."
	einfo "Olson and the Scripps Research Institude to support grant"
	einfo "applications."
}
