# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils flag-o-matic multilib

DESCRIPTION="A set of tools designed for the efficient estimation of statistical n-gram language models"
HOMEPAGE="https://code.google.com/p/mitlm/"
SRC_URI="https://mitlm.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	./autogen.sh
	econf || die "configure failed"
}
