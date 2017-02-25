# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

MYP=${PN}-${PV}-lin64

DESCRIPTION="Optimized libm replacement from AMD for x86_64 architectures"
HOMEPAGE="http://developer.amd.com/tools/cpu-development/libm/"
SRC_URI="${MYP}.tar.gz"
LICENSE="AMD"
SLOT="0"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="examples static-libs"
RESTRICT="fetch strip"

S="${WORKDIR}/${MYP}"

QA_PREBUILT="opt/${PN}/$(get_libdir)/lib${PN}.so"
QA_TEXTRELS="${QA_PREBUILT}"

pkg_nofetch() {
	einfo "The package's license prohibits redistribution."
	einfo "Please download ${A} from"
	einfo "   ${HOMEPAGE}"
	einfo "and place it into ${DISTDIR}."
}

src_prepare() {
	cat <<- EOF > "${T}"/99${PN}
		LDPATH="${EROOT%/}/opt/${PN}/$(get_libdir)"
	EOF

	cat <<- EOF > "${T}"/${PN}.pc
		prefix=${EROOT%/}/opt/${PN}
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		Libs: -L\${libdir} -l${PN}
		Cflags: -I\${includedir}
	EOF
}

src_test() {
	cd examples || die
	sh build_and_run.sh || die
}

src_install() {
	dodoc ReleaseNotes.txt

	into /opt/${PN}
	dolib.so lib/dynamic/lib${PN}.so
	use static-libs && dolib.a lib/static/lib${PN}.a

	insinto /opt/${PN}
	doins -r include

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/${PN}.pc
	doenvd "${T}"/99${PN}
}
