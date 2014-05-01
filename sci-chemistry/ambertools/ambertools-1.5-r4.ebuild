# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="A suite for carrying out complete molecular mechanics investigations"
HOMEPAGE="http://ambermd.org/#AmberTools"
SRC_URI="
	AmberTools-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="openmp X"

RESTRICT="fetch"

RDEPEND="
	virtual/cblas
	virtual/lapack
	sci-libs/clapack
	sci-libs/arpack
	sci-libs/cifparse-obj
	sci-chemistry/mopac7
	sci-libs/netcdf
	sci-libs/fftw:2.1
	sci-chemistry/reduce
	virtual/fortran"
DEPEND="${RDEPEND}
	dev-util/byacc
	dev-libs/libf2c
	sys-devel/ucpp"
S="${WORKDIR}/amber11"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "Place it in ${DISTDIR}"
}

pkg_setup() {
	fortran-2_pkg_setup
	if use openmp; then
		tc-has-openmp || \
			die "Please select an openmp capable compiler like gcc[openmp]"
	fi
	AMBERHOME="${S}"
}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-bugfix_1-21.patch" \
		"${FILESDIR}/${P}-bugfix_22-27.patch" \
		"${FILESDIR}/${P}-bugfix_28.patch" \
		"${FILESDIR}/${P}-gentoo2.patch" \
		"${FILESDIR}/${P}-overflow.patch"
	cd "${S}"/AmberTools/src
	rm -r \
		arpack \
		blas \
		byacc \
		lapack \
		fftw-2.1.5 \
		fftw-3.2.2 \
		c9x-complex \
		cifparse \
		netcdf \
		pnetcdf \
		reduce \
		ucpp-1.3 \
		|| die
}

src_configure() {
	cd "${S}"/AmberTools/src
	sed -e "s:\\\\\$(LIBDIR)/arpack.a:-larpack:g" \
		-e "s:\\\\\$(LIBDIR)/lapack.a:$($(tc-getPKG_CONFIG) lapack --libs) -lclapack:g" \
		-e "s:\\\\\$(LIBDIR)/blas.a:$($(tc-getPKG_CONFIG) blas cblas --libs):g" \
		-e "s:\\\\\$(LIBDIR)/libdrfftw.a:${EPREFIX}/usr/$(get_libdir)/libdrfftw.a:g" \
		-e "s:\\\\\$(LIBDIR)/libdfftw.a:${EPREFIX}/usr/$(get_libdir)/libdrfftw.a:g" \
		-e "s:GENTOO_CFLAGS:${CFLAGS} -DBINTRAJ :g" \
		-e "s:GENTOO_CXXFLAGS:${CXXFLAGS}:g" \
		-e "s:GENTOO_FFLAGS:${FFLAGS}:g" \
		-e "s:GENTOO_LDFLAGS:${LDFLAGS}:g" \
		-e "s:fc=g77:fc=$(tc-getFC):g" \
		-e "s:\$netcdflib:$($(tc-getPKG_CONFIG) netcdf --libs):g" \
		-e "s:NETCDF=\$netcdf:NETCDF=netcdf.mod:g" \
		-i configure || die
	sed -e "s:arsecond_:arscnd_:g" \
		-i sff/time.c \
		-i sff/sff.h \
		-i sff/sff.c || die
	sed -e "s:\$(NAB):\$(NAB) -lrfftw:g" \
		-i nss/Makefile || die

	local myconf

	use X || myconf="${myconf} -noX11"

	use openmp && myconf="${myconf} -openmp"

	./configure \
		${myconf} \
		-nobintraj \
		-nomdgx \
		-nomtkpp \
		-nopython \
		-nosleap \
		gnu
}

src_compile() {
	cd "${S}"/AmberTools/src
	emake || die
}

src_test() {
	cd "${S}"/AmberTools/test
	make test || die
}

src_install() {
	rm -r bin/chemistry bin/MMPBSA_mods
	rm bin/ante-MMPBSA.py bin/extractFrcmod.py

	for x in bin/*
		do dobin ${x} || die
	done

	dobin AmberTools/src/antechamber/mopac.sh
	sed -e "s:\$AMBERHOME/bin/mopac:mopac7:g" \
		-i "${ED}/usr/bin/mopac.sh" || die

	# Make symlinks untill binpath for amber will be fixed
	dodir /usr/share/${PN}/bin
	cd "${ED}/usr/bin"
	for x in *
		do dosym /usr/bin/${x} /usr/share/${PN}/bin/${x}
	done
	cd "${S}"

	dodoc doc/AmberTools.pdf doc/leap_pg.pdf
	dolib.a lib/*
	insinto /usr/include/${PN}
	doins include/*
	insinto /usr/share/${PN}
	doins -r dat
	cd AmberTools
	doins -r benchmarks
	doins -r examples
	doins -r test

	cat >> "${T}"/99ambertools <<- EOF
	AMBERHOME="${EPREFIX}/usr/share/ambertools"
	EOF
	doenvd "${T}"/99ambertools
}
