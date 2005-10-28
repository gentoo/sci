# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/boinc/boinc-4.72.20050813.ebuild,v 1.5 2005/08/25 13:52:56 agriffis Exp $

inherit eutils

MY_PN="boinc_public-cvs"
MY_PV="2005-08-13"
S=${WORKDIR}/boinc_public

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="http://boinc.ssl.berkeley.edu/source/nightly/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="server X"

RDEPEND="sys-libs/zlib
	X? ( >=x11-libs/wxGTK-2.6.1 )
	server? ( net-www/apache
		>=dev-db/mysql-4.0.24
		virtual/php
		>=dev-lang/python-2.2.3
		>=dev-python/mysql-python-0.9.2 )"
DEPEND=">=sys-devel/gcc-3.0.4
	>=sys-devel/autoconf-2.59
	>=sys-devel/automake-1.9.3
	X? (	virtual/glut
		virtual/glu
		media-libs/jpeg )
	server? ( virtual/imap-c-client )
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# point to a proper mouse device
	sed -e "s:/dev/mouse:/dev/input/mice:g" -i client/hostinfo_unix.C || die
}

src_compile() {
	econf \
		--enable-client \
		--disable-static-client \
		--with-wx-config=$(which wx-config-2.6) \
		$(use_enable server) \
		$(use_with X x) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"

	newinitd ${FILESDIR}/boinc.init boinc
	newconfd ${FILESDIR}/boinc.conf boinc

	make_desktop_entry boinc_gui BOINC boinc Science /var/lib/boinc
}

pkg_preinst() {
	enewgroup boinc
	enewuser boinc -1 -1 /var/lib/boinc boinc
}

pkg_postinst() {
	echo
	einfo "You need to attach to a project to do anything useful with boinc."
	einfo "You can do this by running /etc/init.d/boinc attach"
	einfo "BOINC The howto for configuration is located at:"
	einfo "http://boinc.berkeley.edu/anonymous_platform.php"
	if use server;then
		echo
		einfo "You have chosen to enable server mode. this ebuild has installed"
		einfo "the necessary packages to be a server. You will need to have a"
		einfo "project. Contact BOINC directly for further information."
	fi
	echo
}
