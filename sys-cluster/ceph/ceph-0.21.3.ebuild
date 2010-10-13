# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools multilib

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse logrotate radosgw"

RDEPEND="
		dev-libs/boost
		sys-devel/libtool
		dev-libs/libedit
		dev-lang/perl
		sys-libs/gdbm
		dev-libs/openssl
		dev-libs/libatomic_ops
		fuse? ( sys-fs/fuse )
		radosgw? ( dev-libs/fcgi dev-libs/expat )
		sys-fs/btrfs-progs"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf || die
}

src_configure() {
	econf \
		--without-hadoop\
		$(use_with fuse)\
		$(use_with radosgw) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -type f -name "*.la" -exec rm -f {} \;
	find "${D}" -type f -name "*.a" -exec rm -f {} \;

	rmdir "${D}/usr/sbin"

	exeinto /usr/$(get_libdir)/ceph || die
	newexe src/init-ceph ceph_init.sh || die

	sed -i 's:invoke-rc\.d.*:/etc/init.d/ceph reload >/dev/null:' src/logrotate.conf
	insinto /etc/logrotate.d/ || die
	newins src/logrotate.conf ceph || die

	chmod 644 "${D}"/usr/share/doc/ceph/sample.* || die

	keepdir /var/lib/${PN} || die
	keepdir /var/lib/${PN}/tmp || die
	keepdir /var/log/${PN}/stat || die
	keepdir /var/run/${PN} || die

	newinitd "${FILESDIR}/ceph.initd" ceph || die
	newconfd "${FILESDIR}/ceph.confd" ceph || die
}
