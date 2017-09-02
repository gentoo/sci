# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="PGI compiler suite"
HOMEPAGE="http://www.pgroup.com/"
SRC_URI="pgilinux-2013-135.tar.gz"

LICENSE="PGI"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda java"

RDEPEND="net-misc/curl"

RESTRICT="mirror strip"

QA_PREBUILT="
		opt/pgi/linux86/2013/cuda/4.2/lib/lib*.so.*
		opt/pgi/linux86-64/13.5/bin/*
		opt/pgi/linux86-64/13.5/lib/lib*
		opt/pgi/linux86-64/13.5/lib/*.o
		opt/pgi/linux86-64/13.5/libso/lib*
		opt/pgi/linux86-64/13.5/libso/*.o
		opt/pgi/linux86-64/13.5/cray/lib*
		opt/pgi/linux86-64/13.5/etc/pgi_license_tool/curl
		opt/pgi/linux86-64/13.5/REDIST/lib*.so
		opt/pgi/linux86-64/2013/cuda/5.0/nvvm/cicc
		opt/pgi/linux86-64/2013/cuda/4.2/nvvm/cicc
		opt/pgi/linux86-64/2013/acml/5.3.0/lib/lib*
		opt/pgi/linux86-64/2013/acml/5.3.0/libso/lib*.so
		opt/pgi/linux86/13.5/etc/pgi_license_tool/curl
		opt/pgi/linux86/13.5/bin/*
		opt/pgi/linux86/13.5/lib/lib*
		opt/pgi/linux86/13.5/lib/*.o
		opt/pgi/linux86/13.5/libso/lib*
		opt/pgi/linux86/13.5/cray/lib*
		opt/pgi/linux86/2013/cuda/5.0/nvvm/cicc
		opt/pgi/linux86/2013/cuda/4.2/nvvm/cicc
		opt/pgi/linux86/2013/acml/4.4.0/lib/lib*
		opt/pgi/linux86/2013/acml/4.4.0/libso/lib*.so
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "PGI doesn't provide direct download links. Please download"
	einfo "${ARCHIVE} from ${HOMEPAGE}"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-terminal.patch"
}

src_install() {
	dodir /opt/pgi

	command="accept
1
${ED}/opt/pgi"

	command="${command}
n"

	if use cuda; then
		command="${command}
y
accept"
	else
		command="${command}
n"
	fi

	if use java; then
		command="${command}

accept"
	else
		command="${command}
no"
	fi

	command="${command}
y
n
n
y
"
	./install <<EOF
${command}
EOF
	# fix problems with PGI's C++ compiler and current glibc:
	cd "${ED}"
	epatch "${FILESDIR}/${P}-glibc.patch"

	# java symlink might be broken if useflag is disabled:
	use java || rm opt/pgi/linux86-64/13.5/jre

	# replace PGI's curl with the stock version:
	dodir /opt/pgi/linux86-64/13.5/etc/pgi_license_tool
	dosym /usr/bin/curl /opt/pgi/linux86-64/13.5/etc/pgi_license_tool/curl
	dodir /opt/pgi/linux86/13.5/etc/pgi_license_tool
	dosym /usr/bin/curl /opt/pgi/linux86/13.5/etc/pgi_license_tool/curl
}
