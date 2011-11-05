# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils multilib

IUSE="+system-boost"
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca-ctp.googlecode.com/files/${PF}.tar.gz"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://moo.votca-ctp.googlecode.com/hg"
	EHG_REVISION="default"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca molecular orbital overlap code"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="=sci-libs/votca-tools-${PV}[system-boost=]"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( README NOTICE )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use system-boost EXTERNAL_BOOST)
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}
