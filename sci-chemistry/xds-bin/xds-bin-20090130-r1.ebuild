# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="X-ray Detector Software for processing single-crystal monochromatic diffraction data."
HOMEPAGE="http://xds.mpimf-heidelberg.mpg.de/"
SRC_URI="ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS-linux_ifc_Intel+AMD.tar.gz -> XDS-linux_ifc_Intel+AMD-${PV}.tar.gz
	 ftp://ftp.mpimf-heidelberg.mpg.de/pub/kabsch/XDS_html_doc.tar.gz -> XDS_html_doc-${PV}.tar.gz"
RESTRICT=""
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="smp X"
RDEPEND="X? ( sci-visualization/xds-viewer )"
DEPEND=""

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
	dohtml -r XDS_html_doc/*
	dodoc XDS_html_doc/html_doc/INPUT_templates/*

	cat >> "${T}"/20xds <<- EOF
	PATH="/opt/${PN}/"
	EOF
	doenvd "${T}"/20xds
}

pkg_postinst() {
	elog "This package will expire on December 31, 2009"
}

