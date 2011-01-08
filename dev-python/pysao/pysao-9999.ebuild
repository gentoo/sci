# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion distutils

DESCRIPTION="Python wrapper around some SAO tools"
HOMEPAGE="http://code.google.com/p/python-sao/"
ESVN_REPO_URI="http://python-sao.googlecode.com/svn/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/xpa"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
}
