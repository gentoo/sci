# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=8676
INTEL_DIST_PV=2016_update2

inherit intel-sdp-r1

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

LINGUAS="ja"
IUSE="doc examples l10n_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

# avoid file collision with ifc #476330
RDEPEND="l10n_ja? ( !dev-lang/ifc[l10n_ja(-)] !dev-lang/ifc[linguas_ja(-)] )
	~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=500M

INTEL_DIST_BIN_RPMS=(
	"icc-l-all-devel")
INTEL_DIST_DAT_RPMS=(
	"icc-l-all-common"
	"icc-l-all-vars"
	"icc-l-ps-common")
INTEL_DIST_X86_RPMS=(
	"icc-l-all-32"
	"icc-l-ps"
	"icc-l-ps-ss-wrapper")
INTEL_DIST_AMD64_RPMS=(
	"icc-l-all"
	"icc-l-ps-devel"
	"icc-l-ps-ss"
	"icc-l-ps-ss-devel")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"icc-doc-16.0.2-181.noarch.rpm"
			"icc-ps-doc-16.0.2-181.noarch.rpm"
			"icc-ps-ss-doc-16.0.2-181.noarch.rpm")

		if use l10n_ja; then
			INTEL_DIST_DAT_RPMS+=(
				"icc-ps-doc-jp-16.0.2-181.noarch.rpm")
		fi
	fi
}
