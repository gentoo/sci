# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN="Pacemaker"
MY_P="${MY_PN}-${PV}"
PYTHON_DEPEND="2"
inherit autotools base eutils flag-o-matic multilib python

DESCRIPTION="Pacemaker CRM"
HOMEPAGE="http://www.linux-ha.org/wiki/Pacemaker"
SRC_URI="http://hg.clusterlabs.org/${PN}/1.1/archive/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="heartbeat smtp snmp static-libs"

RDEPEND="
	dev-libs/libxslt
	sys-cluster/corosync
	sys-cluster/cluster-glue
	sys-cluster/resource-agents
	heartbeat? ( >=sys-cluster/heartbeat-3.0.0 )
	smtp? ( net-libs/libesmtp )
	snmp? ( net-analyzer/net-snmp )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-autotools.patch"
)

S=${WORKDIR}/${MY_PN}-1-1-${MY_P}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	base_src_prepare
	sed -i -e "/ggdb3/d" configure.ac || die
	eautoreconf
}

src_configure() {
	local myopts=""
	use heartbeat || myopts="--with-ais"
	# appends lib to localstatedir automatically
	econf \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--disable-fatal-warnings \
		--with-cs-quorum \
		--without-cman \
		$(use_with smtp esmtp) \
		$(use_with heartbeat) \
		$(use_with snmp) \
		$(use_enable static-libs static) \
		${myopts}
}

src_install() {
	base_src_install
	newinitd "${FILESDIR}/pacemaker.initd" pacemaker || die
	insinto /etc/corosync/service.d
	newins "${FILESDIR}/pacemaker.service" pacemaker || die
}

pkg_postinst() {
	elog "This version of Pacemaker uses the new MCP feature"
	elog "and the v1 plugin for CoroSync. Read [1] for more info."
	elog
	elog "To start the Pacemaker Cluster Manager, run:"
	elog "/etc/init.d/pacemaker start"
	elog
	elog "[1] http://theclusterguy.clusterlabs.org/post/907043024/introducing-the-pacemaker-master-control-process-for"
	elog
	elog "Note: sys-cluster/openais is no longer a hard dependency of ${P},"
	elog "so you may need to install it yourself to suit your needs."
}
