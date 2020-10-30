# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Environment Module System based on Lua"
HOMEPAGE="https://lmod.readthedocs.io/en/latest"
SRC_URI="https://github.com/TACC/Lmod/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE="auto-swap cache dotfiles duplicate +extend italic module-cmd nocase redirect test"
RESTRICT="!test? ( test )"

RDEPEND+="
	app-shells/tcsh
	|| (
		app-shells/loksh
		app-shells/mksh
		app-shells/ksh
	)
	app-shells/zsh
	dev-lang/tcl
	dev-lua/luafilesystem
	dev-lua/luajson
	dev-lua/luaposix
	dev-lua/lua-term
"
DEPEND+="${RDEPEND}"
BDEPEND+="
	test? (
		dev-util/Hermes
	)
"

PATCHES=( "${FILESDIR}"/${PN}-8.4.11-ldflags.patch )

pkg_setup() {
	elog "There is a lot of options for this package,"
	elog "especially for run time behaviour."
	elog "You can set them using EXTRA_ECONF variable."
	elog "To see full list of options visit:"
	elog "https://lmod.readthedocs.io/en/latest/090_configuring_lmod.html"
}

src_prepare() {
	default

	rm -r "${S}"/rt/{colorize,end2end,help,ifur,settarg} || die
}

src_configure() {
	# set environment variables to pass to Lmod configuration
	local -x CACHE_LIFETIME="${CACHE_LIFETIME:-86400}"
	local -x SHORT_TIME="${SHORT_TIME:-2}"
	local -x SYSTEM_TOUCH="${SYSTEM_TOUCH:-/var/lmod/latest_system_update.time}"
	local -x SITE_NAME="${SITE_NAME:-Gentoo}"
	local -x SYSHOST="${SYSHOST:-Gentoo}"

	local myconf=(
		--with-tcl
		--with-fastTCLInterp
		--with-colorize
		--prefix=/opt
		--with-ancient="${CACHE_LIFETIME}"
		--with-supportKsh
		--with-updateSystemFn="${SYSTEM_TOUCH}"
		--with-siteName="${SITE_NAME}"
		--with-syshost="${SYSHOST}"
		--with-shortTime="${SHORT_TIME}"
		--without-useBuiltinPkgs
		$(use_with duplicate duplicatePaths)
		$(use_with nocase caseIndependentSorting)
		$(use_with italic hiddenItalic)
		$(use_with auto-swap autoSwap)
		$(use_with module-cmd exportedModuleCmd)
		$(use_with redirect)
		$(use_with dotfiles useDotFiles)
		$(use_with cache cachedLoads)
		$(use_with extend extendedDefault)
	)

	econf ${myconf[@]} ${EXTRA_ECONF[@]}
}

src_compile() {
	CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
	default
}

src_test() {
	local -x PATH="/opt/hermes/bin:${PATH}"
	tm -vvv || die
}

src_install() {
	CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	default

	keepdir /var/lmod
}

pkg_postinst() {
	elog "Lmod has been installed at /opt/lmod/{lmod -> ${PV}}"
	elog "To activate Lmod, you need to source the profile"
	elog "script provided"
	elog " $ . /opt/lmod/lmod/init/profile"
	elog "This will provide you with the 'module' command"
	elog " $ man module"
}
