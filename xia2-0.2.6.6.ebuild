# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

DESCRIPTION="An automated data reduction system for crystallography"
HOMEPAGE="http://www.ccp4.ac.uk/xia/"
SRC_URI="${HOMEPAGE}/${P}.tar.bz2"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-lang/python
	>=sci-chemistry/ccp4-6.0.99"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf ${P}/binaries || die
	find . -name '*.bat' | xargs rm || die
	sed -i \
		-e "s:/path/to/xiahome:/usr/share/ccp4/XIAROOT:g" \
		setup.*
	epatch "${FILESDIR}"/${PV}-fix-syntax.patch
}

src_compile() {
	:
}

src_install() {
	insinto /usr/share/ccp4/XIAROOT/
	doins -r * || die

	# Set programs executable
	fperms 755 /usr/share/ccp4/XIAROOT/${P}/Applications/*
	fperms 644 /usr/share/ccp4/XIAROOT/${P}/Applications/*.py
}

pkg_postinst() {
	python_mod_optimize /usr/share/ccp4/XIAROOT
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ccp4/XIAROOT
}
