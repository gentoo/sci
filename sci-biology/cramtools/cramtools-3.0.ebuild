# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java tools and APIs for efficient compression of sequence read data"
HOMEPAGE="http://www.ebi.ac.uk/ena/software/cram-toolkit
	https://github.com/enasequence/cramtools"
SRC_URI="https://github.com/enasequence/cramtools/archive/v3.0.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.7:*
	dev-java/ant-core
	dev-java/htsjdk"
RDEPEND="
	${DEPEND}
	>=virtual/jre-1.7:*"

# TODO: zap bundled htsjdk to ensure it uses dev-java/htsjdk?
# https://github.com/enasequence/cramtools/issues/58
# https://github.com/enasequence/cramtools/issues/59
src_compile(){
	ant -f build/build.xml runnable || die
}
