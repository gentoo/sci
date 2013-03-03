# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/acml/acml-4.1.0-r1.ebuild,v 1.4 2008/12/07 18:28:37 vapier Exp $

EAPI=4

inherit multilib versionator

MYP=${PN}-$(replace_all_version_separators '-')

DESCRIPTION="Optimized libm replacement from AMD for x86_64 architectures"
HOMEPAGE="http://developer.amd.com/cpu/Libraries/LibM/Pages/default.aspx"
SRC_URI="${PN}${PV}lin64.tar.gz"
LICENSE="AMD"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="examples"
RESTRICT="fetch strip"

S=${WORKDIR}/${MYP}

QA_PREBUILT="/opt/${PN}/lib64/lib${PN}.so"

pkg_nofetch() {
	einfo "The package's license prohibits redistribution."
	einfo "Please download ${A} from"
	einfo "   ${HOMEPAGE}"
	einfo "and place it into ${DISTDIR}."
}

src_prepare() {
	cat <<- EOF > "${T}/99${PN}"
		LDPATH="/opt/${PN}/$(get_libdir)"
	EOF

	cat <<- EOF > "${T}/${PN}.pc"
		prefix=/opt/${PN}
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: amdlibm
		Description: ${DESCRIPTION}
		Version: ${PV}
		Libs: -L\${libdir} -l${PN}
		Cflags: -I\${includedir}
	EOF
}

src_test() {
	cd examples
	sh build_and_run.sh || die
}

src_install() {
	dodoc ReleaseNotes.txt

	into /opt/${PN}
	dolib.so lib/dynamic/lib${PN}.so
	dolib.a lib/static/lib${PN}.a

	insinto /opt/${PN}
	doins -r include

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}/${PN}.pc"
	doenvd "${T}/99${PN}"
}
