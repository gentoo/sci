# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Ceph is an open source distributed file system capable of managing many petabytes of storage with ease."
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuse"

DEPEND="dev-libs/boost
		dev-libs/libedit"
RDEPEND="sys-fs/btrfs-progs"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with fuse)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install Failed"
	keepdir /var/lib/ceph
	keepdir /var/log/ceph
}
