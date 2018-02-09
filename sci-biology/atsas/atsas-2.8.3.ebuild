# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Biological Small Angle Scattering"
HOMEPAGE="http://www.embl-hamburg.de/biosaxs"
#SRC_URI="ATSAS-${PV}-1.sl5.x86_64.tar.gz"
#SRC_URI="ATSAS-${PV}-1.el6.x86_64.tar.gz"
SRC_URI="ATSAS-${PV}-1_amd64.tar.gz"

SLOT="0"
LICENSE="atsas"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="examples"

RDEPEND="
	dev-libs/libxml2:2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/tiff:0
	sci-libs/cbflib
	x11-libs/qwt:5
"
DEPEND="dev-util/patchelf"

RESTRICT="fetch strip"

S="${WORKDIR}"/${P^^}-1

QA_PREBUILT="opt/.* usr/.*"

pkg_nofetch() {
	elog "Please visit http://www.embl-hamburg.de/biosaxs/atsas-online/download.php"
	elog "and download the ${A} for Ubuntu 16.04"
	elog "and place it in ${DISTDIR}"
}

src_install() {
	local i
	for i in bin/*; do
		patchelf \
			--set-rpath "$(gcc-config -L):${EPREFIX}/opt/${PN}/:${EPREFIX}/usr/lib/qt4/" \
			${i} || die
	done
	exeinto /opt/bin
	doexe bin/*

	insinto /opt/${PN}
	doins lib/*/atsas/{libqwt*.so*,libsaxsdocument*.so*,libsaxsplot*.so*}

	python_foreach_impl python_domodule lib/*/atsas/python*/dist-packages/*

	rm share/doc/${P}/LICENSE.txt || die
	if use examples; then
		cp -rf share/doc/${P}/* share/${PN}/ || die
	fi

	pushd share/icons/hicolor/ > /dev/null
	for i in *; do
		doicon -s ${i} -t hicolor ${i}/*
	done
	popd > /dev/null

	domenu share/applications/*

	rm -rf share/{applications,doc,icons,mime} || die

	insinto /usr
	doins -r share
}
