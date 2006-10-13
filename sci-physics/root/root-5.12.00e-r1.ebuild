# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils toolchain-funcs fortran qt3

DOC_PV=5_12
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

	FORTRAN="gfortran g77"
	fortran_pkg_setup
}

src_compile() {

	local rootconf="--enable-xrootd"
	# xrootd does not work with > gcc-4.1
	if [[ $(gcc-major-version)$(gcc-minor-version) -ge 41 ]]; then
		rootconf="--disable-xrootd"
	fi

	# icc/ifc still needs some work
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
		--docdir=/usr/share/doc/${P} \
		--testdir=/usr/share/doc/${P}/test \
		--tutdir=/usr/share/doc/${P}/tutorial \
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
		--enable-cintex \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-mathcore \
		--enable-mathmore \
		--enable-minuit2 \
		--enable-reflex \
		--enable-roofit \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		--enable-thread \
		$(use_enable afs) \
		$(use_enable cern) \
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
		${rootconf} \
		${EXTRA_CONF} \
		|| die "configure failed"

	# hack to support gfortran (upstream problem?)
	if [[ "${FORTRANC}" == "gfortran" ]]; then
		FORTRANLIBS="-lgfortran -lgfortranbegin"
	else
		FORTRANLIBS="-lg2c"
	fi
	emake \
		OPTFLAGS="${CXXFLAGS}" \
		F77="${FORTRANC}" \
		F77LIBS="${FORTRANLIBS}" \
		|| die "emake failed"

	# is this only for windows? not quite sure.
	make cintdlls || die "make cintdlls failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	echo "LDPATH=\"/usr/$(get_libdir)/root\"" > 99root
	doenvd 99root

	if use doc; then
		einfo "Installing user's guide and ref manual"
		insinto /usr/share/doc/${P}
		doins "${DISTDIR}"/Users_Guide_${DOC_PV}.pdf
		dohtml -r ${WORKDIR}/htmldoc
	fi
}
