# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/chemtool/chemtool-1.6.9-r1.ebuild,v 1.8 2008/04/26 13:03:47 markusle Exp $

inherit eutils kde-functions

DESCRIPTION="program for drawing organic molecules"
HOMEPAGE="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/"
SRC_URI="http://ruby.chemie.uni-freiburg.de/~martin/chemtool/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnome kde nls"

RDEPEND=">=media-gfx/transfig-3.2.3d
		=x11-libs/gtk+-2*
		kde? ( =kde-base/kdelibs-3.5* )
		x86? ( >=media-libs/libemf-1.0 )"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_compile() {
	local config_opts
	local mycppflags
	if ! use kde; then
		unset KDEDIR
		config_opts="${config_opts} --without-kdedir"
	else
		set-kdedir
		config_opts="${config_opts} --with-kdedir=${KDEDIR}"
	fi
	if [ ${ARCH} = "x86"  ]; then
		config_opts="${config_opts} --enable-emf"
		mycppflags="${mycppflags} -I /usr/include/libEMF"
	fi

	sed -e "s:\(^CPPFLAGS.*\):\1 ${mycppflags}:" -i Makefile.in || \
		die "could not append cppflags"

	if use gnome ; then
		config_opts="${config_opts} --with-gnomedir=/usr" ;
	else
		config_opts="${config_opts} --without-gnomedir" ;
	fi

	econf ${config_opts} \
		|| die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog INSTALL README TODO
	insinto /usr/share/${PN}/examples
	doins "${S}"/examples/*
	if ! use nls; then rm -rf "${D}"/usr/share/locale; fi
}
