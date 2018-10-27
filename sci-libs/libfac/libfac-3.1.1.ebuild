# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="libfac is an extension of Singular-factory to finite fields"
HOMEPAGE="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/"
SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Libfac/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="singular"

DEPEND=">=sci-libs/factory-${PV}[singular=]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	econf $(use_with singular Singular)
}
