# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils

PV_MAJOR="${PV%%.*}"
PV_MINOR="${PV#*.}"
PV_MINOR="${PV_MINOR%%.*}"
DESCRIPTION="Support programs for the Oracle Cluster Filesystem 2"
HOMEPAGE="http://oss.oracle.com/projects/ocfs2-tools/"
SRC_URI="http://oss.oracle.com/projects/ocfs2-tools/dist/files/source/v${PV_MAJOR}.${PV_MINOR}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X"
# (#142216) build system's broke, always requires glib for debugfs utility
RDEPEND="X? (
		=x11-libs/gtk+-2*
		>=dev-lang/python-2
		>=dev-python/pygtk-2
	)
	sys-cluster/openais
	sys-cluster/dlm-lib
	sys-cluster/cman-lib
	>=dev-libs/glib-2.2.3
	sys-fs/e2fsprogs"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/gcc45-ftbfs.patch"
}

src_configure() {
	#local myconf="--enable-dynamic-fsck --enable-dynamic-ctl"

	econf \
		$(use_enable X ocfs2console) \
		${myconf} \
		|| die "Failed to configure"
}

src_install() {
	make DESTDIR="${D}" install || die "Failed to install"

	dodoc \
		COPYING CREDITS MAINTAINERS README README.O2CB debugfs.ocfs2/README \
		documentation/users_guide.txt documentation/samples/cluster.conf \
		documentation/ocfs2_faq.txt "${FILESDIR}"/INSTALL.GENTOO \
		vendor/common/o2cb.init vendor/common/o2cb.sysconfig

	# Move programs not needed before /usr is mounted to /usr/sbin/
	newinitd "${FILESDIR}"/ocfs2.init ocfs2
	newconfd "${FILESDIR}"/ocfs2.conf ocfs2

	insinto /etc/ocfs2
	newins "${S}"/documentation/samples/cluster.conf cluster.conf
}

pkg_postinst() {
	elog "Read ${ROOT}usr/share/doc/${P}/INSTALL.GENTOO* for instructions"
	elog "about how to install, configure and run ocfs2."
}

