# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Workload management system for compute-intensive jobs"
HOMEPAGE="http://www.cs.wisc.edu/condor/"
SRC_URI="mirror://gentoo/${PN}_src-${PV}-all-all.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="classads drmaa examples gcb kbdd kerberos oracle postgres soap ssl static"

CDEPEND="sys-libs/zlib
	dev-libs/libpcre
	classads? ( sys-cluster/classads[pcre] )
	gcb? ( net-firewall/gcb )
	kerberos? ( app-crypt/mit-krb5 )
	kbdd? ( x11-libs/libX11 )
	oracle? ( dev-db/oracle-instantclient-basic )
	postgres? ( virtual/postgresql-base )
	soap? ( net-libs/gsoap )
	ssl? ( dev-libs/openssl )"

RDEPEND="${CDEPEND}
	mail-client/mailx"

DEPEND="${CDEPEND}
	x11-misc/imake"

pkg_setup() {
	enewgroup condor
	enewuser condor -1 -1 "${ROOT}var/lib/condor" condor
}

src_prepare() {
	# a few patches from Redhat
	epatch "${FILESDIR}"/condor_config.generic.patch
	epatch "${FILESDIR}"/stdsoap2.h.patch.patch
	epatch "${FILESDIR}"/chkconfig_off.patch
	epatch "${FILESDIR}"/no_basename.patch
	epatch "${FILESDIR}"/log_lock_run.patch
}

src_configure() {
	# set USE_OLD_IMAKE to anything so condor_imake will use the system
	# installed imake instead of building its own
	export USE_OLD_IMAKE=YES
	cd src
	econf \
		--with-buildid=Gentoo-${P} \
		--enable-proper \
		--disable-full-port \
		--disable-gcc-version-check \
		--disable-glibc-version-check \
		--disable-rpm \
		--without-zlib \
		$(use_enable kbdd) \
		$(use_enable postgres quill) \
		$(use_enable static) \
		$(use_with classads) \
		$(use_with drmaa) \
		$(use_with gcb) \
		$(use_with kerberos krb5) \
		$(use_with oracle oci) \
		$(use_with postgres postgresql) \
		$(use_with soap) \
		$(use_with ssl openssl)
}

src_compile() {
	cd src
	emake -j1 || die "emake failed"
}

src_install() {
	cd src
	emake release manpages || die "emake release failed"
	if use static; then
		emake static || die "emake static failed"
	fi
	cd release_dir
	# binaries
	dosbin sbin/*
	dobin bin/*
	# headers
	insinto /usr
	doins -r include
	# libs
	dolib.so lib/*so
	use static && dolib.a lib/*a
	insinto /usr/libexec/condor
	doins -r libexec/*

	# config files
	insinto /etc
	cp etc/examples/condor_config.generic etc/condor_config
	doins -r etc/*

	# data files
	insinto /usr/share/${PN}
	doins lib/*.jar lib/*.class lib/*.pm
	use postgres && doins -r sql

	# doc and examples
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r etc/examples || die
	fi

	dodir /var/lib/condor
	dodir /var/log/condor
	dodir /var/run/condor
	dodir /var/lock/condor

	fperms 750 /var/lib/condor /var/log/condor
	fperms 755 /var/run/condor
	fperms 0775 /var/lock/condor
	fowners condor:condor /var/lib/condor /var/log/condor /var/run/condor

	newconfd "${FILESDIR}"/condor.confd condor || die
	newinitd "${FILESDIR}"/condor.initd condor || die
}

pkg_postinst() {
	elog "condor ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=60281"
}
