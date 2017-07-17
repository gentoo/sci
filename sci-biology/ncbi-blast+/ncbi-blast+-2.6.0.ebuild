# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib python-single-r1 toolchain-funcs

MY_PV="2.3.0"
MY_P="ncbi-blast-${PV}+-src"
# workdir/ncbi-blast-2.2.30+-src
# ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.30/ncbi-blast-2.2.30+-src.tar.gz
# ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.3.0+-src.tar.gz

DESCRIPTION="A subset of NCBI C++ Toolkit containing just the NCBI BLAST+"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=toolkit"
SRC_URI="
	ftp://ftp.ncbi.nih.gov/blast/executables/blast+/${PV}/${MY_P}.tar.gz"
#	http://dev.gentoo.org/~jlec/distfiles/${PN}-${PV#0.}-asneeded.patch.xz"

# should also install ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz
# see http://www.biostars.org/p/76551/ and http://blastedbio.blogspot.cz/2012/05/blast-tabular-missing-descriptions.html
LICENSE="public-domain"
SLOT="0"
IUSE="
	debug static-libs static threads pch
	test wxwidgets odbc
	berkdb boost bzip2 cppunit curl expat fltk freetype gif
	glut gnutls hdf5 icu jpeg lzo mesa mysql muparser opengl pcre png python
	sablotron sqlite tiff xerces xalan xml xpm xslt X"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
#KEYWORDS=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# sys-libs/db should be compiled with USE=cxx
DEPEND="
	!sci-biology/ncbi-tools++
	!sci-biology/sra_sdk
	berkdb? ( sys-libs/db:4.3[cxx] )
	boost? ( dev-libs/boost )
	curl? ( net-misc/curl )
	sqlite? ( dev-db/sqlite:3 )
	mysql? ( virtual/mysql )
	fltk? ( x11-libs/fltk )
	opengl? ( virtual/opengl media-libs/glew:0= )
	mesa? ( media-libs/mesa[osmesa] )
	glut? ( media-libs/freeglut )
	freetype? ( media-libs/freetype )
	gnutls? ( net-libs/gnutls )
	python? ( ${PYTHON_DEPS} )
	cppunit? ( dev-util/cppunit )
	icu? ( dev-libs/icu )
	expat? ( dev-libs/expat )
	sablotron? ( app-text/sablotron )
	xml? ( dev-libs/libxml2 )
	xslt? ( dev-libs/libxslt )
	xerces? ( dev-libs/xerces-c )
	xalan? ( dev-libs/xalan-c )
	muparser? ( dev-cpp/muParser )
	hdf5? ( sci-libs/hdf5[cxx] )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg:0= )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	xpm? ( x11-libs/libXpm )
	dev-libs/lzo
	app-arch/bzip2
	dev-libs/libpcre"
# USE flags which should be added somehow: wxWindows wxWidgets SP ORBacus ODBC OEChem sge
# Intentionally omitted USE flags:
#   ftds? ( dev-db/freetds ) # support for outside FreeTDS installations is currently broken.
#                              The default (heavily patched) embedded copy should work, or you can
#                              leave it off altogether -- the only public apps that make use of it are
#                              samples and tests, since NCBI's database servers are of course firewalled.

# seems muParser is required, also glew is required. configure exits otherwise if these are explicitly passed to it (due to USE flag enabled)

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/c++"
# ncbi-blast-2.2.30+-src/c++

src_prepare() {
#	filter-ldflags -Wl,--as-needed
#	append-ldflags -Wl,--no-undefined
#	sed -i -e 's/-print-file-name=libstdc++.a//' \
#		-e '/sed/ s/\([gO]\[0-9\]\)\*/\1\\+/' \
#		src/build-system/configure || die
#	epatch \
#		"${FILESDIR}"/${PN}-${PV#0.}-fix-order-of-libs.patch \
#		"${FILESDIR}"/curl-types.patch \
#		"${FILESDIR}"/malloc_initialize_upstream_fix.patch \
#		"${FILESDIR}"/respect_CXXFLAGS_configure.ac.patch \
#		"${FILESDIR}"/respect_CXXFLAGS_configure.patch \
#		"${FILESDIR}"/report_project_settings_configure.ac.patch \
#		"${FILESDIR}"/report_project_settings_configure.patch \
#		"${FILESDIR}"/make_install.patch

#		"${FILESDIR}"/${PN}-${PV#0.}-disable_test_compress.patch

#		"${FILESDIR}"/${PN}-${PV#0.}-gcc46.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-gcc47.patch \
#		"${WORKDIR}"/${PN}-${PV#0.}-asneeded.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-libpng15.patch \
#		"${FILESDIR}"/${PN}-${PV#0.}-glibc-214.patch

#	use prefix && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/${PN}"

# The conf-opts.patch and as-needed.patch need to be adjusted for 12.0.0 line numbers
##	local PATCHES=(
##		"${FILESDIR}"/${P}-conf-opts.patch
##		"${FILESDIR}"/${P}-fix-svn-URL-upstream.patch
##		"${FILESDIR}"/${P}-linkage-tuneups.patch
##		"${FILESDIR}"/${P}-more-patches.patch
##		"${FILESDIR}"/${P}-linkage-tuneups-addons.patch
##		"${FILESDIR}"/${P}-configure.patch
##		"${FILESDIR}"/${P}-drop-STATIC-from-LIB.patch
##		"${FILESDIR}"/${P}-fix-install.patch
##		)
		# "${FILESDIR}"/${P}-support-autoconf-2.60.patch
##	epatch ${PATCHES[@]}

	# use a Debian patch from http://anonscm.debian.org/viewvc/debian-med/trunk/packages/ncbi-blast%2B/trunk/debian/patches/fix_lib_deps?revision=18535&view=markup
	# the patches for 2.2.30+ do not apply to 2.2.31, mostly DLL_LIB is gone but somewhere
	# it is still present, plus in a few places was something else patched
	# staying without any patches for now and lets see is it works on Gentoo
	# epatch "${FILESDIR}"/fix_lib_deps.patch
	# make sure this one is the last one and contains the actual patches applied unless we can have autoconf-2.59 or 2.60
	# https://bugs.gentoo.org/show_bug.cgi?id=514706

	tc-export CXX CC

##	cd src/build-system || die
#	eautoreconf

	# Temporarily disabling eautoconf because we patch configure via ${P}-support-autoconf-2.60.patch
	# eautoconf # keep it disabled until we can ensure 2.59 is installed
	# beware 12.0.0. and previous required autoconf-2.59, a patch for 12.0.0 brings autoconf-2.60 support
}

# possibly place modified contents of ${W}/src/build-system/config.site.ncbi and {W}/src/build-system/config.site.ex into ${W}/src/build-system/config.site
src_configure() {
	local myconf=()
	#--without-optimization  turn off optimization flags in non-debug mode
	#--with-profiling        build profiled versions of libs and apps
	#--with-tcheck(=DIR)     build for Intel Thread Checker (in DIR)
	#--with-plugin-auto-load always enable the plugin manager by default
	#--with-bundles          build bundles in addition to dylibs on Mac OS X
	#--with-bin-release      build executables suitable for public release
	#	no dll and such
	#--with-64               compile to 64-bit code
	#--with-universal        build universal binaries on Mac OS X
	#--with-universal=CPUs   build universal binaries targeting the given CPUs
	#--without-exe           do not build executables
	#--with-relative-runpath=P specify an executable-relative DLL search path
	#--with-hard-runpath     hard-code runtime path, ignoring LD_LIBRARY_PATH
	#--with-limited-linker   don't attempt to build especially large projects
	#--with-extra-action=    script to call after the configuration is complete
	#--with-autodep          automatic generation of dependencies (GNU make)
	#--with-fake-root=DIR    appear to have been built under DIR
	#--with-build-root-sfx=X add a user-specified suffix to the build dir name
	#--without-execopy       do not copy built executables to the BIN area
	#--with-lib-rebuilds     ensure that apps use up-to-date libraries
	#--with-lib-rebuilds=ask ask whether to update each app's libraries
	#--without-deactivation  keep old copies of libraries that no longer build
	#--without-makefile-auto-update  do not auto-update generated makefiles
	#--with-projects=FILE    build projects listed in FILE by default
	#--without-flat-makefile do not generate an all-encompassing flat makefile
	#--with-configure-dialog allow interactive flat makefile project selection
	#--with-saved-settings=F load configuration settings from the file F
	#--with-check-tools=...  use the specified tools for testing
	#--with-ncbi-public      ensure compatibility for all in-house platforms
	#--with-sybase-local=DIR use local SYBASE install (DIR is optional)
	#--with-sybase-new       use newer SYBASE install (12.5 rather than 12.0)
	#--without-sp            do not use SP libraries
	#--without-orbacus       do not use ORBacus CORBA libraries
	#--with-orbacus=DIR      use ORBacus installation in DIR
	#--with-jni(=JDK-DIR)    build Java bindings (against the JDK in JDK-DIR)
	#--with-sablot=DIR       use Sablotron installation in DIR
	#--without-sablot,       do not use Sablotron
	#--with-oechem=DIR       use OpenEye OEChem installation in DIR
	#--without-oechem        do not use OEChem
	#--with-sge=DIR          use Sun Grid Engine installation in DIR
	#--without-sge           do not use Sun Grid Engine
	#--with-magic=DIR        use libmagic installation in DIR
	#--without-magic         do not use libmagic
	#--without-local-lbsm    turn off support for IPC with locally running LBSMD
	#--without-ncbi-crypt    use a dummy stubbed-out version of ncbi_crypt
	#--without-connext       do not build non-public CONNECT library extensions
	#--without-serial        do not build the serialization library and tools
	#--without-objects       do not generate/build serializeable objects from ASNs
	#--without-dbapi         do not build database connectivity libraries
	#--without-app           do not build standalone applications like ID1_FETCH
	#--without-gui           do not build most graphical projects
	#--without-algo          do not build CPU-intensive algorithms
	#--without-internal      do not build internal projects
	#--with-gbench           ensure that Genome Workbench can be built
	#--without-gbench        do not build Genome Workbench
	myconf+=(
	--with-dll
	--with-lfs
	--with-build-root="${S}"_build
	--without-suffix
	--without-hostspec
	--without-version
	--with-bincopy
	--without-strip
	--without-ccache
	--without-distcc
#	--with-ncbi-c
	--without-ctools
#	--with-sss
#	--with-sssutils
#	--with-sssdb
#	--with-included-sss
	--with-z="${EPREFIX}/usr"
	--with-bz2="${EPREFIX}/usr"
	--without-sybase
	--with-autodep
#	--with-3psw=std:netopt favor standard (system) builds of the above pkgs
	$(use_with debug)
	$(use_with debug max-debug)
	$(use_with debug symbols)
	$(use_with static-libs static)
	$(use_with static static-exe)
	$(use_with threads mt)
	$(use_with prefix runpath "${EPREFIX}/usr/$(get_libdir)/${PN}")
	$(use_with test check)
	$(use_with pch)
	$(use_with lzo lzo "${EPREFIX}/usr")
	$(use_with pcre pcre "${EPREFIX}/usr")
	$(use_with gnutls gnutls "${EPREFIX}/usr")
	$(use_with mysql mysql "${EPREFIX}/usr")
	$(use_with muparser muparser "${EPREFIX}/usr")
	$(usex fltk --with-fltk="${EPREFIX}/usr" "")
	$(use_with opengl opengl "${EPREFIX}/usr")
	$(use_with mesa mesa "${EPREFIX}/usr")
	$(use_with opengl glut "${EPREFIX}/usr")
	$(use_with opengl glew "${EPREFIX}/usr")
	#
	# GLEW 2.0 dropped support for this, see https://bugs.gentoo.org/show_bug.cgi?id=611302
	# $(use_with opengl glew-mx)
	$(use_with wxwidgets wxwidgets "${EPREFIX}/usr")
	$(use_with wxwidgets wxwidgets-ucs)
	$(use_with freetype freetype "${EPREFIX}/usr")
#	$(use_with berkdb bdb "${EPREFIX}/usr") # not in ncbi-blast+
	$(usex odbc --with-odbc="${EPREFIX}/usr" "")
	$(use_with python python "${EPREFIX}/usr")
	$(use_with boost boost "${EPREFIX}/usr")
	$(use_with sqlite sqlite3 "${EPREFIX}/usr")
	$(use_with icu icu "${EPREFIX}/usr")
	$(use_with expat expat "${EPREFIX}/usr")
	$(use_with xml libxml "${EPREFIX}/usr")
	$(use_with xml libxslt "${EPREFIX}/usr")
	$(use_with xerces xerces "${EPREFIX}/usr")
	$(use_with hdf5 hdf5 "${EPREFIX}/usr")
	$(use_with xalan xalan "${EPREFIX}/usr")
#	$(use_with gif gif "${EPREFIX}/usr") # prevent compilation failure in "ncbi-tools++-12.0.0/src/util/image/image_io_gif.cpp:351: error: 'QuantizeBuffer' was not declared in this scope"
	--without-gif
	$(use_with jpeg jpeg "${EPREFIX}/usr")
	$(use_with tiff tiff "${EPREFIX}/usr")
	$(use_with png png "${EPREFIX}/usr")
	$(use_with xpm xpm "${EPREFIX}/usr")
	$(use_with curl curl "${EPREFIX}/usr")
#	$(use_with X x "${EPREFIX}/usr")
#	$(use_with X x) # there is no --with-x option
	# prevent downloading VDB sources from https://github.com/ncbi/ncbi-vdb.git during configure execution
	--without-vdb
	)

	# http://www.ncbi.nlm.nih.gov/books/NBK7167/
	use test ||	myconf+=( --with-projects="${FILESDIR}"/disable-testsuite-compilation.txt )

	# TODO
	# copy optimization -O options from CXXFLAGS to DEF_FAST_FLAGS and pass that also to configure
	# otherwise your -O2 will be dropped in some subdirectories and replaced by e.g. -O9

	einfo "bash ./src/build-system/configure --srcdir="${S}" --prefix="${EPREFIX}/usr" --libdir=/usr/lib64 ${myconf[@]}"

#	ECONF_SOURCE="src/build-system" \
#		econf \
	bash \
		./src/build-system/configure \
		--srcdir="${S}" \
		--prefix="${EPREFIX}/usr" \
		--libdir=/usr/lib64 \
		--with-flat-makefile \
		${myconf[@]} || die
#--without-debug \
#		--with-bin-release \
#		--with-bincopy \
#		--without-static \
#		--with-dll \
#		--with-mt \
#		--with-openmp \
#		--with-lfs \
#		--prefix="${ED}"/usr \
#		--libdir="${ED}"/usr/$(get_libdir)/"${PN}" \
#		${myconf} LDFLAGS="-Wl,--no-as-needed" \
#		|| die
#	econf ${myconf[@]}
}

src_compile() {
	## all_r would ignore the --with-projects contents and build more
	## emake all_r -C GCC*-Release*/build || die
	## all_p with compile only selected/required components
	##cd "${S}"_build &&\
	##emake all_p -C GCC*-Release*/build || die "gcc-4.5.3 crashes at src/objects/valerr/ValidError.cpp:226:1: internal compiler error: Segmentation fault, right?"
	#emake all_p -C "${S}"_build/build

	#
	# Re: /usr/lib64/ncbi-tools++/libdbapi_driver.so: undefined reference to `ncbi::NcbiGetlineEOL(std::istream&, std::string&)'
	#
	# The next release should automatically address such underlinking, albeit
	# only in --with-flat-makefile configurations.  For now (12.0.0), you'll need to
	# add or extend more DLL_LIB settings, to which end you may find the
	# resources at http://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/depgraphs/
	# helpful.  For instance,
	#
	# http://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/depgraphs/dbapi_driver.html
	#
	# indicates that src/dbapi/driver/Makefile.dbapi_driver.lib should set
	#
	# DLL_LIB = xncbi
	#
	# (You can find the path to that makefile by examining
	# .../status/.dbapi_driver.dep or .../build/Makefile.flat.)
	#
	# To take full advantage of --with-flat-makefile, you'll need the following (instead of 'emake all_p -C "${S}"_build/build') and call configure --with-flat-makefile:
	emake -C "${S}"_build/build -f Makefile.flat
}

src_install() {
	rm -rvf "${S}"_build/lib/ncbi || die
	emake install prefix="${ED}/usr" libdir="${ED}/usr/$(get_libdir)/${PN}"

#	dobin "${S}"_build/bin/*
#	dolib.so "${S}"_build/lib/*so*
#	dolib.a "${S}"_build/lib/*.a
#	doheader "${S}"_build/inc/*

	# File collisions with sci-biology/ncbi-tools
	mv "${ED}"/usr/bin/asn2asn "${ED}"/usr/bin/asn2asn+
	mv "${ED}"/usr/bin/rpsblast "${ED}"/usr/bin/rpsblast+
	mv -f "${ED}"/usr/bin/test_regexp "${ED}"/usr/bin/test_regexp+ # drop the eventually mistakenly compiled binaries
	mv "${ED}"/usr/bin/vecscreen "${ED}"/usr/bin/vecscreen+
	mv "${ED}"/usr/bin/seedtop "${ED}"/usr/bin/seedtop+

	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${PN}" > ${S}/99${PN}
	doenvd "${S}/99${PN}"
}

pkg_postinst() {
	einfo 'Please run "source /etc/profile" before using this package in the current shell.'
	einfo 'Documentation is at http://www.ncbi.nlm.nih.gov/books/NBK7167/'
}
