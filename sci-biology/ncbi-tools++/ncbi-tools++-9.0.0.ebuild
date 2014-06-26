# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils flag-o-matic multilib toolchain-funcs

MY_TAG="Jun_15_2010"
MY_Y="${MY_TAG/*_/}"
MY_PV="9_0_0"
MY_P="ncbi_cxx--${MY_PV}"
#ftp://ftp.ncbi.nlm.nih.gov/toolbox/ncbi_tools++/ARCHIVE/9_0_0/ncbi_cxx--9_0_0.tar.gz

DESCRIPTION="NCBI C++ Toolkit, including NCBI BLAST+"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=toolkit"
SRC_URI="
	ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/ARCHIVE/${MY_PV}/ncbi_cxx--${MY_PV}.tar.gz"
#	http://dev.gentoo.org/~jlec/distfiles/${PN}-${PV#0.}-asneeded.patch.xz"

# should also install ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz
# see http://www.biostars.org/p/76551/ and http://blastedbio.blogspot.cz/2012/05/blast-tabular-missing-descriptions.html

LICENSE="public-domain"
SLOT="0"
IUSE="berkdb boost bzip2 cppunit curl expat fastcgi fltk freetype gif glut gnutls hdf5 icu jpeg lzo mesa mysql muparser opengl pcre png python sablotron sqlite sqlite3 tiff xerces xalan xml xpm xslt X"
#KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
KEYWORDS=""

# sys-libs/db should be compiled with USE=cxx
DEPEND="berkdb? ( sys-libs/db:4.3 )
	boost? ( dev-libs/boost )
	curl? ( net-misc/curl )
	sqlite? ( dev-db/sqlite )
	sqlite3? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	gnutls? ( net-libs/gnutls )
	fltk? ( x11-libs/fltk )
	opengl? ( virtual/opengl )
	mesa? ( media-libs/mesa )
	glut? ( media-libs/freeglut )
	freetype? ( media-libs/freetype )
	fastcgi? ( www-apache/mod_fastcgi )
	python? ( dev-lang/python )
	cppunit? ( dev-util/cppunit )
	icu? ( dev-libs/icu )
	expat? ( dev-libs/expat )
	sablotron? ( app-text/sablotron )
	xml? ( dev-libs/libxml2 )
	xslt? ( dev-libs/libxslt )
	xerces? ( dev-libs/xerces-c )
	xalan? ( dev-libs/xalan-c )
	muparser? ( dev-cpp/muParser )
	hdf5? ( sci-libs/hdf5 )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	xpm? ( x11-libs/libXpm )
	lzo? ( dev-libs/lzo )
	app-arch/bzip2
	dev-libs/libpcre"
# USE flags which should be added somehow: wxWindows wxWidgets SP ORBacus ODBC OEChem sge
# Intentionally omitted USE flags:
#   ftds? ( dev-db/freetds ) # useless, no real apps use it outside NCBI

# configure options, may want to expose some
#  --without-debug         build non-debug versions of libs and apps
#  --without-optimization  turn off optimization flags in non-debug mode
#  --with-profiling        build profiled versions of libs and apps
#  --with-tcheck(=DIR)     build for Intel Thread Checker (in DIR)
#  --with-dll              build all libraries as DLLs
#  --with-static           build all libraries statically even if --with-dll
#  --with-static-exe       build all executables as statically as possible
#  --with-plugin-auto-load always enable the plugin manager by default
#  --with-bin-release      build executables suitable for public release
#  --with-mt               compile in a MultiThread-safe manner
#  --with-64               compile to 64-bit code
#  --with-universal        build universal binaries on Mac OS X
#  --with-universal=CPUs   build universal binaries targeting the given CPUs
#  --without-exe           do not build executables
#  --with-runpath=         hard-code the runtime path to DLLs
#  --with-lfs              enable large file support to the extent possible
#  --with-extra-action=    script to call after the configuration is complete
#  --with-autodep          automatic generation of dependencies (GNU make)
#  --with-build-root=DIR   specify a non-default build directory name
#  --with-fake-root=DIR    appear to have been built under DIR
#  --without-suffix        no Release/Debug, MT or DLL sfx in the build dir name
#  --with-hostspec         add full host specs to the build dir name
#  --without-version       don't always include the cplr ver in the bd name
#  --with-build-root-sfx=X add a user-specified suffix to the build dir name
#  --without-execopy       do not copy built executables to the BIN area
#  --with-bincopy          populate lib and bin with copies, not hard links
#  --with-lib-rebuilds     ensure that apps use up-to-date libraries
#  --with-lib-rebuilds=ask ask whether to update each app's libraries
#  --without-deactivation  keep old copies of libraries that no longer build
#  --without-makefile-auto-update  do not auto-update generated makefiles
#  --with-projects=FILE    build projects listed in FILE by default
#  --without-flat-makefile do not generate an all-encompassing flat makefile
#  --with-configure-dialog allow interactive flat makefile project selection
#  --with-saved-settings=F load configuration settings from the file F
#  --with-check            run test suite after the build
#  --with-check-tools=...  use the specified tools for testing
#  --with-ncbi-public      ensure compatibility for all in-house platforms
#  --with-strip            strip binaries at build time
#  --with-pch              use precompiled headers if possible
#  --with-caution          cancel configuration unconditionally when in doubt
#  --without-caution       proceed without asking when in doubt
#  --without-ccache        do not automatically use ccache if available
#  --without-distcc        do not automatically use distcc if available
#  --without-ncbi-c        do not use NCBI C Toolkit
#  --without-sss           do not use NCBI SSS libraries
#  --without-utils         do not use NCBI SSS UTIL library
#  --without-sssdb         do not use NCBI SSS DB library
#  --with-included-sss     use the in-tree copy of SSS

#  --without-local-lbsm    turn off support for IPC with locally running LBSMD
#  --without-ncbi-crypt    use a dummy stubbed-out version of ncbi_crypt
#  --without-connext       do not build non-public CONNECT library extensions
#  --without-serial        do not build the serialization library and tools
#  --without-objects       do not generate/build serializeable objects from ASNs
#  --without-dbapi         do not build database connectivity libraries
#  --without-app           do not build standalone applications like ID1_FETCH
#  --without-ctools        do not build NCBI C Toolkit based projects
#  --without-gui           do not build most graphical projects
#  --without-algo          do not build CPU-intensive algorithms
#  --without-internal      do not build internal projects
#  --with-gbench           ensure that Genome Workbench can be built
#  --without-gbench        do not build Genome Workbench

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	filter-ldflags -Wl,--as-needed
#	append-ldflags -Wl,--no-undefined
	sed -i -e 's/-print-file-name=libstdc++.a//' \
		-e '/sed/ s/\([gO]\[0-9\]\)\*/\1\\+/' \
		src/build-system/configure || die
	epatch \
		"${FILESDIR}"/${PN}-${PV#0.}-fix-order-of-libs.patch \
		"${FILESDIR}"/curl-types.patch \
		"${FILESDIR}"/malloc_initialize_upstream_fix.patch \
		"${FILESDIR}"/respect_CXXFLAGS_configure.ac.patch \
		"${FILESDIR}"/respect_CXXFLAGS_configure.patch \
		"${FILESDIR}"/report_project_settings_configure.ac.patch \
		"${FILESDIR}"/report_project_settings_configure.patch \
		"${FILESDIR}"/make_install.patch

#		"${FILESDIR}"/${PN}-${PV#0.}-disable_test_compress.patch

#		"${FILESDIR}"/${PN}-${PV#0.}-gcc46.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-gcc47.patch \
#		"${WORKDIR}"/${PN}-${PV#0.}-asneeded.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-libpng15.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-glibc-214.patch

	use prefix && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/${PN}"
}

src_configure() {
	tc-export CXX CC
	# the use flag test below are for those which allow to enable or disable the package usage (unlike those cases which either allow or not use of internal, built-in copy of some mostly library, e.g. zlib, boost)
# conf check for sqlite and mysql
	local myconf=""
	if use berkdb; then
		myconf="--with-bdb"
	else
		myconf="--without-bdb"
	fi
	if ! use curl; then
		myconf="--without-curl"
	fi
	if use gnutls; then
		myconf="--with-gnutls"
	else
		myconf="--without-gnutls"
	fi
	if ! use sqlite; then
		myconf="--without-sqlite"
	fi
	if ! use sqlite3; then
		myconf="--without-sqlite3"
	fi
	if ! use mysql; then
		myconf="--without-mysql"
	fi
	if ! use fltk; then
		myconf="--without-fltk"
	fi
	if ! use opengl; then
		myconf="--without-opengl"
	fi
	if ! use mesa; then
		myconf="--without-mesa"
	fi
	if ! use glut; then
		myconf="--without-glut"
	fi
	if ! use freetype; then
		myconf="--without-freetype"
	fi
	if ! use fastcgi; then
		myconf="--without-fastcgi"
	fi
	if ! use python; then
		myconf="--without-python"
	fi
	if ! use cppunit; then
		myconf="--without-cppunit"
	fi
	if ! use icu; then
		myconf="--without-icu"
	fi
	if ! use expat; then
		myconf="--without-expat"
	fi
	if ! use sablotron; then
		myconf="--without-sablotron"
	fi
	if ! use xml; then
		myconf="--without-xml"
	fi
	if ! use xslt; then
		myconf="--without-xslt"
	fi
	if ! use xerces; then
		myconf="--without-xerces"
	fi
	if ! use xalan; then
		myconf="--without-xalan"
	fi
	if ! use muparser; then
		myconf="--without-muparser"
	fi
	if ! use hdf5; then
		myconf="--without-hdf5"
	fi
	if ! use gif; then
		myconf="--without-gif"
	fi
	if ! use jpeg; then
		myconf="--without-jpeg"
	fi
	if ! use png; then
		myconf="--without-png"
	fi
	if ! use tiff; then
		myconf="--without-tiff"
	fi
	if ! use xpm; then
		myconf="--without-xpm"
	fi
	if ! use X; then
		myconf="--without-gui --without-x"
	fi

	# http://www.ncbi.nlm.nih.gov/books/NBK7167/
	if ! use test; then
		myconf="--with-projects="${FILESDIR}"/disable-testsuite-compilation.txt"
	fi

	# TODO
	# copy optimization -O options from CXXFLAGS to DEF_FAST_FLAGS and pass that also to configure
	# otherwise your -O2 will be dropped in some subdirectories and repalced by e.g. -O9

	"${S}"/configure --without-debug \
		--with-bin-release \
		--with-bincopy \
		--without-static \
		--with-dll \
		--with-mt \
		--with-lfs \
		--prefix="${ED}"/usr \
		--libdir="${ED}"/usr/$(get_libdir)/"${PN}" \
		${myconf} LDFLAGS="-Wl,--no-as-needed" \
		|| die

	# --with-openmp
}

src_compile() {
	# all_r would ignore the --with-projects contents and build more
	# emake all_r -C GCC*-Release*/build || die
	# all_p with compile only selected/required components
	emake all_p -C GCC*-Release*/build || die "gcc-4.5.3 crashes at src/objects/valerr/ValidError.cpp:226:1: internal compiler error: Segmentation fault, right?"
}

src_install() {
	emake install || die
	# File collisions with sci-biology/ncbi-tools
	rm -f "${ED}"/usr/bin/{asn2asn,rpsblast,test_regexp}
	mv "${ED}"/usr/bin/seedtop "${ED}"/usr/bin/seedtop2

	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${PN}" > ${S}/99${PN}
	doenvd "${S}/99${PN}"
}

pkg_postinst() {
	einfo 'Please run "source /etc/profile" before using this package in the current shell.'
	einfo 'Documentation is at http://www.ncbi.nlm.nih.gov/books/NBK7167/'
}
