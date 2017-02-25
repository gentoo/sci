# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit fortran-2 python-r1 toolchain-funcs

DESCRIPTION="A suite for carrying out complete molecular mechanics investigations"
HOMEPAGE="http://ambermd.org/#AmberTools"
SRC_URI="
	AmberTools${PV%_p*}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="X"

RESTRICT="fetch"

RDEPEND="${PYTHON_DEPS}
	virtual/cblas
	virtual/lapack
	sci-libs/clapack
	sci-libs/arpack
	sci-chemistry/mopac7
	sci-libs/netcdf
	sci-libs/netcdf-fortran
	>=sci-libs/fftw-3.3:3.0
	sci-chemistry/reduce"
DEPEND="${RDEPEND}
	app-shells/tcsh
	dev-util/byacc
	dev-libs/libf2c
	sys-devel/ucpp"

S="${WORKDIR}/amber14"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get AmberTools${PV%_p*}.tar.bz2"
	einfo "Place it into ${DISTDIR}"
}

pkg_setup() {
	fortran-2_pkg_setup
	export AMBERHOME="${S}"
}

src_prepare() {
	eapply \
		"${FILESDIR}"/${PN}-15-gentoo.patch
	eapply -p0 \
		"${FILESDIR}"/${PN}-15-update.{1..6}.patch

	eapply_user

	cd "${S}"/AmberTools/src || die
	rm -r \
		arpack \
		blas \
		byacc \
		lapack \
		fftw-3.3 \
		c9x-complex \
		netcdf-fortran-4.2 \
		netcdf-4.3.0 \
		reduce \
		ucpp-1.3 \
		|| die

	cd "${S}"/AmberTools/src || die
	sed \
		-e "s:\\\\\$(LIBDIR)/arpack.a:-larpack:g" \
		-e "s:\\\\\$(LIBDIR)/lapack.a:$($(tc-getPKG_CONFIG) lapack --libs) -lclapack:g" \
		-e "s:-llapack:$($(tc-getPKG_CONFIG) lapack --libs) -lclapack:g" \
		-e "s:\\\\\$(LIBDIR)/blas.a:$($(tc-getPKG_CONFIG) blas cblas --libs):g" \
		-e "s:-lblas:$($(tc-getPKG_CONFIG) blas cblas --libs):g" \
		-e "s:GENTOO_CFLAGS:${CFLAGS}:g" \
		-e "s:GENTOO_CXXFLAGS:${CXXFLAGS}:g" \
		-e "s:GENTOO_FFLAGS:${FFLAGS}:g" \
		-e "s:GENTOO_LDFLAGS:${LDFLAGS}:g" \
		-e "s:GENTOO_INCLUDE:${EPREFIX}/usr/include:g" \
		-e "s:GENTOO_FFTW3_LIBS:$($(tc-getPKG_CONFIG) fftw3 --libs):" \
		-e "s:fc=g77:fc=$(tc-getFC):g" \
		-e "s:NETCDF=\$netcdf:NETCDF=netcdf.mod:g" \
		-e "s:\$netcdf_flag:$($(tc-getPKG_CONFIG) netcdf --libs):g" \
		-e "s:\$netcdfflagc:$($(tc-getPKG_CONFIG) netcdf --libs):g" \
		-e "s:\$netcdfflagf:$($(tc-getPKG_CONFIG) netcdf-fortran --libs):g" \
		-i configure2 || die

	sed \
		-e "s:arsecond_:arscnd_:g" \
		-i sff/time.c sff/sff.h sff/sff.c || die

}

src_configure() {
	python_setup

	local myconf="--no-updates"

	use X || myconf="${myconf} -noX11"

	cd "${S}" || die

	sed \
		-e '/patch_amber.py/d' \
		-i configure || die

	./configure \
		${myconf} \
		-nomtkpp \
		--with-python ${PYTHON} \
		--with-netcdf /usr \
		gnu || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		FC=$(tc-getFC)
}

src_test() {
	source ${AMBERHOME}/amber.sh

	emake test
}

src_install() {
	local x
	for x in bin/*
	do
		[ ! -d ${x} ] && dobin ${x}
	done

	dobin AmberTools/src/antechamber/mopac.sh
	sed \
		-e "s:\$AMBERHOME/bin/mopac:mopac7:g" \
		-i "${ED}/usr/bin/mopac.sh" || die

	# Make symlinks untill binpath for amber will be fixed
	dodir /usr/share/${PN}/bin
	cd "${ED}/usr/bin" || die
	for x in *
	do
		dosym ../../../bin/${x} /usr/share/${PN}/bin/${x}
	done
	cd "${S}" || die

	dodoc doc/Amber15.pdf

	dolib.a  lib/*.a
	dolib.so lib/*.so

	local m=(
		chemistry
		compat24.py
		cpinutils
		fortranformat
		interface
		mcpb
		mdoutanalyzer
		MMPBSA_mods
		ParmedTools
		pymsmtexp.py
		pymsmtlib
		pymsmtmol
		sander
		sanderles
	)
	for x in ${m[@]}
	do
		python_domodule lib/${EPYTHON}/site-packages/${x}
	done

	insinto /usr/include/${PN}
	doins include/*

	insinto /usr/share/${PN}
	doins -r dat
	cd AmberTools || die
	doins -r benchmarks examples test

	cat >> "${T}"/99ambertools <<- EOF
	AMBERHOME="${EPREFIX}/usr/share/ambertools"
	EOF
	doenvd "${T}"/99ambertools
}
