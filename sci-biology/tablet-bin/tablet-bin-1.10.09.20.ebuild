# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Graphical viewer for next generation sequence assemblies and alignments."
HOMEPAGE="http://bioinf.scri.ac.uk/tablet/"
SRC_URI="http://bioinf.scri.ac.uk/tablet/installers/tablet_linux_x86_1_10_09_20.sh
		http://bioinf.scri.ac.uk/tablet/additional/coveragestats.py"

# Tablet uses a modified version of the BSD License which has been edited to remove references to distribution and use in source forms. This means that we are happy for you to distribute and use Tablet however you please, but we do not (yet) want to make the source code publicly available.
LICENSE="Tablet" # It's in the installer, and ends up on disk after installation at /opt/Tablet/docs/tablet.html
				# The original BSD licence was modified to remove references to distribution and use in
				#source forms, because we cannot make the source code available for Tablet.
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		virtual/jre
		dev-lang/python"

src_install() {
	# In theory it seems this binary package could be installed through ant instead of the install4j package which is not easy to be forced non-interactive. The below approach is not ideal.
	sh "${DISTDIR}"/tablet_linux_x86_1_10_09_20.sh -c -q -overwrite --var-file="${FILESDIR}"/response.varfile --destination="${D}"/opt/Tablet
	dobin "${DISTDIR}"/coveragestats.py || die
}
