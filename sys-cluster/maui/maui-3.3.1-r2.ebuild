# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/maui/maui-3.3.1-r1.ebuild,v 1.3 2011/06/30 08:28:12 xarthisius Exp $

EAPI="4"

inherit autotools eutils multilib

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.clusterresources.com/products/maui/"
SRC_URI="http://www.adaptivecomputing.com/download/${PN}/${P}.tar.gz"

LICENSE="maui"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="pbs slurm"

REQUIRED_USE="^^ ( pbs slurm )"

DEPEND="
	pbs? ( sys-cluster/torque )
	slurm? ( sys-cluster/slurm )"
RDEPEND="${DEPEND}"

RESTRICT="fetch mirror"

src_prepare() {
	epatch "${FILESDIR}"/3.2.6_p21-autoconf-2.60-compat.patch
	sed -e "s:\$(INST_DIR)/lib:\$(INST_DIR)/$(get_libdir):" \
		-i src/{moab,server,mcom}/Makefile || die
	eautoreconf
}

src_configure() {
	local myconf
	use pbs && myconf="--with-pbs="${EPREFIX}"/usr"
	use slurm && myconf="--with-wiki"
	econf \
		--with-spooldir="${EPREFIX}"/var/spool/${PN} \
		${myconf}
}

src_install() {
	emake BUILDROOT="${D}" INST_DIR="${ED}/usr" install || die
	dodoc docs/README CHANGELOG || die
	dohtml docs/mauidocs.html || die
	newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}, obtain the file"
	einfo "${P}.tar.gz and put it in ${DISTDIR}"
}
