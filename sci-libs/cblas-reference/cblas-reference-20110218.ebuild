# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils alternatives-2 flag-o-matic toolchain-funcs

MYPN="${PN/-reference/}"

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
LICENSE="public-domain"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/blast-forum/${MYPN}.tgz -> ${P}.tgz"

SLOT="0"
IUSE="static-libs"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="virtual/blas
	virtual/fortran"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/CBLAS"

LIBNAME=refcblas
LIBVER=3

make_shared_lib() {
	local libstatic=${1}
	local soname=$(basename "${1%.a}").so.${LIBVER}
	shift
	einfo "Making ${soname}"
	${LINK:-$(tc-getCC)} ${LDFLAGS}  \
		-shared -Wl,-soname="${soname}" \
		-Wl,--whole-archive "${libstatic}" -Wl,--no-whole-archive \
		"$@" -o $(dirname "${libstatic}")/"${soname}" || die "${soname} failed"
	ln -s "${soname}" $(dirname "${libstatic}")/"${soname%.*}"
}

src_prepare() {
	find . -name Makefile  -exec sed -i \
		-e 's:make:$(MAKE):g' '{}' \;
	append-cflags -DADD_
	cat > Makefile.in <<-EOF
		BLLIB=$(pkg-config --libs blas)
		FC=$(tc-getFC)
		CC=$(tc-getCC)
		CBLIB=../lib/lib${LIBNAME}.a
		LOADER=\$(FC)
		ARCH=$(tc-getAR)
		ARCHFLAGS=cr
		RANLIB=$(tc-getRANLIB)
	EOF
}

src_compile() {
	emake \
		FFLAGS="${FFLAGS} -fPIC" \
		CFLAGS="${CFLAGS} -fPIC" \
		CBLIB=../lib/lib${LIBNAME}.a \
		alllib
	cd lib
	make_shared_lib lib${LIBNAME}.a $(pkg-config --libs blas)
	cd "${S}"
	if use static-libs; then
		emake clean
		emake alllib
	fi
}

src_test() {
	cd testing
	emake
	emake run
}

src_install() {
	dolib.so lib/lib${LIBNAME}.so*
	use static-libs && dolib.a lib/lib${LIBNAME}.a
	insinto /usr/include/cblas
	doins include/cblas.h
	cat <<-EOF > ${LIBNAME}.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${LIBNAME}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${LIBNAME}
		Private: -lm
		Cflags: -I\${includedir}/cblas
		Requires: blas
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${LIBNAME}.pc
	dodoc README
	insinto /usr/share/doc/${PF}
	doins examples/*.c
	alternatives_for cblas reference 0 \
		/usr/$(get_libdir)/pkgconfig/cblas.pc ${LIBNAME}.pc \
		/usr/include/cblas.h cblas/cblas.h
}
