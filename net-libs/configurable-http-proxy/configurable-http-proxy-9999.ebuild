# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A simple wrapper around node-http-proxy that adds a REST API for updating the routing table"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"
else
	SRC_URI="https://github.com/jupyter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=net-libs/nodejs-0.8.28[npm]
	"
DEPEND="${RDEPEND}"

src_install() {
	# npm_src_install() from https://github.com/neurogeek/gentoo-overlay/blob/master/eclass/npm.ecla

	local npm_files="${NPM_FILES} ${NPM_EXTRA_FILES}"
	local node_modules="${D}/usr/$(get_libdir)/node_modules/${NPM_MODULE}"

	mkdir -p ${node_modules} || die "Could not create DEST folder"

	for f in ${npm_files}
	do
		if [[ -e "${S}/$f" ]]; then
			cp -r "${S}/$f" ${node_modules}
		fi
	done

	dodoc README.md
}
