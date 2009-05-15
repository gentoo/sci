# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools apache-module elisp-common eutils multilib versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://ftp.gluster.com/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb doc emacs examples +fuse infiniband static vim-syntax"

DEPEND="berkdb? ( >=sys-libs/db-4.6.21 )
	emacs? ( virtual/emacs )
	fuse? ( >=sys-fs/fuse-2.7.0 )
	infiniband? ( sys-cluster/libibverbs )"
RDEPEND="${RDEPEND}"

SITEFILE="50${PN}-mode-gentoo.el"

APXS2_S="${S}/mod_glusterfs/apache/2.2/src"
APACHE2_MOD_FILE="${APXS2_S}/.libs/mod_${PN}.so"
APACHE2_MOD_CONF="70_mod_${PN}"
APACHE2_MOD_DEFINE="GLUSTERFS"
APACHE2_DOCFILES="README.txt"
want_apache2_2

src_prepare() {

	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-parallel-make.patch"
	epatch "${FILESDIR}/${P}-apache2.patch"
	epatch "${FILESDIR}/${P}-apxs.patch"

	if ! use doc; then
		sed -i -e '/SUBDIRS =/s/ [a-z]*-guide//g' \
		doc/Makefile.am \
		|| die "sed remove-guides-from-Makefile.am-patch"
	fi

	if ! use examples; then
		sed -i -e '/SUBDIRS =/s/ examples//' \
		doc/Makefile.am \
		|| die "sed remove-examples-from-Makefile.am-patch"
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable berkdb bdb) \
		$(use_enable fuse fuse-client) \
		$(use_enable apache2 mod_glusterfs) \
		$(use_enable static) \
		$(use_enable infiniband ibverbs) \
		--localstatedir=/var ||die
}

src_compile() {
	emake || die "Emake failed"
	use apache2 && apache-module_src_compile
	if use emacs ; then
		elisp-compile extras/glusterfs-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}/extras" install || die

	if use apache2 ; then
		apache-module_src_install
		rm -rf "${D}/usr/$(get_libdir)/glusterfs/${PV}/apache"
	fi

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}/glusterfs.vim" || die
		insinto /usr/share/vim/vimfiles/syntax; doins extras/glusterfs.vim || die
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"

	newinitd "${FILESDIR}/${PN}.initd" glusterfsd || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd || die "newconfd failed"

	keepdir /var/log/${PN} || die "keepdir failed"
	keepdir /var/lib/${PN} || die "keepdir failed"
}

pkg_postinst() {
	elog "The glusterfs startup script can be multiplexed."
	elog "The default startup script uses /etc/conf.d/glusterfs to configure the"
	elog "separate service.  To create additional instances of the glusterfs service"
	elog "simply create a symlink to the glusterfs startup script."
	elog
	elog "Example:"
	elog "    # ln -s glusterfsd /etc/init.d/glusterfsd2"
	elog "    # ${EDITOR} /etc/glusterfs/glusterfsd2.vol"
	elog "You can now treat glusterfsd2 like any other service"
	echo
	elog "You can mount exported GlusterFS filesystems through /etc/fstab instead of"
	elog "through a startup script instance.  For more information visit:"
	elog "http://www.gluster.org/docs/index.php/Mounting_a_GlusterFS_Volume"
	echo
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers.  Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."

	use apache2 && apache-module_pkg_postinst

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
