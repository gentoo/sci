# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CMAKE_MIN_VERSION=2.8

PYTHON_COMPAT=( python3_{6..9} )

inherit cmake-utils python-single-r1 user vcs-snapshot

DESCRIPTION="Workload management system for compute-intensive jobs"
HOMEPAGE="http://htcondorproject.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/V${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="boinc cgroup contrib curl dmtcp doc kerberos libvirt minimal postgres python soap ssl test X xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="sys-libs/zlib
	>=dev-libs/libpcre-7.6
	$(python_gen_cond_dep '
		dev-libs/boost[${PYTHON_USEDEP}]
	')
	net-nds/openldap
	boinc? ( sci-misc/boinc )
	cgroup? ( >=dev-libs/libcgroup-0.37 )
	curl? ( >=net-misc/curl-7.19.7[ssl?] )
	dmtcp? ( sys-apps/dmtcp )
	libvirt? ( >=app-emulation/libvirt-0.6.2 )
	kerberos? ( virtual/krb5 )
	X? ( x11-libs/libX11 )
	postgres? ( >=dev-db/postgresql-8.2.4:= )
	python? ( ${PYTHON_DEPS} )
	soap? ( >=net-libs/gsoap-2.7.11[ssl?] )
	ssl? ( >=dev-libs/openssl-0.9.8i:0 )
	xml? ( >=dev-libs/libxml2-2.7.3 )"

DEPEND="${CDEPEND}
	test? ( dev-util/valgrind )"

RDEPEND="${CDEPEND}
	virtual/mailx"

PATCHES=(
	"${FILESDIR}"/${P}-shadow_dlopen.patch
	"${FILESDIR}"/${P}-condor_config.generic.patch
	"${FILESDIR}"/${P}-Apply-the-users-condor_config-last-rather-than-first.patch
	"${FILESDIR}"/${P}-packaging_directories.patch
	"${FILESDIR}"/fix_sandbox_violations-8.0.0.patch
)

pkg_setup() {
	enewgroup condor
	enewuser condor -1 "${ROOT}"bin/bash "${ROOT}var/lib/condor" condor
}

src_configure() {
	# All the hard coded -DWITH_X=OFF flags are for packages that aren't in portage
	# I also haven't included support for HAVE_VMWARE because I don't know what it requires
	local mycmakeargs="
		-DCONDOR_PACKAGE_BUILD=ON
		-DCMAKE_INSTALL_PREFIX=/
		-DWITH_BLAHP=OFF
		-DWITH_CAMPUSFACTORY=OFF
		-DWITH_CLUSTER_RA=OFF
		-DWITH_COREDUMPER=OFF
		-DWITH_CREAM=OFF
		-DWITH_GLOBUS=OFF
		-DWITH_LIBDELTACLOUD=OFF
		-DWITH_BLAHP=OFF
		-DWITH_QPID=OFF
		-DWITH_UNICOREGAHP=OFF
		-DWITH_VOMS=OFF
		-DWITH_WSO2=OFF
		-DWITH_MANAGEMENT=OFF
		$(cmake-utils_use_has boinc BACKFILL)
		$(cmake-utils_use_has boinc)
		$(cmake-utils_use_with cgroup LIBCGROUP)
		$(cmake-utils_use_want contrib)
		$(cmake-utils_use_with curl)
		$(cmake-utils_use_want doc MAN_PAGES)
		$(cmake-utils_use_with libvirt)
		$(cmake-utils_use_has X KBDD)
		$(cmake-utils_use_with kerberos KRB5)
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with python PYTHON_BINDINGS)
		$(cmake-utils_use minimal CLIPPED)
		$(cmake-utils_use_with soap AVIARY)
		$(cmake-utils_use_with soap GSOAP)
		$(cmake-utils_use_with ssl OPENSSL)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_with xml LIBXML2)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir /var/lib/condor
	dodir /var/log/condor
	dodir /var/run/condor
	dodir /var/lock/condor

	fperms 750 /var/lib/condor /var/log/condor
	fperms 755 /var/run/condor
	fperms 0775 /var/lock/condor
	fowners condor:condor /var/lib/condor /var/log/condor /var/run/condor
}
