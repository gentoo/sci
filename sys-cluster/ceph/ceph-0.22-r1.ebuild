# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils multilib

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse libatomic radosgw static-libs"

CDEPEND="dev-libs/boost
	dev-libs/libedit
	dev-libs/openssl
	libatomic? ( dev-libs/libatomic_ops )
	fuse? ( sys-fs/fuse )
	radosgw? ( dev-libs/fcgi dev-libs/expat )"
DEPEND="${CDEPEND}
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	sys-fs/btrfs-progs"

src_prepare() {
	sed -e 's:invoke-rc\.d.*:/etc/init.d/ceph reload >/dev/null:' \
		-i src/logrotate.conf || die
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf
}

src_configure() {
	econf \
		--without-hadoop \
		--docdir=/usr/share/doc/${PF} \
		$(use_with debug) \
		$(use_with fuse) \
		$(use_with libatomic libatomic-ops) \
		$(use_with radosgw) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -type f -name "*.la" -exec rm -f {} \;

	rmdir "${D}/usr/sbin"

	exeinto /usr/$(get_libdir)/ceph || die
	newexe src/init-ceph ceph_init.sh || die

	insinto /etc/logrotate.d/ || die
	newins src/logrotate.conf ${PN} || die

	chmod 644 "${D}"/usr/share/doc/${PF}/sample.* || die

	keepdir /var/lib/${PN} || die
	keepdir /var/lib/${PN}/tmp || die
	keepdir /var/log/${PN}/stat || die
	keepdir /var/run/${PN} || die

	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
	newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
}
