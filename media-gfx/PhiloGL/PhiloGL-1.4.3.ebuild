# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="WebGL Framework for Data Vis, Creative Coding and Game Development"
HOMEPAGE="http://www.senchalabs.org/philogl/"
SRC_URI="http://www.senchalabs.org/philogl/downloads/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

S=${WORKDIR}

src_prepare() {
	if use examples ; then
		for f in $(find "${S}"/examples -name index.html); do
	   		sed -e "s:../../../build:/usr/share/${PN}/build:g" \
				-e "s:../../build:/usr/share/${PN}/build:g" \
				-i ${f} || die
		done
		sed -e "s:../../../shaders/:/usr/share/${PN}/shaders/:" \
			-i examples/lessons/{14,15,16}/index.js || die
	fi
}

src_install() {
	insinto /usr/share/${PN}
	doins -r build shaders

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
