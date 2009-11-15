# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Automated crystallographic structure solution for MIR, SAD, and MAD"
SRC_URI="x86? ( http://solve.lanl.gov/pub/solve/${PV}/solve-${PV}-linux.tar.gz )
		 amd64? ( http://solve.lanl.gov/pub/solve/${PV}/solve-${PV}-linux-64.tar.gz )"
HOMEPAGE="http://www.solve.lanl.gov/index.html"

SLOT="0"
LICENSE="solve"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

RESTRICT="mirror"

IN_PATH=/opt/solve-resolve/

src_install(){
	exeinto ${IN_PATH}bin/
	doexe solve-2.13/bin/*

	cd "${WORKDIR}"
	insinto ${IN_PATH}lib/
	doins solve-2.13/lib/{*sym,sym*,hist*,*dat} || die
	insinto ${IN_PATH}lib/segments
	doins solve-2.13/lib/segments/* || die
	insinto ${IN_PATH}lib/patterns
	doins solve-2.13/lib/patterns/* || die

	dohtml -r solve-2.13/lib/html/* || die
	sed -i 's:/usr/local/lib/solve/:/opt/solve-resolve/lib/:' \
			solve-2.13/lib/examples_solve/p9/solve*
	sed -i 's:/usr/local/lib/resolve/:/opt/solve-resolve/lib/:' \
			solve-2.13/lib/examples_resolve/{resolve.csh,prime_and_switch.csh}
	insinto /usr/share/${PF}/examples_resolve
	doins solve-2.13/lib/examples_resolve/* || die
	insinto /usr/share/${PF}/examples_solve
	doins -r solve-2.13/lib/examples_solve/* || die

	cat >> "${T}"/20solve-resolve <<- EOF
	CCP4_OPEN="UNKNOWN"
	SYMOP="${IN_PATH}lib/symop.lib"
	SYMINFO="${IN_PATH}lib/syminfo.lib"
	SOLVEDIR="${IN_PATH}lib/"
	PATH="${IN_PATH}bin"
	EOF

	doenvd "${T}"/20solve-resolve
}

pkg_postinst(){
	einfo "Get a valid license key from"
	einfo "http://solve.lanl.gov/license.html"
	einfo "and place it in"
	einfo "${IN_PATH}lib/"
}
