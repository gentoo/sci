# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ipp/ipp-6.0.1.071.ebuild,v 1.3 2009/01/31 12:07:10 bicatali Exp $

EAPI=2

IPV=11.1.046
DESCRIPTION="Intel(R) Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://developer.intel.com/software/products/ipp/"
SRC_URI=""

KEYWORDS="~amd64 ~x86 ~ia64"
SLOT="0"
LICENSE="Intel-SDP"

IUSE=""

DEPEND=""
RDEPEND="~dev-lang/icc-${IPV}[ipp]"
