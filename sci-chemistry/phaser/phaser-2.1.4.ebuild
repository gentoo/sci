# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python toolchain-funcs

DESCRIPTION="Phasing macromolecular crystal structures with maximum likelihood methods"
SRC_URI="ftp://ftp.ccp4.ac.uk/ccp4/6.1.1/${P}-cctbx-src.tar.gz"
HOMEPAGE="http://www-structmed.cimr.cam.ac.uk/phaser/"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~x86 ~amd64"
IUSE="openmp"

DEPEND="dev-util/scons"
RDEPEND="sci-libs/cctbx"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf lib/*
	cp -rf $CCP4/lib/cctbx/cctbx_sources/libtbx "${WORKDIR}"

	mkdir -p "${WORKDIR}"/scons/src/
	ln -sf /usr/$(get_libdir)/scons-1.2.0 "${WORKDIR}"/scons/src/engine || die

	epatch "${FILESDIR}"/${PV}-sadf.patch
}

src_compile(){
	python_version

	local MYCONF
	local MAKEOPTS_EXP
	local OPTS
	local OPTSLD

	MYCONF="${S}/libtbx/configure.py"

	MYCONF="${MYCONF} --repository ${S}/ccp4-6.1.1/src/${PN}/source --repository /usr/$(get_libdir)/cctbx/cctbx_sources/ \
	--build=release ccp4io=${CCP4}/$(get_libdir)/cctbx/cctbx_sources/ccp4io/"

	MAKEOPTS_EXP=${MAKEOPTS/j/j }
	MAKEOPTS_EXP=${MAKEOPTS_EXP%-l[0-9]*}

	# Get CXXFLAGS in format suitable for substitition into SConscript
	for i in ${CXXFLAGS}; do
	OPTS="${OPTS} \"${i}\","
	done

	# Strip off the last comma
	OPTS=${OPTS%,}

	# Fix CXXFLAGS
	sed -i \
	-e "s:opts = \[.*\]$:opts = \[${OPTS}\]:g" \
	"${S}"/libtbx/SConscript

	# Get LDFLAGS in format suitable for substitition into SConscript
	for i in ${LDFLAGS}; do
	OPTSLD="${OPTSLD} \"${i}\","
	done

	# Fix LDFLAGS which should be as-needed ready
	sed -i \
	-e "s:env_etc.shlinkflags .* \"-shared\":env_etc.shlinkflags = \[ ${OPTSLD} \"-shared\":g" \
	"${S}"/libtbx/SConscript

	# Get compiler in the right way
	COMPILER=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
	MYCONF="${MYCONF} --compiler=${COMPILER}"

	# Additional USE flag usage
	check_use openmp
	MYCONF="${MYCONF} --enable-openmp-if-possible=${USE_openmp}"
	use threads && USEthreads="--enable-boost-threads" && \
	ewarn "If using boost threads openmp support is disabled"

	MYCONF="${MYCONF} ${USE_threads} --scan-boost"

	MYCONF="${MYCONF} phaser"
	einfo "configuring with ${python} ${MYCONF}"

	${python} ${MYCONF} \
	|| die "configure failed"

	source setpaths_all.sh

	einfo "compiling with libtbx.scons ${MAKEOPTS_EXP}"
	libtbx.scons ${MAKEOPTS_EXP} .|| die "make failed"
}

src_install() {
	rm lib/libboost*
	dolib.so lib/*.so || die
	dolib.a lib/*.a || die
	dobin exe/phaser || die
}

check_use() {

	for var in $@; do
	if use ${var}; then
	printf -v "USE_$var" True
	else
	printf -v "USE_$var" False

	fi
	shift
	done
}
