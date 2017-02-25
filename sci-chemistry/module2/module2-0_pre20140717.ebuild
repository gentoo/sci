# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# inherit

DESCRIPTION="Residual dipolar coupling and residual chemical shift analysis software"
HOMEPAGE="http://www.ibs.fr/science-213/scientific-output/software/module/?lang=en"
SRC_URI="MODULE2.tar.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/motif:2.2[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXpm[abi_x86_32(-)]
	x11-libs/libXt[abi_x86_32(-)]
"
DEPEND="${RDEPEND}
"

RESTRICT="fetch splitdebug"

S="${WORKDIR}"/MODULE2

QA_PREBUILT="opt/bin/.*"

pkg_nofetch() {
	elog "Please download ${A} from"
	elog "${HOMEPAGE}"
	elog "and place it in ${DISTDIR}"
}

src_install() {
	use prefix && \
		patchelf --set-rpath "${EPREFIX}"/usr/lib
	exeinto /opt/bin
	doexe module
	dosym module /opt/bin/${PN}

	dohtml -r MODULE2_manual_fichiers MODULE2_manual.htm

	insinto /usr/share/${PN}
	doins sample*
}
