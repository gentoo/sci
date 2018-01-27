# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=8676
INTEL_DIST_PV=2016_update2

inherit intel-sdp-r1

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

LINGUAS="ja"
IUSE="doc examples l10n_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

# avoid file collision with icc #476330
RDEPEND="l10n_ja? ( !dev-lang/icc[l10n_ja(-)] !dev-lang/icc[linguas_ja(-)] )
	~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=400M

INTEL_DIST_BIN_RPMS=(
	"ifort-l-ps"
	"ifort-l-ps-devel")
INTEL_DIST_DAT_RPMS=(
	"fcompxe-2016.2-062.noarch.rpm"
	"ifort-l-ps-common"
	"ifort-l-ps-vars")
INTEL_DIST_X86_RPMS=()
INTEL_DIST_AMD64_RPMS=()

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"fcompxe-doc-2016.2-062.noarch.rpm"
			"ifort-ps-doc-16.0.2-181.noarch.rpm")

		if use l10n_ja; then
			INTEL_DIST_DAT_RPMS+=(
				"ifort-ps-doc-jp-16.0.2-181.noarch.rpm")
		fi
	fi

	if use examples; then
		INTEL_DIST_DAT_RPMS+=(
			"fcomp-doc-2016.2-062.noarch.rpm")
	fi

	if use l10n_ja; then
		INTEL_DIST_BIN_RPMS+=(
			"ifort-l-ps-jp")
	fi
}
