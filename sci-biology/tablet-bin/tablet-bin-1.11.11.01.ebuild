# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 python

DESCRIPTION="Viewer of next generation sequence assemblies and alignments."
HOMEPAGE="http://bioinf.scri.ac.uk/tablet/"
SRC_URI="http://bioinf.scri.ac.uk/tablet/installers/tablet_linux_x86_1_11_11_01.sh
		http://bioinf.scri.ac.uk/tablet/additional/coveragestats.py"

# Upstream says regarding source code unavailability:
# Tablet uses a modified version of the BSD License which has been edited to
# remove references to distribution and use in source forms. This means that
# we are happy for you to distribute and use Tablet however you please, but we
# do not (yet) want to make the source code publicly available.

# The licence file itself is in the installer, and ends up on disk after
# installation at /opt/Tablet/docs/tablet.html
# The original BSD licence was modified to remove references to distribution
# and use in source forms, because we cannot make the source code available
# for Tablet.

LICENSE="Tablet"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		virtual/jre
		dev-lang/python"

MYPV="$(replace_all_version_separators '_')"

pkg_setup() {
	einfo "Fixing java access violations ..."
	# bug 387227
	addpredict /proc/self/coredump_filter
}

src_install() {
	# In theory it seems this binary package could be installed through ant
	# instead of the install4j package which is not easy to be forced
	# non-interactive. The below approach via install4j is not ideal but works.
	sed "s#\"\${D}\"#"${D}"#g" "${FILESDIR}"/response.varfile > "${DISTDIR}"/response.varfile || die "sed failed"

	# the intallation script somehow does not pickup
	# -varfile="${DISTDIR}"/response.varfile from the commandline and therefore
	# we place the file rather directly into the place where it should reside.
	# In the file you can read details how the variables were mangled. For
	# example, the trick with sys.symlinkDir in the response.varfile is to
	# disable the installation process to symlink from /usr/local/bin/table to
	# /opt/Tablet/tablet. That was logged in that file with the following line:
	#
	# /var/tmp/portage/sci-biology/tablet-bin-1.11.02.18/image/opt/Tablet/.install4j/installation.log: Variable changed: sys.symlinkDir=/usr/local/bin[class java.lang.String]
	#
	# The file is then left on the installed system in "${D}"/opt/Tablet/.install4j/response.varfile
	mkdir -p "${D}"/opt/Tablet/.install4j || die "Cannot pre-create	"${D}"/opt/Tablet/.install4j/"
	cat "${DISTDIR}"/response.varfile >	"${D}"/opt/Tablet/.install4j/response.varfile || die "Cannot write	"${D}"/opt/Tablet/.install4j/response.varfile"

	# make sure we force java to point a to $HOME which is inside our sanbox
	# directory area. We force -Duser.home . It seems also -Dinstall4j.userHome
	# could be done based on the figure shown at http://resources.ej-technologies.com/install4j/help/doc/
	sed "s#/bin/java\" -Dinstall4j.jvmDir#/bin/java\" -Duser.home="${D}"/../temp -Dinstall4j.jvmDir#" -i "${DISTDIR}"/tablet_linux_x86_"${MYPV}".sh || die "failed to set userHome value"
	sh "${DISTDIR}"/tablet_linux_x86_"${MYPV}".sh -q -overwrite -varfile="${DISTDIR}"/response.varfile --destination="${D}"/opt/Tablet -dir "${D}"/opt/Tablet || die "Failed to run the self-extracting exe file"
	dobin "${DISTDIR}"/coveragestats.py
}
