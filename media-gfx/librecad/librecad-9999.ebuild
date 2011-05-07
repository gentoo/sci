# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: caduntu-9999.ebuild $

EAPI="2"

inherit qt4-r2 subversion

DESCRIPTION="An generic 2D CAD program"
HOMEPAGE="http://www.librecad.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

ESVN_REPO_URI=https://librecad.svn.sourceforge.net/svnroot/librecad/trunk/
ESVN_RESTRICT=export

RDEPEND="x11-libs/qt-gui[qt3support]"
DEPEND="${RDEPEND}"

src_unpack()
{
	subversion_src_unpack || die
	cd "$(subversion__get_wc_path "${ESVN_REPO_URI}")"
	rsync -rlpgo . "${S}" || die "${ESVN}: can't export to ${S}."
  # patch to solve an issue caused by gcc-4.6, by mickele, archlinux
    sed -e "s|LiteralMask<Value_t, n>::mask;|LiteralMask<Value_t, static_cast<unsigned int>(n)>::mask;|" \
	    -e "s|SimpleSpaceMask<n>::mask;|SimpleSpaceMask<static_cast<unsigned int>(n)>::mask;|" \
		-i "${S}"/fparser/fparser.cc
}

src_install()
{
	dobin unix/librecad || die
	insinto /usr/share/"${PN}"
	doins -r unix/resources/* || die
	if use doc ; then
		dohtml -r support/doc/* || die
	fi
	doicon res/main/"${PN}".png || die
	make_desktop_entry "${PN}" LibreCAD "${PN}.png" Graphics || die
}
