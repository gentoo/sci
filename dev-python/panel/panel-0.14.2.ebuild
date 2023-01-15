# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

# Panel imports from "distutils" at runtime.
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="High-level app and dashboarding solution for Python"
HOMEPAGE="https://panel.holoviz.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# "setup.py" imports from Bokeh to rebuild Node.js packages, but we patch that
# away below. Our patched Panel thus requires Bokeh only at runtime.
DEPEND="
	>=dev-python/param-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/pyct-0.4.4[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=dev-python/bokeh-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyviz_comms-0.7.4[${PYTHON_USEDEP}]
	>=net-libs/nodejs-15.11.0
"

PATCHES=( "${FILESDIR}/${PN}-0.14.1-disable_lite_build.patch" )

# This does not work, need to patch..
#export PANEL_LITE_BUILD=1

src_prepare() {
	# Install Jupyter configuration files to "/etc" rather than "/usr/etc".
	sed -i -e 's~"etc/jupyter~"/etc/jupyter~' setup.py || die

	default_src_prepare
}

# This also does not work, still need patch :(
#src_compile() {
#	export PANEL_LITE_BUILD=1
#	distutils-r1_src_compile
#}

pkg_postinst() {
	panel_pkg_postinst() {
		PANEL_DIR="$(${EPYTHON} -c 'import os, panel; print(os.path.dirname(panel.__file__))')"
		elog "Node.js packages bundled with Panel under ${EPYTHON} may be"
		elog "desynchronized from Bokeh and require manual rebuilding with:"
		elog "    sudo ${EPYTHON} -m panel build \"${PANEL_DIR}\""
		elog
	}

	python_foreach_impl panel_pkg_postinst
}
