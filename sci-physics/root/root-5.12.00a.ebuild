# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

MY_VER=${PV%[a-z]}
MY_PATCH=${PV##"${MY_VER}"}
DOC_PV=5_12
REF_PV=${PV:0:4}

DESCRIPTION="An Object-Oriented Data Analysis Framework"
SRC_URI="ftp://root.cern.ch/root/root_v${MY_VER}${MY_PATCH}.source.tar.gz
	doc? ( ftp://root.cern.ch/root/html${REF_PV/.}.tar.gz
		   ftp://root.cern.ch/root/doc/Users_Guide_${DOC_PV}.pdf )"
HOMEPAGE="http://root.cern.ch/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="afs cern doc fftw icc kerberos ldap mysql opengl postgres
	  python ruby qt3 ssl tiff xml"

RDEPEND="|| (
				virtual/x11
				x11-libs/libXpm
			)
	>=media-libs/freetype-2.0.9
	sys-apps/shadow
>=sci-libs/gsl-1.8
	opengl? ( virtual/opengl virtual/glu )
	mysql? ( >=dev-db/mysql-3.23.49 )
	postgres? ( >=dev-db/postgresql-7.1.3-r4 )
	afs? ( net-fs/openafs )
	kerberos? ( app-crypt/mit-krb5 )
	ldap? ( net-nds/openldap )
	qt3? ( =x11-libs/qt-3* )
	fftw? ( >=sci-libs/fftw-3 )
	python? ( dev-lang/python )
	media-libs/libpng
	dev-libs/libpcre
	cern? ( sci-physics/cernlib )
	ruby? ( dev-lang/ruby )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	tiff? ( media-libs/tiff )
	icc? ( dev-lang/icc )"

DEPEND="${RDEPEND}
		|| (
			virtual/x11
			x11-proto/xproto
		   )"

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

src_compile() {

	local rootconf="--disable-xrootd"
	# first determine building arch
	# xrootd still not debugged upstream for amd64

	case ${ARCH} in
		x86)
			rootarch=linux
			use icc && rootarch=linuxicc
			rootconf="--enable-xrootd"
			;;
		amd64)
			rootarch=linuxx8664gcc
			use icc && rootarch=linuxx8664icc
			;;
		ia64)
			rootarch=linuxia64gcc
			use icc && rootarch=linuxia64ecc
			;;
		arm)
			rootarcg=linuxarm
			;;
		ppc)
			rootarch=linuxppcgcc
			append-flags "-fsigned-char"
			;;
		ppc64)
			rootarch=linuxppc64gcc
			;;
		ppc-macos)
			rootarch=macosx
			;;
		alpha)
			rootarch=linuxalpha
			;;
		x86-fbsd)
			rootarch=freebsd5
			;;
		*) die "root not supported upstream for this architecture";;
	esac

s
# use configure cause not autoconf standard
	./configure ${rootarch} \
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
		--disable-asimage \
		--disable-builtin-freetype \
		--disable-builtin-pcre \
		--disable-chirp \
		--disable-dcache \
		--disable-globus \
		--disable-rfio \
		--disable-rpath \
		--disable-sapdb \
		--disable-srp \
		--enable-asimage \
		--enable-builtin-afterimage \
		--enable-cintex \
		--enable-exceptions	\
		--enable-explicitlink \
		--enable-mathmore \
		--enable-mathcore \
		--enable-roofit \
		--enable-minuit2 \
		--enable-reflex \
		--enable-rpath \
		--enable-shadowpw \
		--enable-shared	\
		--enable-soversion \
		--enable-table \
		--enable-thread \
		--enable-xrootd \
		$(use_enable kerberos krb5) \
		$(use_enable ldap) \
		$(use_enable mysql) \
		$(use_enable opengl) \
		$(use_enable postgres pgsql) \
		$(use_enable qt3 qt) \
		$(use_enable qt3 qtgsi) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable cern) \
		$(use_enable tiff astiff) \
		$(use_enable xml) \
		$(use_enable ssl) \
		${rootconf} \
		${EXTRA_CONF} \
		|| die "configure failed"
	emake OPTFLAGS="${CXXFLAGS}" || die "emake failed"
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
