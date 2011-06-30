# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils flag-o-matic

DESCRIPTION="Workload management system for compute-intensive jobs"
HOMEPAGE="http://www.cs.wisc.edu/condor/"
SRC_URI="${PN}_src-${PV}-all-all.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="classads drmaa examples gcb kbdd kerberos postgres soap ssl static-libs"

CDEPEND="sys-libs/zlib
	app-emulation/libvirt
	dev-libs/libpcre
	classads? ( sys-cluster/classads[pcre] )
	gcb? ( net-firewall/gcb )
	kerberos? ( app-crypt/mit-krb5 )
	kbdd? ( x11-libs/libX11 )
	postgres? ( dev-db/postgresql-base )
	soap? ( net-libs/gsoap )
	ssl? ( dev-libs/openssl )"

RDEPEND="${CDEPEND}
	mail-client/mailx"

DEPEND="${CDEPEND}
	x11-misc/imake"

RESTRICT=fetch

S="${WORKDIR}/${P}/src"

pkg_setup() {
	enewgroup condor
	enewuser condor -1 "${ROOT}"bin/bash "${ROOT}var/lib/condor" condor
}

src_prepare() {
	# these two eauto* are to replicate the build_init script
	# not so sure they are really needed
	eautoheader
	eautoconf
	# this patch is mostly to use standard fhs
	cd condor_examples
	epatch ./condor_config.generic.rpm.patch
	# the base local file is in /etc, then the condor local file is updated and should reside in /var/lib
	sed -i \
		-e 's:\(LOCAL_CONFIG_FILE.*=\).*:\1 /var/lib/condor/condor_config.local:' \
		condor_config.generic || die
}

src_configure() {
	# condor seems to be buggy with -O2 and above with gcc
	filter-flags "-O[s2-9]" "-O1"

	# set USE_OLD_IMAKE to anything so condor_imake will use the system
	# installed imake instead of building its own
	export USE_OLD_IMAKE=YES
	econf \
		--with-buildid=Gentoo-${P} \
		--enable-proper \
		--disable-full-port \
		--disable-gcc-version-check \
		--disable-glibc-version-check \
		--disable-rpm \
		--without-zlib \
		--with-libvirt \
		$(use_enable kbdd) \
		$(use_enable postgres quill) \
		$(use_enable static-libs static) \
		$(use_with classads) \
		$(use_with drmaa) \
		$(use_with gcb) \
		$(use_with kerberos krb5) \
		$(use_with postgres postgresql) \
		$(use_with soap gsoap) \
		$(use_with ssl openssl)
}

src_compile() {
	# yet to find a way to parallelize compilation
	emake -j1 || die "emake failed"
}

src_install() {
	emake release manpages || die "emake release failed"
	if use static-libs; then
		emake static || die "emake static failed"
	fi

	cd release_dir
	## remove a shitload of useless stuff to sync with the rpm package
	## comments are from the rpm fedora spec file
	# used by old MPI universe, not packaged (it's rsh, it should die)
	rm -rf libexec/rsh
	# this is distributed as chirp_client.c/h and chirp_protocol.h
	rm lib/libchirp_client.a include/chirp_client.h
	# checkpoint, reschedule and vacate live in bin/, don't duplicate
	rm sbin/condor_{checkpoint,reschedule,vacate}
	# sbin/condor is a pointless hard links
	rm sbin/condor

	# binaries
	dosbin sbin/* || die
	dobin bin/* || die
	# headers
	insinto /usr
	doins -r include || die
	# libs
	dolib.so lib/*so || die
	use static-libs && dolib.a lib/*a
	insinto /usr/libexec/condor
	doins -r libexec/* || die

	# data files
	insinto /usr/share/${PN}
	doins lib/*.jar lib/*.class lib/*.pm || die
	use postgres && doins -r sql

	# examples
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r etc/examples || die
	fi

	# config files
	insinto /etc/condor
	newins etc/examples/condor_config.generic condor_config || die
	newins etc/examples/condor_config.local.generic condor_config.local || die
	insinto /var/lib/condor/
	newins etc/examples/condor_config.local.generic

	dodir /var/log/condor
	dodir /var/run/condor
	dodir /var/lock/condor

	fperms 750 /var/lib/condor /var/log/condor
	fperms 755 /var/run/condor
	fperms 0775 /var/lock/condor
	fowners condor:condor /var/lib/condor /var/log/condor /var/run/condor /var/lib/condor/condor_config.local

	newconfd "${FILESDIR}"/condor.confd condor || die
	newinitd "${FILESDIR}"/condor.initd condor || die
}

pkg_postinst() {
	elog "Default configuration files have been installed"
	elog "You can customize it from there or provide your own"
	elog "in ${ROOT}etc/${PN}/condor_config*"

	elog "The condor ebuild is still under development."
	elog "Help us improve the ebuild in participating in:"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=60281"
}
