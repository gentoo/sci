# Copyright 1999-2009 Gentoo Foundation
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
RDEPEND=">=sci-chemistry/ccp4-6.1"
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
# fperms cannot handle wildcards
	chmod 755 "${D}"/usr/share/ccp4/XIAROOT/${P}/Applications/* || die
	chmod 644 "${D}"/usr/share/ccp4/XIAROOT/${P}/Applications/*.py || die

	# probably we need so set some ENV --> XIAROOT
}

pkg_postinst() {
	python_mod_optimize /usr/share/ccp4/XIAROOT
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ccp4/XIAROOT
}
