# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java binding for HDF5 compatible with HDF5 1.6/1.8"
HOMEPAGE="https://wiki-bsse.ethz.ch/display/JHDF5
	https://wiki-bsse.ethz.ch/pages/viewpage.action?pageId=26609113"
SRC_URI="https://wiki-bsse.ethz.ch/download/attachments/26609237/sis-jhdf5-14.12.1-r33502.zip"
# first SIS release: https://wiki-bsse.ethz.ch/download/attachments/26609237/sis-jhdf5-14.12.0-r33145.zip
# last CISD release: https://wiki-bsse.ethz.ch/download/attachments/26609237/cisd-jhdf5-13.06.2-r29633.zip

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

# versions <=12.02 required >=java-1.5
DEPEND=">=virtual/jdk-1.6:*"
RDEPEND="${DEPEND}
	>=virtual/jre-1.6:*"

S="${WORKDIR}"/sis-jhdf5
