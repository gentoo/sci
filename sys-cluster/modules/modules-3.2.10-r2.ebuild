# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Dynamic modification of a user's environment via modulefiles"
HOMEPAGE="http://modules.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test X"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tclx
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

S="${WORKDIR}/${P%[a-z]}"

PATCHES=(
	"${FILESDIR}"/${P}-bindir.patch
	"${FILESDIR}"/${P}-versioning.patch
	"${FILESDIR}"/${P}-clear.patch
	"${FILESDIR}"/${P}-avail.patch
	"${FILESDIR}"/${P}-defs.patch
)

DOCS=(ChangeLog README NEWS TODO)

src_prepare() {
	has_version ">=dev-lang/tcl-8.6.0" &&
		eapply "${FILESDIR}"/${P}-errorline.patch
	default
	sed -e "s:@EPREFIX@:${EPREFIX}:g" \
		"${FILESDIR}"/modules.sh.in > modules.sh || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-versioning
		--prefix="${EPREFIX}/usr/share"
		--exec-prefix="${EPREFIX}/usr/share/Modules"
		--with-module-path="${EPREFIX}/etc/modulefiles"
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		$(use_with X x)
	)
	econf ${myconf[@]}
}

src_install() {
	default
	insinto /etc/profile.d
	doins modules.sh
	exeinto /usr/share/Modules/bin
	doexe "${FILESDIR}"/createmodule.{sh,py}
	dosym ../../../usr/share/Modules/init/csh /etc/profile.d/modules.csh
	dodir /etc/modulefiles
}
