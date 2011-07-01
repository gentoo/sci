# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# boinc support is BROKEN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

EAPI="2"

inherit eutils multilib versionator

MY_P="${PN}$(get_major_version)_source"

DESCRIPTION="Prediction and design of protein structures, folding mechanisms, and protein-protein interactions"
HOMEPAGE="http://www.rosettacommons.org/"
SRC_URI="${MY_P}.tgz"

LICENSE="|| ( rosetta-academic rosetta-commercial )"
SLOT="0"
KEYWORDS=""
IUSE="boinc boost debug doc mpi X"
RESTRICT="fetch"

RDEPEND="mpi? ( virtual/mpi )
	boinc? ( sci-misc/boinc[X?] )
	boost? ( dev-libs/boost )
	sci-libs/rosetta-db"
DEPEND="${RDEPEND}
	>=dev-util/scons-0.96.1
	doc? ( app-doc/doxygen )
	X? ( media-libs/freeglut )"

MYCONF=""

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

pkg_setup() {
	use mpi && use boinc && \
	die "you can either use mpi or boinc support"
}

src_prepare() {
	local myCXXFLAGS
	local myLDFLAGS

	epatch "${FILESDIR}"/${PV}-platform.patch
	epatch "${FILESDIR}"/${PV}-fix-scons-warnings.patch
	epatch "${FILESDIR}"/${PV}-user-settings.patch
	epatch "${FILESDIR}"/${PV}-fix-valgrind.patch
	epatch "${FILESDIR}"/${PV}-boinc.patch
	rm bin/* -fv

	for i in ${CXXFLAGS}; do
		myCXXFLAGS="${myCXXFLAGS} \"${i/-/}\","
	done

	for i in ${LDFLAGS}; do
		myLDFLAGS="${myLDFLAGS} \"${i/-/}\","
	done

	sed -e "s:GENTOO_CXXFLAGS:${myCXXFLAGS}:g" \
		-e "s:GENTOO_LDFLAGS:${myCXXFLAGS} ${myLDFLAGS}:g" \
		-e "s:GENTOO_LIBDIR:$(get_libdir):g" \
		-i tools/build/user.settings

	use mpi && \
	sed -e 's:mpiCC:mpicxx:g' \
		-i tools/build/basic.settings
}

src_configure() {
	local myextras=""
	local mymode=""
	local mycxx=""

	use boinc  && EXTRAS="boinc"
	use boost && EXTRAS=$(my_list_append "${EXTRAS}" "boost")
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

	MAKEOPTS=$(my_filter_option "${MAKEOPTS}" "--load-average[=0-9.]*")
	MAKEOPTS=$(my_filter_option "${MAKEOPTS}" "-l[0-9.]*")

	MYCONF="${MAKEOPTS} mode=${mymode} ${myextras} ${mycxx}"
}

src_compile() {
	einfo "running 'scons bin cat=src ${MYCONF}' ..."
	scons bin cat=src ${MYCONF} || die "scons bin cat=src ${MYCONF} failed"

	if use doc; then
		einfo "running 'scons ${MYCONF} cat=doc' ..."
		scons ${MYCONF} cat=doc || die "scons failed to build documentation"
	fi
}

src_install() {
	local BIT

	use amd64 && BIT="64"
	use x86 && BIT="32"

	dolib.so build/src/release/linux/2.6/${BIT}/x86/${COMPILER}/${EXTRAS//,/-}/*.so || \
	die "failed to install libs"

	if use doc; then
	   dohtml build/doc/rosetta++/docs/* || die "could not install docs"
	fi

	cd bin
	for BIN in *; do
		newbin ${BIN} ${BIN%%.*} || die "could not install rosetta program files"
	done

	mv "${D}"/usr/bin/cluster{,-${PN}}
	mv "${D}"/usr/bin/benchmark{,-${PN}}
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
