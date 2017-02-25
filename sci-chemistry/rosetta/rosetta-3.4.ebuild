# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# boinc support is BROKEN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EAPI=5

inherit eutils multilib prefix scons-utils toolchain-funcs versionator

#MY_P="${PN}$(get_major_version)_source"
MY_P="${PN}${PV}_source"

DESCRIPTION="Prediction of protein structures and protein-protein interactions"
HOMEPAGE="http://www.rosettacommons.org/"
SRC_URI="${MY_P}.tgz patch_rosetta3.4_to_CSROSETTA3_ver1.3.txt"

LICENSE="|| ( rosetta-academic rosetta-commercial )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="boinc +boost custom-cflags debug doc float +lange mpi +openmp X"

REQUIRED_USE="?? ( mpi boinc )"

RESTRICT="fetch"

RDEPEND="
	dev-db/cppdb
	mpi? ( virtual/mpi )
	boinc? ( sci-misc/boinc[X?] )
	boost? ( dev-libs/boost )
	sci-libs/rosetta-db"
DEPEND="${RDEPEND}
	dev-util/scons
	doc? ( app-doc/doxygen )
	X? ( media-libs/freeglut )"

MYCONF=""

S="${WORKDIR}/${PN}_source"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

src_prepare() {
	local myCXXFLAGS
	local myLDFLAGS

	use custom-cflags || \
		export CXXFLAGS="-O3 -ffast-math -funroll-loops -finline-functions -finline-limit=20000 -pipe"

	export LD_LIBRARY_PATH=""
	use lange && \
		epatch \
			"${DISTDIR}"/patch_${PN}${PV}_to_CSROSETTA3_ver1.3.txt \
			"${FILESDIR}"/${P}-lange-fix.patch

	epatch \
		"${FILESDIR}"/${P}-platform.patch \
		"${FILESDIR}"/${P}-user-settings.patch \
		"${FILESDIR}"/${P}-fix-valgrind.patch \
		"${FILESDIR}"/${P}-boinc.patch \
		"${FILESDIR}"/${P}-boost.patch \
		"${FILESDIR}"/${P}-boost157.patch \
		"${FILESDIR}"/${P}-gcc4.789.patch

	eprefixify tools/build/*

	rm bin/* external/{dbio,scons-local,lib} -rfv || die

	find external/boost_1_46_1 -name "*.hpp" -delete || die

	for i in ${CXXFLAGS}; do
		myCXXFLAGS="${myCXXFLAGS} \"${i/-/}\","
	done

	for i in ${LDFLAGS}; do
		myLDFLAGS="${myLDFLAGS} \"${i/-/}\","
	done

	sed \
		-e "s:GENTOO_CXXFLAGS:${myCXXFLAGS}:g" \
		-e "s:GENTOO_LDFLAGS:${myCXXFLAGS} ${myLDFLAGS}:g" \
		-e "s:GENTOO_LIBDIR:$(get_libdir):g" \
		-e "/program_path/s:#::g" \
		-i tools/build/user.settings || die

	tc-export CC CXX

	if use mpi; then
		sed \
			-e 's:mpiCC:mpicxx:g' \
			-i tools/build/basic.settings || die
		sed \
			-e "/cxx/d" \
			-i tools/build/user.settings || die
	fi
}

src_configure() {
	local myextras=""
	local mymode=""
	local mycxx=""

	use boinc && EXTRAS="boinc"
	use boost && EXTRAS=$(my_list_append "${EXTRAS}" "boost")
	use boost && EXTRAS=$(my_list_append "${EXTRAS}" "boost_thread")
	use float && EXTRAS=$(my_list_append "${EXTRAS}" "rosetta_float")
	use openmp && EXTRAS=$(my_list_append "${EXTRAS}" "omp")
	use X && EXTRAS=$(my_list_append "${EXTRAS}" "graphics")
	use mpi && EXTRAS=$(my_list_append "${EXTRAS}" "mpi")

	COMPILER=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
	mycxx="cxx=${COMPILER}"

	test -n "${EXTRAS}" && myextras="extras=${EXTRAS}"

	if use debug; then
		mymode="debug"
	else
		mymode="release"
	fi

	MYCONF="mode=${mymode} ${myextras} ${mycxx}"
}

src_compile() {
	einfo "running 'scons bin cat=src ${MYCONF}' ..."
	escons bin cat=src ${MYCONF}

	if use doc; then
		einfo "running 'scons ${MYCONF} cat=doc' ..."
		scons ${MYCONF} cat=doc || die "scons failed to build documentation"
	fi
}

src_install() {
	dolib.so build/src/release/linux/*/*/*/*/*/${EXTRAS//,/-}/*.so*

	use doc && dohtml build/doc/rosetta++/docs/*

	cd bin || die
	for BIN in *; do
		newbin ${BIN} ${BIN%%.*} || die "could not install rosetta program files"
	done

	if [[ -e "${ED}"/usr/bin/cluster ]]; then
		mv "${ED}"/usr/bin/cluster{,-${PN}} || die
	fi

	if [[ -e "${ED}"/usr/bin/benchmark ]]; then
		mv "${ED}"/usr/bin/benchmark{,-${PN}} || die
	fi
}

my_filter_option() {
	local value="$1"
	local exp="$2"
	local result=`echo ${value} | sed -e s/${exp}//g`
	echo "${result}"
	return 0;
}

my_list_append() {
	local old_value="$1"
	local new_value="$2"
	test -n "${old_value}" && old_value="${old_value},"
	echo "${old_value}${new_value}"
	return 0;
}
