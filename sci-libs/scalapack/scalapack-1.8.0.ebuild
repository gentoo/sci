# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs versionator alternatives-2

DESCRIPTION="Subset of LAPACK routines redesigned for heterogenous computing"
HOMEPAGE="http://www.netlib.org/scalapack/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

RDEPEND="virtual/blacs
	virtual/lapack"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

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

src_configure() {
	sed -e "s:\(^home[[:space:]]*=\).*:\1${S}:" \
		-e "s:\(^CDEFS[[:space:]]*=\).*:\1-DAdd_ -DNO_IEEE -DUsingMpiBlacs:" \
		-e "s:\(^F77FLAGS[[:space:]]*=\).*:\1${FFLAGS}:" \
		-e "s:\(^F77LOADFLAGS[[:space:]]*=\).*:\1${LDFLAGS}:" \
		-e "s:\(^CCFLAGS[[:space:]]*=\).*:\1${CFLAGS}:" \
		-e "s:\(^CCLOADFLAGS[[:space:]]*=\).*:\1${LDFLAGS}:" \
		-e "s:\(^ARCH[[:space:]]*=\).*:\1$(tc-getAR):" \
		-e "s:\(^RANLIB[[:space:]]*=\).*:\1$(tc-getRANLIB):" \
		-e "s:\(^SMPLIB[[:space:]]*=\).*:\1:" \
		-e "s:\(^BLACSFINIT[[:space:]]*=\).*:\1:" \
		-e "s:\(^BLACSCINIT[[:space:]]*=\).*:\1:" \
		-e "s:\(^BLACSLIB[[:space:]]*=\).*:\1$(pkg-config --libs blacs):" \
		-e "s:\(^BLASLIB[[:space:]]*=\).*:\1$(pkg-config --libs blas):" \
		-e "s:\(^LAPACKLIB[[:space:]]*=\).*:\1$(pkg-config --libs lapack):" \
		SLmake.inc.example > SLmake.inc || die
}

src_compile() {
	# removing -j1 is tricky because of race to create archive
	emake -j1 \
		NOOPT="-fPIC" \
		F77FLAGS="${FFLAGS} -fPIC" \
		CCFLAGS="${CFLAGS} -fPIC"
	local l
	LINK=mpicc make_shared_lib lib${PN}.a $(pkg-config --libs blas lapack blacs)
	if use static-libs; then
		emake cleanlib && rm lib*.a
		emake -j1
	fi
}

src_test() {
	emake exe
	cd TESTING
	local x
	for x in ./x*; do
		mpirun -np 4 $x 2>&1 | tee $x.log
		grep -q "\*\*\*" $x.log && die "$x failed"
	done
}

src_install() {
	cd LIB
	dolib.so lib*.so*
	use static-libs && dolib.a lib*.a
	cd "${S}"
	insinto /usr/include/${PN}
	doins PBLAS/SRC/*.h || die

	local pcfile=ref${PN}.pc
	cat <<-EOF > ${pcfile}
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -l${PN}
		Private: -lm
		Cflags: -I\${includedir}/${PN}
		Requires: blas lapack blacs
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${pcfile} || die
	alternatives_for scalapack reference \
		0 "/usr/$(get_libdir)/pkgconfig/scalapack.pc" "${pcfile}"

}
