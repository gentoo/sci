# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

inherit python base autotools

DESCRIPTION="Pacemaker client GUI and management daemon"
HOMEPAGE="http://hg.clusterlabs.org/pacemaker/pygui/"
SRC_URI="http://hg.clusterlabs.org/pacemaker/pygui/archive/45aced6962a9.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+ais heartbeat nls snmp static-libs"

CDEPEND="
	app-arch/bzip2
	dev-libs/glib:2
	dev-libs/libxslt
	dev-libs/openssl
	dev-python/pygtk
	dev-python/pyxml
	net-libs/gnutls
	sys-apps/util-linux
	dev-lang/swig
	sys-cluster/cluster-glue
	>=sys-cluster/pacemaker-1.1
	!heartbeat? ( !ais? ( sys-cluster/pacemaker[ais] ) )
	sys-libs/ncurses
	sys-libs/pam
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	sys-devel/libtool"
DEPEND="${CDEPEND}
	dev-util/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

S="${WORKDIR}/Pacemaker-Python-GUI-45aced6962a9/"

PATCHES=(
 	"${FILESDIR}/${P}-gnutls.patch"
 	"${FILESDIR}/${P}-doc.patch"
)

pkg_setup() {
	python_set_active_version 2
	if ! use ais && ! use heartbeat; then
		ewarn "You disabled both cluster implementations"
		ewarn "Silently enabling OpenAIS/CoroSync support."
	fi
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	local myopts=""

	use heartbeat || use ais || myopts="--with-ais-support"
	econf $(use_with ais ais-support) \
		$(use_with heartbeat heartbeat-support) \
		$(use_enable snmp) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		${myopts} \
		--disable-fatal-warnings
}

src_install() {
	base_src_install
	newinitd "${FILESDIR}"/mgmtd.init pcmk-mgmtd
	dodoc README doc/AUTHORS || die
}

pkg_postinst() {
	elog "Important : To login in the GUI, your user"
	elog "must be part of the 'haclient' group."
	echo
	elog "To start the management daemon, run:"
	elog "/etc/init.d/pcmk-mgmtd start"
	echo
	elog "To launch the GUI, simply run : crm_gui"
	echo
}
