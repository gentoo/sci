# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base flag-o-matic python

DESCRIPTION="A program for phasing macromolecular crystal structures"
HOMEPAGE="http://www-structmed.cimr.cam.ac.uk/phaser"
SRC_URI="ftp://ftp.ccp4.ac.uk/ccp4/6.1.1/${PN}-${PV}-cctbx-src.tar.gz"

LICENSE="|| ( phaser phaser-com ccp4 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="openmp"
RDEPEND=""
DEPEND="${RDEPEND}
		  app-shells/tcsh"

S="${WORKDIR}"/ccp4-6.1.1

PATCHES=(
	"${FILESDIR}"/phaser-2.1.4-chmod.patch
	)

src_prepare() {
	base_src_prepare

	use openmp && append-flags -fopenmp

	for i in ${CXXFLAGS}; do
		OPTS="${OPTS} \"${i}\","
	done

	OPTS=${OPTS%,}

	sed -i \
		-e "s:opts = \[.*\]$:opts = \[${OPTS}\]:g" \
		"${S}"/lib/cctbx/cctbx_sources/libtbx/SConscript || die

	for i in ${LDFLAGS}; do
		OPTSLD="${OPTSLD} \"${i}\","
	done

	sed -i \
		-e "s:env_etc.shlinkflags .* \"-shared\":env_etc.shlinkflags = \[ ${OPTSLD} \"-shared\"\]:g" \
		"${S}"/lib/cctbx/cctbx_sources/libtbx/SConscript || die

}

src_compile() {
	local compiler
	local mtype
	local mversion
	local nproc

	# Valid compilers are win32_cl, sunos_CC, unix_gcc, unix_ecc,
	# unix_icc, unix_icpc, tru64_cxx, hp_ux11_aCC, irix_CC,
	# darwin_c++, darwin_gcc.  The build systems seems to prepend
	# unix_ all by itself.  Can this be derived from $(tc-getCC)?
	compiler=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')

	# Breaks cross compilation.
	mtype=$(src/${PN}/bin/machine_type)
	mversion=$(src/${PN}/bin/machine_version)
	nproc=`echo "-j1 ${MAKEOPTS}" \
		| sed -e "s/.*\(-j\s*\|--jobs=\)\([0-9]\+\).*/\2/"`

	einfo "Creating build directory $nproc "
	mkdir build
	cd    build
	ln -sf "${S}/lib/cctbx/cctbx_sources/scons"  scons
	ln -sf "${S}/lib/cctbx/cctbx_sources/libtbx" libtbx

	# It is difficult to rely on sci-libs/cctbx for the cctbx
	# dependency, because upstream releases new versions quite
	# frequently.  Perhaps better to link statically to the bundled
	# cctbx.
	einfo "Configuring phaser components"
	python_version
	${python} "libtbx/configure.py" \
		--build=release \
		--compiler=${compiler} \
		--repository="${S}"/src/${PN}/source \
		--repository="${S}"/lib/cctbx/cctbx_sources \
		--static_libraries \
		ccp4io="${S}" \
		mmtbx \
		phaser || die "configure.py failed"

	einfo "Setting up build environment"
	source setpaths.sh

	einfo "Compiling phaser components"
	libtbx.scons -j ${nproc} || die "libtbx.scons failed"

	# Hardcoded /usr/bin does not look nice.  Should these files,
	# perhaps, be installed somewhere?
#	einfo "Creating env.csh"
#	cat >> "${T}"/env.csh <<- EOF
#	#! /bin/csh
#
#	setenv PHASER             /usr/bin
#	setenv PHASER_ENVIRONMENT 1
#	setenv PHASER_MTYPE       ${mtype}
#	setenv PHASER_MVERSION    ${mversion}
#	setenv PHASER_VERSION     ${PV}
#	EOF

#	einfo "Creating env.sh"
	cat >> "${T}"/53${PN} <<- EOF

	PHASER="/usr/bin"
	PHASER_ENVIRONMENT="1"
	PHASER_MTYPE="${mtype}"
	PHASER_MVERSION="${mversion}"
	PHASER_VERSION="${PV}"
	EOF

	doenvd "${T}"/53${PN}
}

# Why do some tests say that CNS and SHELX is not available?  Same for
# cctbx ebuild tests.
src_test() {
	cd "${S}//build" && \
	source setpaths.sh && \
	csh ./run_tests.csh || die "run_test.csh failed"
}

# This is a bit thin.  Maybe install other files from the distribution
# as well?
src_install() {
	dobin build/exe/phaser || die
}
