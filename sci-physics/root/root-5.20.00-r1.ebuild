# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/root/root-5.20.00.ebuild,v 1.4 2008/07/29 10:43:53 bicatali Exp $

EAPI=1
inherit versionator flag-o-matic eutils toolchain-funcs qt4 fortran

DOC_PV=$(get_major_version)_$(get_version_component_range 2)
ROOFIT_DOC_PV=2.07-29
TMVA_DOC_PV=4

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf
		ftp://root.cern.ch/root/doc/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf
		http://tmva.sourceforge.net/docu/TMVAUsersGuide_v${TMVA_DOC_PV}.pdf )"

HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"

IUSE="afs cern clarens doc fftw geant4 kerberos ldap +math mysql odbc
	oracle postgres pythia6 pythia8 python +reflex ruby qt4 ssl xml xrootd"

# libafterimage ignored, may be re-install for >=5.20
# see https://savannah.cern.ch/bugs/?func=detailitem&item_id=30944
#	|| ( >=media-libs/libafterimage-1.15 x11-wm/afterstep )
RDEPEND="sys-apps/shadow
	dev-libs/libpcre
	x11-libs/libXpm
	x11-libs/libXft
	media-libs/ftgl
	media-libs/libpng
	media-libs/jpeg
	media-libs/giflib
	media-libs/tiff
	virtual/opengl
	virtual/glu
	math? ( >=sci-libs/gsl-1.8 )
	afs? ( >=net-fs/openafs-1.4.7 )
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-server )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	qt4? ( || ( ( x11-libs/qt-gui:4
			x11-libs/qt-opengl:4
			x11-libs/qt-qt3support:4
			x11-libs/qt-xmlpatterns:4 )
			=x11-libs/qt-4.3* ) )
	fftw? ( sci-libs/fftw:3.0 )
	pythia6? ( sci-physics/pythia:6 )
	pythia8? ( sci-physics/pythia:8 )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	geant4? ( sci-physics/geant:4 )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	oracle? ( dev-db/oracle-instantclient-basic )
	clarens? ( dev-libs/xmlrpc-c )"

DEPEND="${RDEPEND}
	cern? ( dev-lang/cfortran )
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}"

QT4_BUILT_WITH_USE_CHECK="qt3support opengl"

pkg_setup() {
	elog
	elog "You may want to build ROOT with these non Gentoo extra packages:"
	elog "AliEn, castor, Chirp, gfal, gLite, Globus, Monalisa, SapDB, SRP."
	elog "You can use the env variable EXTRA_ECONF variable for this."
	elog "For example, for SRP, you would set: "
	elog "EXTRA_ECONF=\"--enable-srp --with-srp-libdir=/usr/$(get_libdir)\""
	elog
	epause 3
	if use cern; then
		FORTRAN="gfortran g77 ifc"
		fortran_pkg_setup
	else
		FORTRANC=
		FFLAGS=
	fi
	use qt4 && qt4_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-pic.patch
	# root bug; reported at https://savannah.cern.ch/bugs/?40816, fixed in svn
	epatch "${FILESDIR}"/${P}-include-defines-file.patch

	# use system cfortran
	if use cern; then
		rm -f include/root/cfortran.h
		ln -s /usr/include/cfortran.h include/cfortran.h
	fi
	# take a more descriptive name for ruby libs
	sed -i \
		-e 's/libRuby/libRubyROOT/g' \
		bindings/ruby/Module.mk bindings/ruby/src/drr.cxx \
		|| die "Ajusting ruby libname failed"

	# libPythia6 is called libpythia6 in gentoo
	sed -i -e 's/libPythia6/libpythia6/g' \
		configure || die "Adjust libpythia6 name failed"
}

src_compile() {

	local target
	if [[ "$(tc-getCXX)" == ic* ]]; then
		if use amd64; then
			target=linuxx8664icc
		elif use x86; then
			target=linuxicc
		fi
	fi

	local myconf
	use postgres && \
		myconf="${myconf} --with-pgsql-incdir=/usr/include/postgresql"

	use qt4 && \
		myconf="${myconf} --with-qt-incdir=/usr/include/qt4" && \
		myconf="${myconf} --with-qt-libdir=/usr/$(get_libdir)/qt4"

	use geant4 && \
		myconf="${myconf} --with-clhep-incdir=/usr/include" && \
		myconf="${myconf} --with-g4-libdir=${G4LIB}"

	use odbc && [[ -z $(type -P odbc-config) ]] && \
		myconf="${myconf} --with-odbc-incdir=/usr/include/iodbc"

	use pythia6 && \
		myconf="${myconf} --enable-pythia6" && \
		myconf="${myconf} --with-pythia6-libdir=/usr/$(get_libdir)"

	use pythia8 && \
		myconf="${myconf} --enable-pythia8" && \
		myconf="${myconf} --with-pythia8-incdir=/usr/include/pythia"

	# the configure script is not the standard autotools
	./configure \
		${target} \
		--fail-on-missing \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir)/${PN} \
		--docdir=/usr/share/doc/${PF} \
		--with-sys-iconpath=/usr/share/pixmaps \
		--with-f77="${FORTRANC} ${FFLAGS}" \
		--with-cc="$(tc-getCC) ${CFLAGS}" \
		--with-cxx="$(tc-getCXX) ${CXXFLAGS}" \
		--disable-builtin-afterimage \
		--disable-builtin-freetype \
		--disable-builtin-ftgl \
		--disable-builtin-pcre \
		--disable-builtin-zlib \
		--enable-asimage \
		--enable-astiff \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-gdml \
		--enable-memstat \
		--enable-opengl \
		--enable-shadowpw \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		${myconf} \
		$(use_enable afs) \
		$(use_enable clarens) \
		$(use_enable clarens peac) \
		$(use_enable fftw fftw3) \
		$(use_enable geant4 g4root) \
		$(use_enable kerberos krb5) \
		$(use_enable ldap) \
		$(use_enable math gsl-shared) \
		$(use_enable math genvector) \
		$(use_enable math mathmore) \
		$(use_enable math minuit2) \
		$(use_enable math roofit) \
		$(use_enable math unuran) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable postgres pgsql) \
		$(use_enable python) \
		$(use_enable qt4 qt) \
		$(use_enable qt4 qtgsi) \
		$(use_enable reflex cintex) \
		$(use_enable reflex) \
		$(use_enable ruby) \
		$(use_enable ssl) \
		$(use_enable xml) \
		$(use_enable xrootd) \
		${EXTRA_ECONF} \
		|| die "configure failed"

	emake || die "emake failed"
	emake cintdlls || die "emake cintdlls failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	echo "LDPATH=/usr/$(get_libdir)/root" > 99root
	use pythia8 && echo "PYTHIA8=/usr" >> 99root
	use python && echo "PYTHONPATH=/usr/$(get_libdir)/root" >> 99root
	use ruby && echo "RUBYLIB=/usr/$(get_libdir)/root" >> 99root
	doenvd 99root || die "doenvd failed"

	if use doc; then
		einfo "Installing user's guides"
		insinto /usr/share/doc/${PF}
		doins \
			"${DISTDIR}"/Users_Guide_${DOC_PV}.pdf \
			"${DISTDIR}"/TMVAUsersGuide_v${TMVA_DOC_PV}.pdf \
			|| die "pdf install failed"
		if use math; then
			doins "${DISTDIR}"/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf \
				|| die "math doc install failed"
		fi
	fi
}

pkg_postinst() {
	use ruby && elog "ROOT Ruby  module is available as libRubyROOT"
}
