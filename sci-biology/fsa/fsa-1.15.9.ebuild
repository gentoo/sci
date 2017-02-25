# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Distance-based probabilistic multiple sequence alignment algo for DNA/RNA/prot"
HOMEPAGE="http://fsa.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/fsa/"${P}".tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-java/java-config"
RDEPEND="${DEPEND}"

# needs java for fsa-1.15.9/display/ processing:
# jar cmf mad/manifest.mf mad.jar \
#         -C . mad \
#         -C . JMF-2.1.1e/lib/jmf.jar \
#         -C . jai-1_1_3/lib/jai_core.jar \
#         -C . jai-1_1_3/lib/jai_codec.jar
# * Home for VM '' does not exist:
# * Invalid System VM:

src_install(){
	default
	# avoid file collision with sci-biology/ESTate-0.5
	mv "${D}"/"${EPREFIX}"/usr/bin/translate "${D}"/"${EPREFIX}"/usr/bin/fsa_translate || die
}

pkg_postinst(){
	einfo "Optionally you may want to install sci-biology/mummer and"
	einfo "sci-biology/exonerate"
}
