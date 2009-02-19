# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit virtualx eutils

DESCRIPTION="GTK+ bindings for guile"
HOMEPAGE="http://www.gnu.org/software/guile-gtk/"
SRC_URI="ftp://ftp.gnu.org/gnu/guile-gtk/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-scheme/guile
	=x11-libs/gtk+-2*
	=gnome-base/libglade-2*
	>=x11-libs/gtkglarea-1.90"
RDEPEND="${DEPEND}"

pkg_setup() {
	if has_version =dev-scheme/guile-1.8*; then
		local flags="deprecated"
		built_with_use dev-scheme/guile ${flags} || die "guile must be built with \"${flags}\" use flag"
	fi
}

src_test() {
	Xemake check || die "tests failed"
}

src_install() {
	make DESTDIR="${D}" install
	dodoc README AUTHORS ChangeLog NEWS TODO
	insinto /usr/share/doc/${PF}/examples
	doins -r examples/
}
