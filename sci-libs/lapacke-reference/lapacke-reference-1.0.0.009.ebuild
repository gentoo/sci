# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs versionator alternatives-2

MYP=lapacke-${PV}

DESCRIPTION="C Interface to LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/lapacke.tgz -> ${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=""
DEPEND="test? (	virtual/lapack dev-util/pkgconfig )"

S="${WORKDIR}/lapacke"

LIBNAME=reflapacke

make_shared_lib() {
	local libstatic=${1}
	local soname=$(basename "${1%.a}").so.$(get_major_version)
	shift
	einfo "Making ${soname}"
	${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
		"$@" -o $(dirname "${libstatic}")/"${soname}" || die "${soname} failed"
	ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
}

src_prepare() {
	cat > make.inc <<-EOF
		CC = $(tc-getCC)
		CFLAGS = ${CFLAGS}
		LINKER = \$(CC)
		LDFLAGS = ${LDFLAGS}
		ARCH = $(tc-getAR)
		ARCHFLAGS = cr
		RANLIB = $(tc-getRANLIB)
		LAPACKE = lib${LIBNAME}.a
	EOF
}

src_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" lapacke
	make_shared_lib lib${LIBNAME}.a
	if use static-libs; then
		emake clean && rm -f lib${LIBNAME}.a
		emake lapacke
	fi
}

src_test() {
	emake LIBS="$(pkg-config --libs lapack)" lapacke_testing
}

src_install() {
	dolib.so lib${LIBNAME}.so*
	use static-libs && dolib.a lib${LIBNAME}.a
	insinto /usr/include
	doins include/lapacke*h || die
	cat <<-EOF > ${LIBNAME}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: LAPACK C Extension - Reference
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${LIBNAME} -lm
		Cflags: -I\${includedir}
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${LIBNAME}.pc || die
	alternatives_for lapacke reference 0 \
		"/usr/$(get_libdir)/pkgconfig/lapacke.pc" "${LIBNAME}.pc"
}
