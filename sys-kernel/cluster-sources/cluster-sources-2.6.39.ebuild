# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/tuxonice-sources/tuxonice-sources-2.6.38-r1.ebuild,v 1.1 2011/05/24 14:11:20 nelchael Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Gentoo patchset + some additional cluster related patches"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches/ http://dev.gentoo.org/~alexxy/cluster/"
IUSE=""

CLUSTER_VERSION="1"

CLUSTER_SRC="clusterpathches-${PV}-${CLUSTER_VERSION}.tar.bz2"

CLUSTER_URI="http://dev.gentoo.org/~alexxy/cluster/${CLUSTER_SRC}"

UNIPATCH_LIST="${DISTDIR}/${CLUSTER_SRC}"
UNIPATCH_STRICTORDER="yes"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CLUSTER_URI}"

KEYWORDS="~amd64"

K_SECURITY_UNSUPPORTED="1"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
