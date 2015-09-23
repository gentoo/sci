# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit java-pkg-2 python-r1

DESCRIPTION="Viewer of next generation sequence assemblies and alignments"
HOMEPAGE="http://ics.hutton.ac.uk/tablet/"
SRC_URI="
	x86? ( http://bioinf.hutton.ac.uk/tablet/installers/tablet_linux_x86_$(replace_all_version_separators _).sh -> ${P}.sh )
	amd64? ( http://bioinf.hutton.ac.uk/tablet/installers/tablet_linux_x64_$(replace_all_version_separators _).sh -> ${P}.sh )
	http://bioinf.hutton.ac.uk/tablet/additional/coveragestats.py"

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

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
		virtual/jre"

S="${WORKDIR}"

src_unpack() {
	local file
	for file in ${A}; do
		cp "${DISTDIR}"/${file} "${WORKDIR}" || die
	done
}

src_install() {
	# In theory it seems this binary package could be installed through ant
	# instead of the install4j package which is not easy to be forced
	# non-interactive. The below approach via install4j is not ideal but works.
	sed "s#\"\${D}\"#\"${D}\"#g" "${FILESDIR}"/response.varfile > "${WORKDIR}"/response.varfile || die "sed failed"

	# the intallation script somehow does not pickup
	# -varfile="${DISTDIR}"/response.varfile from the commandline and therefore
	# we place the file rather directly into the place where it should reside.
	# In the file you can read details how the variables were mangled. For
	# example, the trick with sys.symlinkDir in the response.varfile is to
	# disable the installation process to symlink from /usr/local/bin/table to
	# /opt/Tablet/tablet. That was logged in that file with the following line:
	#
	# /var/tmp/portage/sci-biology/tablet-bin-1.11.02.18/image/opt/Tablet/.install4j/installation.log:
	#	Variable changed: sys.symlinkDir=/usr/local/bin[class java.lang.String]
	#
	# The file is then left on the installed system in "${D}"/opt/Tablet/.install4j/response.varfile
	dodir /opt/Tablet/.install4j
	cat "${WORKDIR}"/response.varfile > "${ED}"/opt/Tablet/.install4j/response.varfile || die

	# make sure we force java to point a to $HOME which is inside our sanbox
	# directory area. We force -Duser.home . It seems also -Dinstall4j.userHome
	# could be done based on the figure shown at http://resources.ej-technologies.com/install4j/help/doc/
	sed \
		-e "s#/bin/java\" -Dinstall4j.jvmDir#/bin/java\" -Duser.home="${TMPDIR}" -Dinstall4j.jvmDir#" \
		-i "${WORKDIR}"/${P}.sh || die
	sh \
		"${WORKDIR}"/${P}.sh \
		-q -overwrite \
		-varfile="${DISTDIR}"/response.varfile \
		--destination="${ED}"/opt/Tablet \
		-dir "${ED}"/opt/Tablet || die

	rm -rf "${ED}"/opt/Tablet/jre || die

	# this dies with tablet-bin-1.14.04.10 with
	#  * python2_7: running python_doscript /mnt/1TB/var/tmp/portage/sci-biology/tablet-bin-1.14.04.10/work/coveragestats.py
	#  * The file has incompatible shebang:
	#  *   file: /usr/lib/python-exec/python2.7/coveragestats.py
	#  *   current shebang: #!/usr/bin/env python
	#  *   requested impl: python2.7
	#
	# python_foreach_impl python_doscript "${WORKDIR}"/coveragestats.py

	echo "PATH=${EPREFIX}/opt/Tablet" > 99Tablet
	doenvd 99Tablet || die
}
