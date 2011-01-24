# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tgt/tgt-1.0.9.ebuild,v 1.3 2011/01/18 14:18:28 xarthisius Exp $

EAPI="3"

inherit flag-o-matic linux-info

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.sourceforge.net"
SRC_URI="http://stgt.sourceforge.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ibmvio infiniband fcp fcoe"

DEPEND="dev-perl/config-general
		infiniband? (
				sys-infiniband/libibverbs
				sys-infiniband/librdmacm
				)"
RDEPEND="${DEPEND}
		sys-apps/sg3_utils"

pkg_setup() {
	CONFIG_CHECK="~SCSI_TGT"
	WARNING_SCSI_TGT="Your kernel needs CONFIG_SCSI_TGT"
	linux-info_pkg_setup
}

src_configure() {
	use ibmvio && myconf="${myconf} IBMVIO=1"
	use infiniband && myconf="${myconf} ISCSI_RDMA=1"
	use fcp && myconf="${myconf} FCP=1"
	use fcoe && myconf="${myconf} FCOE=1"

	sed -e 's:\($(CC)\):\1 $(LDFLAGS):' -i usr/Makefile || die "sed failed"
}

src_compile() {
	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
}

src_install() {
	emake  install-programs install-scripts install-doc DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		|| die "install failed"
	doinitd "${FILESDIR}/tgtd"
	dodir "/etc/tgt"
}
