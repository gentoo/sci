# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV/_p/-}

DESCRIPTION="Optimized libm replacement from AMD for x86_64 architectures"
HOMEPAGE="https://developer.amd.com/amd-aocl/amd-math-library-libm/"
SRC_URI="
	aocc? ( aocl-libm-linux-aocc-${MY_PV}.tar.gz )
	!aocc? ( aocl-libm-linux-gcc-${MY_PV}.tar.gz )
"
S="${WORKDIR}"/amd-libm

LICENSE="AMD"
SLOT="0"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="aocc examples static-libs test"
RESTRICT="fetch strip !test? ( test )"

QA_PREBUILT="*"
QA_TEXTRELS="*"

pkg_nofetch() {
	einfo "The package's license prohibits redistribution."
	einfo "Please download the package from"
	einfo "\t ${HOMEPAGE}"
	einfo "and place it into your DISTDIR folder"
}

src_prepare() {
	default

	sed -e "s/^CC =.*$/CC = $(tc-getCC)/" -i examples/Makefile || die

	cat <<- EOF > "${T}"/amdlibm.pc
		prefix=${EROOT}/usr
		exec_prefix=\${prefix}
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${MY_PV}
		Libs: -L\${libdir} -lamdlibm
		Cflags: -I\${includedir}
	EOF
}

src_test() {
	cd examples || die
	AOCL_ROOT=".." emake test_libm
	LD_LIBRARY_PATH=../lib ./test_libm || die
}

src_install() {
	dodoc ReleaseNotes.txt

	doheader include/*

	dolib.so lib/libamdlibm.so
	use static-libs && \
	dolib.a  lib/libamdlibm.a

	if use examples; then
		dodoc -r examples
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/amdlibm.pc
}
