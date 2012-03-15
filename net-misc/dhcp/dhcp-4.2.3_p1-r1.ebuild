# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcp/dhcp-4.2.3_p1.ebuild,v 1.7 2012/01/01 15:03:13 armin76 Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_PV="${PV//_alpha/a}"
MY_PV="${MY_PV//_beta/b}"
MY_PV="${MY_PV//_rc/rc}"
MY_PV="${MY_PV//_p/-P}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="ISC Dynamic Host Configuration Protocol (DHCP) client/server"
HOMEPAGE="http://www.isc.org/products/DHCP"
SRC_URI="ftp://ftp.isc.org/isc/dhcp/${MY_P}.tar.gz
	ftp://ftp.isc.org/isc/dhcp/${MY_PV}/${MY_P}.tar.gz"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="+client ipv6 infiniband kernel_linux ldap selinux +server ssl vim-syntax"

DEPEND="selinux? ( sec-policy/selinux-dhcp )
	kernel_linux? ( sys-apps/net-tools )
	ldap? (
		net-nds/openldap
		ssl? ( dev-libs/openssl )
	)"
RDEPEND="${DEPEND}
	vim-syntax? ( app-vim/dhcpd-syntax )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	# handle local bind hell
	cd "${S}"/bind
	unpack ./bind.tar.gz
}

src_prepare() {
	# Gentoo patches - these will probably never be accepted upstream
	# Fix some permission issues
	epatch "${FILESDIR}"/${PN}-3.0-fix-perms.patch
	# Enable dhclient to equery NTP servers
	epatch "${FILESDIR}"/${PN}-4.0-dhclient-ntp.patch
	# resolvconf support in dhclient-script
	epatch "${FILESDIR}"/${PN}-4.2.2-dhclient-resolvconf.patch
	# Stop downing the interface on Linux as that breaks link daemons
	# such as wpa_supplicant and netplug
	epatch "${FILESDIR}"/${PN}-3.0.3-dhclient-no-down.patch
	epatch "${FILESDIR}"/${PN}-4.2.0-errwarn-message.patch
	# Enable dhclient to get extra configuration from stdin
	epatch "${FILESDIR}"/${PN}-4.2.2-dhclient-stdin-conf.patch
	epatch "${FILESDIR}"/${PN}-4.2.2-nogateway.patch #265531

	# NetworkManager support patches
	# If they fail to apply to future versions they will be dropped
	# Add dbus support to dhclient
	epatch "${FILESDIR}"/${PN}-3.0.3-dhclient-dbus.patch

	# infiniband patches
	if use infiniband; then
		epatch "${FILESDIR}"/${PN}-4.2.2-lpf-ib.patch
		epatch "${FILESDIR}"/${PN}-4.2.2-improved-xid.patch
		epatch "${FILESDIR}"/${PN}-4.2.2-gpxe-cid.patch
	fi

	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die

	# Change the hook script locations of the scripts
	sed -i \
		-e 's,/etc/dhclient-exit-hooks,/etc/dhcp/dhclient-exit-hooks,g' \
		-e 's,/etc/dhclient-enter-hooks,/etc/dhcp/dhclient-enter-hooks,g' \
		client/scripts/* || die

	# No need for the linux script to force bash #158540
	sed -i -e 's,#!/bin/bash,#!/bin/sh,' client/scripts/linux || die

	# Quiet the freebsd logger a little
	sed -i -e '/LOGGER=/ s/-s -p user.notice //g' client/scripts/freebsd || die

	# Remove these options from the sample config
	sed -i \
		-e "/\(script\|host-name\|domain-name\) / d" \
		client/dhclient.conf || die

	if use client && ! use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<(dhcpctl|relay|server)\>::g' \
			Makefile.in || die
	elif ! use client && use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<client\>::' \
			Makefile.in || die
	fi

	# Only install different man pages if we don't have en
	if [[ " ${LINGUAS} " != *" en "* ]]; then
		# Install Japanese man pages
		if [[ " ${LINGUAS} " == *" ja "* && -d doc/ja_JP.eucJP ]]; then
			einfo "Installing Japanese documention"
			cp doc/ja_JP.eucJP/dhclient* client
			cp doc/ja_JP.eucJP/dhcp* common
		fi
	fi
	# Now remove the non-english docs so there are no errors later
	rm -rf doc/ja_JP.eucJP

	# make the bind build work
	binddir=${S}/bind
	cd "${binddir}" || die
	cat <<-EOF > bindvar.tmp
	binddir=${binddir}
	GMAKE=${MAKE:-gmake}
	EOF
	epatch "${FILESDIR}"/${PN}-4.2.2-bind-disable.patch
	cd bind-*/
	epatch "${FILESDIR}"/${PN}-4.2.2-bind-parallel-build.patch #380717
	epatch "${FILESDIR}"/${PN}-4.2.2-bind-build-flags.patch
}

src_configure() {
	# bind defaults to stupid `/usr/bin/ar`
	tc-export AR BUILD_CC
	export ac_cv_path_AR=${AR}

	# this is tested for by the bind build system, and can cause trouble
	# when cross-building; since dhcp itself doesn't make use of libcap,
	# simply disable it.
	export ac_cv_lib_cap_cap_set_proc=no

	# Use FHS sane paths ... some of these have configure options,
	# but not all, so just do it all here.
	local e="/etc/dhcp" r="/var/run/dhcp" l="/var/lib/dhcp"
	cat <<-EOF >> includes/site.h
	#define _PATH_DHCPD_CONF     "${e}/dhcpd.conf"
	#define _PATH_DHCLIENT_CONF  "${e}/dhclient.conf"
	#define _PATH_DHCPD_DB       "${l}/dhcpd.leases"
	#define _PATH_DHCPD6_DB      "${l}/dhcpd6.leases"
	#define _PATH_DHCLIENT_DB    "${l}/dhclient.leases"
	#define _PATH_DHCLIENT6_DB   "${l}/dhclient6.leases"
	#define _PATH_DHCPD_PID      "${r}/dhcpd.pid"
	#define _PATH_DHCPD6_PID     "${r}/dhcpd6.pid"
	#define _PATH_DHCLIENT_PID   "${r}/dhcpclient.pid"
	#define _PATH_DHCLIENT6_PID  "${r}/dhcpclient6.pid"
	#define _PATH_DHCRELAY_PID   "${r}/dhcrelay.pid"
	#define _PATH_DHCRELAY6_PID  "${r}/dhcrelay6.pid"
	EOF

	econf \
		--enable-paranoia \
		--enable-early-chroot \
		--sysconfdir=${e} \
		$(use_enable ipv6 dhcpv6) \
		$(use_with ldap) \
		$(use ldap && use_with ssl ldapcrypto || echo --without-ldapcrypto)

	# configure local bind cruft.  symtable option requires
	# perl and we don't want to require that #383837.
	cd bind/bind-*/ || die
	eval econf \
		$(sed -n '/ [.].configure /{s:^[^-]*::;s:>.*::;p}' ../Makefile) \
		--disable-symtable \
		--without-make-clean
}

src_compile() {
	# build local bind cruft first
	emake -C bind/bind-*/lib/export install || die
	# then build standard dhcp code
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die

	dodoc README RELNOTES doc/{api+protocol,IANA-arp-parameters}
	dohtml doc/References.html

	if [[ -e client/dhclient ]] ; then
		# move the client to /
		dodir /sbin
		mv "${D}"/usr/sbin/dhclient "${D}"/sbin/ || die

		exeinto /sbin
		if use kernel_linux ; then
			newexe "${S}"/client/scripts/linux dhclient-script || die
		else
			newexe "${S}"/client/scripts/freebsd dhclient-script || die
		fi
	fi

	if [[ -e server/dhcpd ]] ; then
		if use ldap ; then
			insinto /etc/openldap/schema
			doins contrib/ldap/dhcp.* || die
			dosbin contrib/ldap/dhcpd-conf-to-ldap || die
		fi

		newinitd "${FILESDIR}"/dhcpd.init5 dhcpd || die
		newconfd "${FILESDIR}"/dhcpd.conf2 dhcpd || die
		newinitd "${FILESDIR}"/dhcrelay.init2 dhcrelay || die
		newconfd "${FILESDIR}"/dhcrelay.conf dhcrelay || die
	fi

	# the default config files aren't terribly useful #384087
	sed -i '/^[^#]/s:^:#:' "${D}"/etc/dhcp/*.conf || die
}

pkg_preinst() {
	enewgroup dhcp
	enewuser dhcp -1 -1 /var/lib/dhcp dhcp

	# Keep the user files over the sample ones.  The
	# hashing is to ignore the crappy defaults #384087.
	local f h
	for f in dhclient:da7c8496a96452190aecf9afceef4510 dhcpd:10979e7b71134bd7f04d2a60bd58f070 ; do
		h=${f#*:}
		f="/etc/dhcp/${f%:*}.conf"
		if [ -e "${ROOT}"${f} ] ; then
			case $(md5sum "${ROOT}"${f}) in
				${h}*) ;;
				*) cp -p "${ROOT}"${f} "${D}"${f};;
			esac
		fi
	done
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/init.d/dhcp ]] ; then
		ewarn
		ewarn "WARNING: The dhcp init script has been renamed to dhcpd"
		ewarn "/etc/init.d/dhcp and /etc/conf.d/dhcp need to be removed and"
		ewarn "and dhcp should be removed from the default runlevel"
		ewarn
	fi
}
