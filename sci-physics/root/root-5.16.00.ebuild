# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator flag-o-matic eutils toolchain-funcs qt3 fortran

#DOC_PV=$(get_major_version)_$(get_version_component_range 2)
DOC_PV=5_14

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf )"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="afs cern doc fftw kerberos ldap mysql odbc opengl postgres
	  python ruby qt3 ssl xml"

DEPEND="sys-apps/shadow
	>=sci-libs/gsl-1.8
	dev-libs/libpcre
	|| ( media-libs/libafterimage x11-wm/afterstep )
	opengl? ( virtual/opengl virtual/glu )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	afs? ( net-fs/openafs )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	qt3? ( $(qt_min_version 3.3.4) )
	fftw? ( >=sci-libs/fftw-3 )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	cern? ( sci-physics/cernlib )
	odbc? ( dev-db/unixODBC )"

S=${WORKDIR}/${PN}

pkg_setup() {
	elog
	elog "You may want to build ROOT with these non Gentoo extra packages:"
	elog "AliEn, castor, Chirp, Globus, Monalisa, Oracle, peac, "
	elog "PYTHIA, PYTHIA6, SapDB, SRP, Venus"
	elog "You can use the EXTRA_CONF variable for this."
	elog "Example, for PYTHIA, you would do: "
	elog "EXTRA_CONF=\"--enable-pythia --with-pythia-libdir=/usr/$(get_libdir)\" emerge root"
	elog

	if use cern; then
		FORTRAN="gfortran g77 ifc"
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
	# the configure script is not the standard autotools
	./configure ${EXTRA_CONF} \
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
		--enable-unuran \
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
		|| die "configure failed"
	local myfortran
	if use cern; then
		myfortran="F77=${FORTRANC} F77LD=${FORTRANC}"
		if [[ "${FORTRANC}" == "g77" ]]; then
			myfortran="${myfortran} F77LIBS=-lg2c"
		else
			myfortran="${myfortran} F77LIBS=-lgfortran"
		fi
	fi
	emake \
		OPTFLAGS="${CXXFLAGS}" \
		${myfortran} \
		|| die "emake failed"

	# is this only for windows? not quite sure.
	make cintdlls || die "make cintdlls failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	echo "LDPATH=\"/usr/$(get_libdir)/root\"" > 99root
	doenvd 99root

	if use doc; then
		einfo "Installing user's guide and ref manual"
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/Users_Guide_${DOC_PV}.pdf
		dohtml -r ${WORKDIR}/htmldoc
	fi
}
