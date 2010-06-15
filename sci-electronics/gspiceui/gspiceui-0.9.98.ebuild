# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WX_GTK_VER="2.8"
inherit wxwidgets

MY_P="${PN}-v${PV}"

DESCRIPTION="GUI frontend for Ngspice and Gnucap"
HOMEPAGE="http://www.geda.seul.org/tools/gspiceui/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples schematics waveform"

DEPEND="x11-libs/wxGTK:2.8[X]
	sci-electronics/electronics-menu"
RDEPEND="${DEPEND}
	|| ( sci-electronics/ng-spice-rework sci-electronics/gnucap )
	waveform? ( sci-electronics/gwave )
	schematics? ( sci-electronics/geda )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Removing pre-configured CXXFLAGS from Makefile. The Makefile then only appends
	# the flags required for wxwidgets to the Gentoo preset.
	sed -i \
		-e "s:CXXFLAGS = -O -pipe:CXXFLAGS += :" \
		src/Makefile || die "Patching src/Makefile failed"

	# Adjusting the doc path at src/main/HelpTasks.cpp
	sed -i \
		-e "s:/share/gspiceui/html/gSpiceUI.html:/share/doc/${P}/html/gSpiceUI.html:" \
		src/main/HelpTasks.cpp \
		|| die "Patching src/main/HelpTasks.cpp failed"
}

src_install() {
	dobin bin/gspiceui || die
	dodoc ChangeLog || die
	doman gspiceui.1 || die
	newicon src/icons/gspiceui-48x48.xpm gspiceui.xpm || die

	dohtml html/*.html html/*.jpeg || die

	# installing examples
	if use examples ; then
		insinto /usr/share/doc/${P}/sch
		doins -r sch/* || die
	fi

	make_desktop_entry gspiceui "GNU Spice GUI" gspiceui.xpm "Electronics"
}

pkg_postinst() {
	if use examples ; then
		elog "If you want to use the examples, copy then from"
		elog "/usr/share/doc/${P}/sch to your home to be able"
		elog "to generate the netlists as an normal user."
	fi
}
