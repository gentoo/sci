# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="X-ray Detector Software for processing single-crystal monochromatic diffraction data."
SRC_URI="XDS-linux_ifc_Intel+AMD-${PV}.tar.gz
		 XDS_html_doc-${PV}.tar.gz"
HOMEPAGE="http://www.mpimf-heidelberg.mpg.de/~kabsch/xds/"
RESTRICT="fetch"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="smp X"
RDEPEND="X? ( x11-libs/libXdmcp
			  x11-libs/libXau
			  x11-libs/libX11 )"
DEPEND=""

pkg_nofetch(){
	ewarn "Fetch XDS-linux_ifc_Intel+AMD.tar.gz and XDS_html_doc.tar.gz"
	ewarn "from ${HOMEPAGE}html_doc/downloading.html"
	ewarn "rename it to $A and"
	ewarn "place it in $DISTDIR"
}

src_install() {
	exeinto /opt/${PN}
	doexe XDS-linux_ifc_Intel+AMD/*
	if use smp; then
		rm "${D}"/opt/${PN}/{xds,mintegrate,mcolspot,xscale}
		dosym xds_par /opt/${PN}/xds
		dosym xscale_par /opt/${PN}/xscale
		dosym mintegrate_par /opt/${PN}/mintegrate
		dosym mcolspot_par /opt/${PN}/mcolspot
	else
		rm "${D}"/opt/${PN}/*par
	fi
	if ! use X; then
		rm "${D}"/opt/${PN}/VIEW
	fi
	dohtml -r XDS_html_doc/*
	dodoc XDS_html_doc/html_doc/INPUT_templates/*

	cat >> "${T}"/20xds <<- EOF
	PATH="/opt/${PN}/"
	EOF
	doenvd "${T}"/20xds
}

pkg_postinst() {
	elog "This package will expire on December 31, 2008"
}

