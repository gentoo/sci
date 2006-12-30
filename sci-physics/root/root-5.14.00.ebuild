# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils toolchain-funcs fortran qt3

DOC_PV=5_14
REF_PV=${DOC_PV/_/}

DESCRIPTION="An Object-Oriented Data Analysis Framework"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/html${REF_PV}.tar.gz
		   ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf )"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="afs cern doc fftw kerberos ldap mysql odbc opengl postgres
	  python ruby qt3 ssl xml"

RDEPEND="sys-apps/shadow
	>=sci-libs/gsl-1.8
	dev-libs/libpcre
	|| ( media-libs/libafterimage x11-wm/afterstep )
	opengl? ( virtual/opengl virtual/glu )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	afs? ( net-fs/openafs )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	qt3? ( $(qt_min_version 3.3.4) )
	fftw? ( >=sci-libs/fftw-3 )
	python? ( dev-lang/python )
	cern? ( sci-physics/cernlib )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	odbc? ( dev-db/unixODBC )"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	einfo
	einfo "You may want to build ROOT with these non Gentoo extra packages:"
	einfo "AliEn, castor, Chirp, Globus, Monalisa, Oracle, peac, "
	einfo "PYTHIA, PYTHIA6, SapDB, SRP, Venus"
	einfo "You can use the EXTRA_CONF variable for this."
	einfo "Example, for PYTHIA, you would do: "
	einfo "EXTRA_CONF=\"--enable-pythia --with-pythia-libdir=/usr/lib\" emerge root"
	einfo

	if use cern; then
		# only g77 allowed so far, because cernlib does not compile
		# with gfortran (gcc 4.1) (should with 4.2)
		FORTRAN="g77"
		fortran_pkg_setup
	fi
}

src_unpack() {
	if use cern; then
		fortran_src_unpack
	else
		unpack ${A}
	fi
}

src_compile() {
	# use configure and not econf cause not autoconf standard
	./configure \
		--prefix=/usr \
		--bindir=/usr/bin \
		--mandir=/usr/share/man/man1 \
		--incdir=/usr/include/${PN} \
		--libdir=/usr/$(get_libdir)/${PN} \
		--aclocaldir=/usr/share/aclocal/ \
		--datadir=/usr/share/${PN} \
		--cintincdir=/usr/share/${PN}/cint \
		--fontdir=/usr/share/${PN}/fonts \
		--iconpath=/usr/share/${PN}/icons \
		--macrodir=/usr/share/${PN}/macros \
		--srcdir=/usr/share/${PN}/src \
		--docdir=/usr/share/doc/${PF} \
		--testdir=/usr/share/doc/${PF}/test \
		--tutdir=/usr/share/doc/${PF}/tutorial \
		--elispdir=/usr/share/emacs/site-lisp \
		--etcdir=/etc/${PN} \
		--disable-alien \
		--disable-builtin-afterimage \
		--disable-builtin-freetype \
		--disable-builtin-pcre \
		--disable-builtin-zlib \
		--disable-chirp \
		--disable-dcache \
		--disable-globus \
		--disable-rfio \
		--disable-rpath \
		--disable-sapdb \
		--disable-srp \
		--enable-asimage \
		--enable-astiff \
		--enable-cintex \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-gdml \
		--enable-mathcore \
		--enable-mathmore \
		--enable-minuit2 \
		--enable-reflex \
		--enable-roofit \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		--enable-thread \
		--enable-xrootd \
		$(use_enable afs) \
		$(use_enable cern) \
		$(use_enable fftw fftw3) \
		$(use_enable kerberos krb5) \
		$(use_enable ldap) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable opengl) \
		$(use_enable postgres pgsql) \
		$(use_enable python) \
		$(use_enable qt3 qt) \
		$(use_enable qt3 qtgsi) \
		$(use_enable ruby) \
		$(use_enable ssl) \
		$(use_enable xml) \
		${EXTRA_CONF} \
		|| die "configure failed"

	local myfortran
	use cern && myfortran="F77=\"${FORTRANC}\" F77LIBS=\"-lg2c\""
	emake \
		OPTFLAGS="${CXXFLAGS}" \
		${myfortran} \
		|| die "emake failed"

	# is this only for windows? not quite sure.
	make cintdlls || die "make cintdlls failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	echo "LDPATH=\"/usr/$(get_libdir)/root\"" > 99root
	doenvd 99root

	if use doc; then
		einfo "Installing user's guide and ref manual"
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/Users_Guide_${DOC_PV}.pdf
		dohtml -r ${WORKDIR}/htmldoc
	fi
}
