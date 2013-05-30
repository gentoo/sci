# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/xia2/xia2-0.3.4.0.ebuild,v 1.1 2012/02/28 20:57:14 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils python-r1

DESCRIPTION="An automated data reduction system for crystallography"
HOMEPAGE="http://www.ccp4.ac.uk/xia/"
SRC_URI="http://www.ccp4.ac.uk/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=sci-chemistry/ccp4-apps-6.1.2
	sci-chemistry/mosflm
	sci-chemistry/pointless
	>=sci-libs/ccp4-libs-6.1.2
	sci-libs/cctbx"
DEPEND="${RDEPEND}"

src_prepare() {
	find . -name '*.bat' -delete || die

	epatch "${FILESDIR}"/${P}-fix-syntax.patch
}

src_install() {
	local bin
	dohtml html/*
	rm -rf html || die

	dodoc readme.txt
	rm -f *txt setup.* || die

	installation() {
		python_moduleinto ${PN}
		python_domodule *
	}

	python_foreach_impl installation

	insinto /usr/share/ccp4/${PN}
	doins -r *

	cat >> "${T}"/23XIA <<- EOF
	XIA2_ROOT="${EPREFIX}/usr/share/ccp4/${PN}"
	XIA2CORE_ROOT="${EPREFIX}/usr/share/ccp4/${PN}/core"
	EOF

	doenvd "${T}"/23XIA

	cd Applications || die
	rm __init__.py || die

	sed \
		-e '1i#!/usr/bin/python' \
		-i xia2hdr.py || die

	for bin in *.py; do
		python_foreach_impl python_newscript ${bin} ${bin#.py}
	done

	dobin xia2html x1335 pydiffdump2xds pychef cbfdump aimless2gnuplot
}

pkg_postinst() {
	echo ""
	elog "In order to use the package, you need to"
	elog "\t source ${EPREFIX}/etc/profile"
	echo ""
}
