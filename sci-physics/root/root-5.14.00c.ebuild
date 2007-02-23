# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator flag-o-matic eutils toolchain-funcs qt3

DOC_PV=$(get_major_version)_$(get_version_component_range 2)

DESCRIPTION="C++ data analysis framework and interpreter from CERN"
SRC_URI="ftp://root.cern.ch/${PN}/${PN}_v${PV}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf )"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="afs doc fftw kerberos ldap mysql odbc opengl postgres
	  python ruby qt3 ssl xml"

DEPEND="sys-apps/shadow
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
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	odbc? ( dev-db/unixODBC )"

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
}

src_unpack() {
	unpack ${A}
	if [[ ${ARCH} == sparc ]]; then
		einfo "Patch to allow ${ARCH} autoconf --- Bug 87305"
		# first unpack all the way
		cd ${S}/xrootd/src
		einfo "Unpacking xrootd and mark it done"
		tar xzf xrootd-20060928-1600.src.tgz
		#touch headers.d
		einfo "Patching for sparc..."
		cd ${WORKDIR}
		epatch ${FILESDIR}/sparc-${P}.patch
		einfo "... complete.  Now replace with something more sparc-friendly."
		cd ${S}/xrootd/src
		einfo "Building a kinder .tgz file"
		tar czf xrootd-20060928-1600.src.tgz xrootd
		einfo "Destroy all traces"
		rm -rf xrootd
		einfo "Unpacked for sparc"
	fi
}

src_compile() {
	# the configure script is not the standard autotools
	./configure "${EXTRA_CONF}" \
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
		--disable-cern \
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

	emake \
		OPTFLAGS="${CXXFLAGS}" \
		rootcint compiledata || die "emake rootcint failed"
	emake -j1 \
		OPTFLAGS="${CXXFLAGS}" \
		rootlibs || die "emake rootlibs failed"
	emake \
		OPTFLAGS="${CXXFLAGS}" \
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
