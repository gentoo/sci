# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils python

DESCRIPTION="Python GUI RAD development tool."
HOMEPAGE="http://boa-constructor.sourceforge.net/"
SRC_URI="mirror://sourceforge/boa-constructor/${P}.src.zip"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=dev-python/wxpython-2.6*
	dev-libs/expat"

DEPEND="${RDEPEND}
	app-arch/unzip"

src_compile() {
	python -c "import compileall; compileall.compile_dir('.', force=1)"
}

src_install () {
	python_version
	local boadir="/usr/lib/python${PYVER}/site-packages/boa"

	local dir
	for dir in `find . -type d`
	do
		insinto "${boadir}/${dir}"
		cd "${dir}"
		local file
		for file in *
		do
			[ -f "${file}" ] && doins "${file}"
		done
		cd "${S}"
	done

	insinto "${boadir}"
	insinto "${boadir}/Plug-ins"
	doins Plug-ins/*

	dobin "${FILESDIR}/boa-constructor"

	dodoc Bugs.txt Changes.txt Credits.txt README.txt
}
