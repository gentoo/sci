# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit eutils distutils elisp-common

DESCRIPTION="An advanced interactive shell for Python."
HOMEPAGE="http://ipython.scipy.org/"
SRC_URI="http://ipython.scipy.org/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs examples gnuplot readline smp test wxwindows"

CDEPEND="dev-python/pexpect
	wxwindows? ( dev-python/wxpython )
	readline? ( sys-libs/readline )
	emacs? ( app-emacs/python-mode virtual/emacs )
	smp? (  net-zope/zopeinterface
			dev-python/foolscap
			dev-python/pyopenssl )"
RDEPEND="${CDEPEND}
	gnuplot? ( dev-python/gnuplot-py )"
DEPEND="${CDEPEND}
	test? ( dev-python/nose )"

PYTHON_MODNAME="IPython"
SITEFILE="62ipython-gentoo.el"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-globalpath.patch

	sed -i \
		-e '/examfiles)/d' \
		-e '/manfiles)/d' \
		-e '/manstatic)/d' \
		-e 's/^docfiles.*/docfiles=""/' \
		setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile
	if use emacs ; then
		elisp-compile docs/emacs/ipython.el || die "elisp-compile failed"
	fi
}

src_test() {
	"${python}" setup.py \
		install --home="${WORKDIR}/test" > /dev/null \
		|| die "fake install for testing failed"
	cd "${WORKDIR}"/test
	# first initialize .ipython stuff
	PATH="${WORKDIR}/test/bin:${PATH}" \
		PYTHONPATH="${WORKDIR}/test/lib/python" ipython > /dev/null <<-EOF
		EOF
	# test ( -v for more verbosity)
	PATH="${WORKDIR}/test/bin:${PATH}" \
		PYTHONPATH="${WORKDIR}/test/lib/python" iptest || die "test failed"
}

src_install() {
	DOCS="docs/source/changes.txt"
	distutils_src_install

	cd docs
	insinto /usr/share/doc/${PF}

	if use doc; then
		doins -r dist/* || die "doc install failed"
		doins "${S}"/IPython/Extensions/igrid_help* || die
	fi

	if use examples ; then
		doins -r examples || die "examples install failed"
	fi

	if use emacs ; then
		pushd emacs
		elisp-install ${PN} ${PN}.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		popd
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
