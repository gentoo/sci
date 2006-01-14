# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="PSPP is a program for statistical analysis of sampled data."
HOMEPAGE="http://www.gnu.org/software/pspp/pspp.html"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc ncurses emacs plotutils nls"

DEPEND=">=sci-libs/gsl-1.6
    sys-libs/readline
	>=sys-devel/gettext-0.14.1
	>=dev-lang/perl-5.6
	ncurses? >=sys-libs/ncurses-5.4
	plotutils? >=media-libs/plotutils-2.4.1"

src_compile() {
	econf \
		$(use_with plotutils ) \
		$(use_with ncurses ) \
		$(use_enable nls ) \
		|| die "econf failed"
	emake || die "emake failed"
	use doc && (emake html || die "make html failed")
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	make DESTDIR="${D}" install-man || die "make install-man failed"

	dodoc ABOUT-NLS AUTHORS ChangeLog \
		INSTALL NEWS ONEWS README THANKS TODO
	docinto examples && dodoc examples/{ChangeLog,descript.stat}

	if use doc; then
		docinto html
		dohtml doc/pspp.html/*.html
	fi

	if use emacs; then
		insinto /usr/share/emacs/site-lisp
		doins pspp.el
	fi
}
