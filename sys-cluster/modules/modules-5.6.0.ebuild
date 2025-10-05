# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="
	https://github.com/envmodules/modules/
	https://envmodules.github.io/modules/
"
SRC_URI="https://github.com/envmodules/modules/releases/download/v${PV}/${P}.tar.bz2 -> ${P}.gh.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="new-features +shell-setup +man-install test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/tcl
	sys-apps/util-linux
	sys-apps/less
	shell-setup? ( !sys-cluster/lmod )
	man-install? ( !sys-cluster/lmod )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/tcl
	test? ( dev-util/dejagnu )
"

src_configure() {
	local myconf=(
		--with-bin-search-path="${EPREFIX}/usr/bin:${EPREFIX}/bin"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		--prefix="${EPREFIX}/usr/share/Modules"
		--nagelfardatadir="${EPREFIX}/usr/share/Modules/nagelfar"
		--disable-emacs-addons
		--enable-quarantine-support
		--with-modulepath="${EPREFIX}/usr/share/Modules/modulefiles:${EPREFIX}/etc/modulefiles"
		--with-quarantine-vars='LD_LIBRARY_PATH LD_PRELOAD'
		$(usex man-install "" --mandir="${EPREFIX}/usr/share/Modules/share/man")
		$(use_enable new-features)
	)
	econf "${myconf[@]}"
}

src_test() {
	script/mt quick || die
}

src_install() {
	default
	keepdir /etc/modulefiles
	if use shell-setup ; then
		dosym -r /usr/share/Modules/init/profile.sh /etc/bash/bashrc.d/modules.sh
		dosym -r /usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
		dosym -r /usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh
		dosym -r /usr/share/Modules/init/fish /etc/fish/conf.d/modules.fish
		newbashcomp init/bash_completion module
		bashcomp_alias module ml
		newzshcomp init/zsh-functions/_module _module
		newfishcomp init/fish_completion module.fish
	fi
}
