# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Don't forget to keep things in sync with binary boinc package!
#

EAPI="2"

inherit flag-o-matic depend.apache eutils wxwidgets

DESCRIPTION="The Berkeley Open Infrastructure for Network Computing"
HOMEPAGE="http://boinc.ssl.berkeley.edu/"
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="X cuda server"

RDEPEND="
	!sci-misc/boinc
	app-misc/ca-certificates
	dev-libs/openssl
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-2.1
		>=x11-drivers/nvidia-drivers-180.22
	)
	server? (
		>=virtual/mysql-5.0
		dev-python/mysql-python
	)
	"
DEPEND="${RDEPEND}
	server? ( virtual/imap-c-client )
	X? (
		media-libs/freeglut
		media-libs/jpeg
		x11-libs/wxGTK:2.8[X,opengl]
	)
	"

LANGS="ar be bg ca cs da de el en_US es eu fi fr hr hu it ja lt lv nb nl pl pt
pt_BR ro ru sk sl sv_SE tr uk zh_CN zh_TW"
for LNG in ${LANGS}; do
	IUSE="${IUSE} linguas_${LNG}"
done

src_configure() {
	local wxconf=""
	local config=""

	# define preferable CFLAGS (recommended by upstream)
	append-flags -O3 -funroll-loops -fforce-addr -ffast-math

	# look for wxGTK
	if use X; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
		wxconf="${wxconf} --with-wx-config=${WX_CONFIG}"
	else
		wxconf="${wxconf} --without-wxdir"
	fi

	# nonstandard enable
	use server || config="--disable-server"

	# configure
	econf \
		--disable-dependency-tracking \
		--with-gnu-ld \
		--enable-unicode \
		--enable-client \
		--with-ssl \
		${wxconf} \
		${config} \
		$(use_with X x)

	# Fix LDFLAGS. Link to compiled stuff and not to installed one
	sed -i \
		-e "s|LDFLAGS = |LDFLAGS = -L../lib |g" \
		*/Makefile || die "sed failed"
}

src_compile() {
	# disable paralel build.
	emake -j1 || die "emake failed"
}

src_install() {
	# TODO: no time to test now.
	emake DESTDIR="${D}" install || die "make install failed"
	mkdir -p "${D}"/var/lib/boinc/
	# certificates
	dosym /etc/ssl/certs/ca-certificates.crt /opt/${MY_PN}/ca-bundle.crt
	# cuda
	use cuda && dosym /opt/cuda/lib/libcudart.so /opt/${MY_PN}/libcudart.so
}

pkg_preinst() {
	enewgroup ${MY_PN}
	if use cuda; then
		enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} "${MY_PN},video"
	else
		enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} "${MY_PN}"
	fi
}

pkg_postinst() {
	echo
	elog "You are using the source compiled version."
	elog "The manager can be found at /opt/bin/${MY_PN}"
	elog
	elog "You need to attach to a project to do anything useful with ${MY_PN}."
	elog "You can do this by running /etc/init.d/${MY_PN} attach"
	elog "The howto for configuration is located at:"
	elog "http://${MY_PN}.berkeley.edu/anonymous_platform.php"
	elog
	# Add warning about the new password for the client, bug 121896.
	elog "If you need to use the graphical client the password is in:"
	elog "/var/lib/${MY_PN}/gui_rpc_auth.cfg"
	elog "Where /var/lib/ is default RUNTIMEDIR, that can be changed in:"
	elog "/etc/conf.d/${MY_PN}"
	elog "You should change this to something more memorable (can be even blank)."
	elog
	elog "Remember to launch init script before using manager. Or changing the password."
}
