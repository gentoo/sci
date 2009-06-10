# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic linux-info

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.berlios.de/"
SRC_URI="http://stgt.berlios.de/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ibmvio rdma fcp fcoe"

RDEPEND="rdma? (
				sys-cluster/libibverbs
				sys-cluster/librdmacm
				)"
DEPEND="${RDEPEND}"

src_compile() {
	local myconf
	use ibmvio && myconf="${myconf} IBMVIO=1"
	use rdma && myconf="${myconf} ISCSI_RDMA=1"
	use fcp && 	myconf="${myconf} FCP=1"
	use fcoe && myconf="${myconf} FCOE=1"
	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
}

src_install() {
	dodir "${D}//usr/share/doc/tgt"
	emake -C usr/ install DESTDIR="${D}" || die "install failed"
	doinitd "${FILESDIR}/tgtd"
	dodoc doc/README.* doc/targets.conf.example doc/tmf.txt
}
