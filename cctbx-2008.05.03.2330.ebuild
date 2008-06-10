# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs python eutils

MY_PV="${PV//./_}"
DESCRIPTION="Computational Crystallography Toolbox"
HOMEPAGE="http://cctbx.sourceforge.net/"
#SRC_URI="mirror://gentoo/cctbx_bundle-${PV}.tar.gz"
SRC_URI="http://gentoo.j-schmitz.net/portage/distfiles/${CATEGORY}/${PN}/${P}.tar.gz"
LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND=""
DEPEND="dev-util/scons"
RESTRICT="mirror"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PV}-config.py.patch
}

src_compile() {
	python_version

	MAKEOPTS_EXP=${MAKEOPTS/j/j }

	# Get CXXFLAGS in format suitable for substitition into SConscript
	for i in ${CXXFLAGS}; do
		OPTS="${OPTS} \"${i}\","
	done

	# Strip off the last comma
	OPTS=${OPTS%,}

	# Fix CXXFLAGS
	sed -i \
		-e "s:\"-O3\", \"-ffast-math\":${OPTS}:g" \
		${MY_S}/libtbx/SConscript

	# Get compiler in the right way
	COMPILER=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')

	${python} "${MY_S}/libtbx/libtbx/command_line/py_compile_all.py"

	mkdir "${S}"/cctbx_build
	cd "${S}"/cctbx_build
	${python} "${MY_S}"/libtbx/configure.py \
		--compiler=$COMPILER \
		--current_working_directory="${S}"/cctbx_build \
		--build=release \
		mmtbx \
		|| die "configure failed"
	source setpaths_all.sh
	libtbx.scons ${MAKEOPTS_EXP} .|| die "make failed"
}

src_test(){
	source "${MY_B}"/setpaths_all.sh
	libtbx.python $(libtbx.show_dist_paths boost_adaptbx)/tst_rational.py && \
	libtbx.python $SCITBX_DIST/run_tests.py ${MAKEOPTS_EXP} && \
	libtbx.python $CCTBX_DIST/run_tests.py  ${MAKEOPTS_EXP} \
	|| die "test failed"
}

#src_install() {
#	insinto /usr/$(get_libdir)/cctbx
#	doins -r "${MY_B}"/{lib,setpaths*}
#	insinto /usr/include
#	doins -r "${MY_B}"/include/*
#	exeinto /usr/$(get_libdir)/cctbx/bin
#	doexe "${MY_B}"/bin/*
#
#	sed -e "s:${MY_S}/libtbx:/usr/$(get_libdir)/cctbx:g" \
#		-e "s:${MY_B}//usr/$(get_libdir)/cctbx:g" \
#		-i "${MY_B}"/setpaths.sh
#
#	sed -e "s:${MY_S}/libtbx:/usr/$(get_libdir)/cctbx:g" \
#		-e "s:${MY_B}//usr/$(get_libdir)/cctbx:g" \
#		-i "${MY_B}"/setpaths.csh
#
#	insinto /etc/profile.d/
#	newins "${MY_B}"/setpaths.sh 30setpaths.sh
#	newins "${MY_B}"/setpaths.csh 30setpaths.csh
#}

src_install(){
	dodir /usr/share/${P}
	cp -r cctbx_build/* "${D}"/usr/share/${P}/
}
