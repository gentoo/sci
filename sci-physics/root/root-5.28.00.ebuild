# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RUBY_OPTIONAL="yes"
USE_RUBY="ruby18"

inherit versionator eutils elisp-common fdo-mime python toolchain-funcs flag-o-matic

#DOC_PV=$(get_major_version)_$(get_version_component_range 2)
DOC_PV=5_26
ROOFIT_DOC_PV=2.91-33
TMVA_DOC_PV=4.03

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
HOMEPAGE="http://root.cern.ch/"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? (
		ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf
		ftp://root.cern.ch/root/doc/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf
		http://tmva.sourceforge.net/docu/TMVAUsersGuide.pdf -> TMVAUsersGuide-v${TMVA_DOC_PV}.pdf )"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="afs avahi clarens doc emacs examples fits fftw graphviz kerberos ldap llvm
	+math mysql	ncurses odbc +opengl openmp oracle postgres pythia6 pythia8 python
	+reflex	ruby qt4 ssl xft xml xinetd xrootd"

# libafterimage ignored, to check every version
# see https://savannah.cern.ch/bugs/?func=detailitem&item_id=30944
#	|| ( >=media-libs/libafterimage-1.18 x11-wm/afterstep )
CDEPEND=">=dev-lang/cfortran-4.4-r2
	dev-libs/libpcre
	media-libs/ftgl
	media-libs/giflib
	media-libs/glew
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff
	sys-apps/shadow
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXpm
	afs? ( >=net-fs/openafs-1.4.7 )
	avahi? ( net-dns/avahi )
	clarens? ( dev-libs/xmlrpc-c )
	emacs? ( virtual/emacs )
	fits? ( sci-libs/cfitsio )
	fftw? ( sci-libs/fftw:3.0 )
	graphviz? ( media-gfx/graphviz )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	llvm? ( sys-devel/llvm )
	math? ( sci-libs/gsl sci-mathematics/unuran )
	mysql? ( virtual/mysql )
	ncurses? ( sys-libs/ncurses )
	odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	opengl? ( virtual/opengl virtual/glu )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql-base )
	pythia6? ( sci-physics/pythia:6 )
	pythia8? ( sci-physics/pythia:8 )
	qt4? ( x11-libs/qt-gui:4
		x11-libs/qt-opengl:4
		x11-libs/qt-qt3support:4
		x11-libs/qt-svg:4
		x11-libs/qt-webkit:4
		x11-libs/qt-xmlpatterns:4 )
	ruby? ( dev-lang/ruby
			dev-ruby/rubygems )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig"

RDEPEND="${CDEPEND}
	reflex? ( dev-cpp/gccxml )
	xinetd? ( sys-apps/xinetd )"

S="${WORKDIR}/${PN}"

pkg_setup() {
	elog
	elog "You may want to build ROOT with these non Gentoo extra packages:"
	elog "AliEn, castor, Chirp, dCache, gfal, gLite, Globus,"
	elog "HDFS, Monalisa, MaxDB/SapDB, SRP."
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "For example, for SRP, you would set: "
	elog "EXTRA_ECONF=\"--enable-srp --with-srp-libdir=/usr/$(get_libdir)\""
	elog
	enewgroup rootd
	enewuser rootd -1 -1 /var/spool/rootd rootd

	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp; then
		ewarn "You are using gcc and OpenMP is available with gcc >= 4.2"
		ewarn "If you want to build this package with OpenMP, abort now,"
		ewarn "and set CC to an OpenMP capable compiler"
	elif use openmp; then
		export USE_OPENMP=1
		use math && export USE_PARALLEL_MINUIT2=1
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with the src path
	default
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-prop-ldflags.patch \
		"${FILESDIR}"/${P}-configure-paths.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-nobyte-compile.patch \
		"${FILESDIR}"/${P}-glibc212.patch \
		"${FILESDIR}"/${P}-xrootd-prop-flags.patch \
		"${FILESDIR}"/${P}-unuran.patch

	# use system cfortran
	rm montecarlo/eg/inc/cfortran.h README/cfortran.doc

	# in gentoo, libPythia6 is called libpythia6
	# libungif is called libgif
	sed -i \
		-e 's/libPythia6/libpythia6/g' \
		-e 's/ungif/gif/g' \
		configure || die "adjusting library names failed"

	# libafterimage flags are hardcoded
	sed -i \
		-e 's/CFLAGS="-O3"//' \
		-e 's/CFLAGS=$$ACFLAGS//' \
		graf2d/asimage/Module.mk graf2d/asimage/src/libAfterImage/configure \
		|| die "flag propagation in libafterimage failed"

	# prefixify the configure script
	sed -i \
		-e 's:/usr:${EPREFIX}/usr:g' \
		configure || die "prefixify configure failed"

	# QTDIR only used for qt3 in gentoo, and configure looks for it.
	unset QTDIR
}

src_configure() {
	# the configure script is not the standard autotools
	./configure \
		--prefix="${EPREFIX}"/usr \
		--etcdir="${EPREFIX}"/etc \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/${PN} \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--tutdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tutorials \
		--testdir="${EPREFIX}"/usr/share/doc/${PF}/examples/tests \
		--with-cc=$(tc-getCC) \
		--with-cxx=$(tc-getCXX) \
		--with-f77=$(tc-getFC) \
		--with-sys-iconpath="${EPREFIX}"/usr/share/pixmaps \
		--disable-builtin-freetype \
		--disable-builtin-ftgl \
		--disable-builtin-glew \
		--disable-builtin-pcre \
		--disable-builtin-zlib \
		--disable-rpath \
		--enable-asimage \
		--enable-astiff \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-gdml \
		--enable-memstat \
		--enable-shadowpw \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		--fail-on-missing \
		--with-afs-shared=yes \
		$(use_enable afs) \
		$(use_enable avahi bonjour) \
		$(use_enable clarens) \
		$(use_enable clarens peac) \
		$(use_enable ncurses editline) \
		$(use_enable fits fitsio) \
		$(use_enable fftw fftw3) \
		$(use_enable graphviz gviz) \
		$(use_enable kerberos krb5) \
		$(use_enable ldap) \
		$(use_enable llvm cling) \
		$(use_enable math gsl-shared) \
		$(use_enable math genvector) \
		$(use_enable math mathmore) \
		$(use_enable math minuit2) \
		$(use_enable math roofit) \
		$(use_enable math tmva) \
		$(use_enable math unuran) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable opengl) \
		$(use_enable postgres pgsql) \
		$(use_enable pythia6) \
		$(use_enable pythia8) \
		$(use_enable python) \
		$(use_enable qt4 qt) \
		$(use_enable qt4 qtgsi) \
		$(use_enable reflex cintex) \
		$(use_enable reflex) \
		$(use_enable ruby) \
		$(use_enable ssl) \
		$(use_enable xft) \
		$(use_enable xml) \
		$(use_enable xrootd) \
		${EXTRA_ECONF} \
		|| die "configure failed"
}

src_compile() {
	emake OPT="${CFLAGS}" F77OPT="${FFLAGS}" || die "emake failed"
	if use emacs; then
		elisp-compile build/misc/*.el || die "elisp-compile failed"
	fi
}

doc_install() {
	cd "${S}"
	if use doc; then
		einfo "Installing user's guides"
		insinto /usr/share/doc/${PF}
		doins \
			"${DISTDIR}"/Users_Guide_${DOC_PV}.pdf \
			"${DISTDIR}"/TMVAUsersGuide-v${TMVA_DOC_PV}.pdf \
			|| die "pdf install failed"
		if use math; then
			doins "${DISTDIR}"/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf \
				|| die "math doc install failed"
		fi
	fi

	if use examples; then
		# these should really be taken care of by the root make install
		insinto /usr/share/doc/${PF}/examples/tutorials/tmva
		doins -r tmva/test || die
	else
		rm -rf "${D}"/usr/share/doc/${PF}/examples
	fi
}

daemon_install() {
	cd "${S}"
	local daemons="rootd proofd"
	dodir /var/spool/rootd
	fowners rootd:rootd /var/spool/rootd
	dodir /var/spool/rootd/{pub,tmp}
	fperms 1777 /var/spool/rootd/{pub,tmp}

	use xrootd && daemons="${daemons} xrootd olbd"
	for i in ${daemons}; do
		newinitd "${FILESDIR}"/${i}.initd ${i}
		newconfd "${FILESDIR}"/${i}.confd ${i}
	done
	if use xinetd; then
		insinto /etc/xinetd
		doins etc/daemons/{rootd,proofd}.xinetd || die
	fi
}

desktop_install() {
	cd "${S}"
	sed -e 's,@prefix@,/usr,' \
		build/package/debian/root-system-bin.desktop.in > root.desktop
	domenu root.desktop
	doicon "${S}"/build/package/debian/root-system-bin.png

	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins build/package/debian/application-x-root.png

	insinto /usr/share/icons/hicolor/48x48/apps
	doicon build/package/debian/root-system-bin.xpm
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/root" > 99root
	use pythia8 && echo "PYTHIA8=${EPREFIX}/usr" >> 99root
	doenvd 99root || die "doenvd failed"

	# The build system installs Emacs support unconditionally and in the wrong
	# directory. Remove it and call elisp-install in case of USE=emacs.
	rm -rf "${ED}"/usr/share/emacs
	if use emacs; then
		elisp-install ${PN} build/misc/*.{el,elc} || die "elisp-install failed"
	fi

	doc_install
	daemon_install
	desktop_install

	if use python; then
		local pydir=$(python_get_sitedir)
		dodir $(pydir)
		mv "${ED}"usr/$(get_libdir)/${PN}/*.py \
			"${ED}"$(pydir)
		dosym "${ED}"usr/$(get_libdir)/${PN}/libPyROOT.so \
			${pydir}/libPyROOT.so
	fi

	if use ruby; then
		local rubydir=$(${RUBY} -rrbconfig -e 'puts Config::CONFIG["sitearchdir"]')
		dodir ${rubydir}
		dosym "${ED}"usr/$(get_libdir)/${PN}/libRuby.so ${rubydir}/libRuby.so
	fi

	# Cleanup of files either already distributed or unused on Gentoo
	rm "${ED}"usr/share/doc/${PF}/{INSTALL,LICENSE,COPYING.CINT}
	rm "${ED}"usr/share/root/fonts/LICENSE
	pushd "${ED}"usr/$(get_libdir)/root/cint/cint/lib > /dev/null
	rm -f posix/mktypes dll_stl/setup \
		G__* dll_stl/G__* dll_stl/rootcint_* posix/exten.o
	rm -f "${ED}"usr/$(get_libdir)/root/cint/cint/include/makehpib
	rm -f "${ED}"/etc/root/proof/*.sample
	rm -rf "${ED}"/etc/root/daemons
	popd > /dev/null
	# these should be in PATH
	mv "${ED}"usr/share/root/proof/utils/pq2/pq2* \
		"${ED}"usr/bin
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	use python && python_mod_optimize
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	use python && python_mod_cleanup
}
