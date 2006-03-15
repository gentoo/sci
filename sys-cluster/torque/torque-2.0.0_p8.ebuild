# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit flag-o-matic eutils

MY_P="${P/_}"
DESCRIPTION="Resource manager and queuing system based on OpenPBS"
HOMEPAGE="http://www.clusterresources.com/products/torque/"
SRC_URI="http://www.clusterresources.com/downloads/torque/${MY_P}.tar.gz"

LICENSE="openpbs"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcltk X scp server doc"
PROVIDE="virtual/pbs"

# ed is used by makedepend-sh
DEPEND_COMMON="virtual/libc
			   X? ( virtual/x11 dev-lang/tk )
			   tcltk? ( dev-lang/tcl )
			   !virtual/pbs"
DEPEND="${DEPEND_COMMON}
		sys-apps/ed"
RDEPEND="${DEPEND_COMMON}
		 net-misc/openssh"
PDEPEND=">=sys-cluster/openpbs-common-1.1.0"

S="${WORKDIR}/${MY_P}"

SPOOL_LOCATION="/var/spool" # this needs to move to /var later on
PBS_SERVER_HOME="${SPOOL_LOCATION}/PBS/"

src_unpack() {
	unpack ${MY_P}.tar.gz
	export EPATCH_OPTS="-p1 -d ${S}"
	epatch ${FILESDIR}/${P}-respect-ldflags.patch \
		|| die "epatch for ldflags failed"
	epatch ${FILESDIR}/${P}-respect-destdir.patch \
		|| die "epatch for DESTDIR failed"
	epatch ${FILESDIR}/${P}-destdir-fixes.patch \
		|| die "epatch for gui DESTDIR failed"
	epatch ${FILESDIR}/${P}-setuid-safety.patch \
		|| die "epatch for setuid failed"
	epatch ${FILESDIR}/${P}-makedepend.patch \
		|| die "epatch for makedepend failed"

	sed -i \
		-e "s|/tmp/|\${TMPDIR}/|g" \
		${S}/buildutils/makedepend-sh || die "sed for makedepend failed"
}

src_compile() {
	
	local myconf
#	use X || myconf="--disable-gui"
#	use tcltk && myconf="${myconf} --with-tcl"
	use doc && myconf="${myconf} --enable-docs"
	append-flags -DJOB_DELETE_NANNY
	use amd64 && append-flags -fPIC

	./configure ${myconf} \
		$(use_enable X gui) \
		$(use_enable server) \
		$(use_with tcltk tcl) \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--libdir="\${exec_prefix}/$(get_libdir)/pbs" \
		--enable-mom \
		--enable-clients \
		--enable-shared \
		--enable-depend-cache \
		$(use_with scp) \
		$(use_enable tcltk tcl-qstat) \
		--set-server-home=${PBS_SERVER_HOME} \
		--set-environ=/etc/pbs_environment || die "./configure failed"

	emake || die "emake failed"
}

# WARNING
# OpenPBS is extremely stubborn about directory permissions. Sometimes it will
# just fall over with the error message, but in some spots it will just ignore
# you and fail strangely. Likewise it also barfs on our .keep files!
pbs_createspool() {
	root="$1"
	s="${SPOOL_LOCATION}"
	h="${PBS_SERVER_HOME}"
	sp="${h}/server_priv"
	einfo "Building spool directory under ${D}${h}"
	for a in \
			0755:${s} 0755:${h} 0755:${h}/aux 0700:${h}/checkpoint \
			0755:${h}/mom_logs 0751:${h}/mom_priv 0751:${h}/mom_priv/jobs \
			0755:${h}/sched_logs 0750:${h}/sched_priv \
			0755:${h}/server_logs \
			0750:${h}/server_priv 0755:${h}/server_priv/accounting \
			0750:${h}/server_priv/acl_groups 0750:${h}/server_priv/acl_hosts \
			0750:${h}/server_priv/acl_svr 0750:${h}/server_priv/acl_users \
			0750:${h}/server_priv/jobs 0750:${h}/server_priv/queues \
			1777:${h}/spool 1777:${h}/undelivered ;
	do
		d="${a/*:}"
		m="${a/:*}"
		if [ ! -d "${root}${d}" ]; then
			install -d -m${m} ${root}${d}
		else
			chmod ${m} ${root}${d}
		fi
	done
}

src_install() {
	# Make directories first
	pbs_createspool "${D}"

	einfo "Running make install"
	make DESTDIR=${D} install || die

	einfo "Doing docs & lib symlinks"
	dodoc INSTALL PBS_License.txt README.torque Release_Notes
	# Init scripts come from openpbs-common
	#newinitd ${FILESDIR}/pbs-init.d pbs
	#newconfd ${FILESDIR}/pbs-conf.d pbs
	dosym /usr/$(get_libdir)/pbs/libpbs.a /usr/$(get_libdir)/libpbs.a

	einfo "Handling /etc/pbs_environment and /var/spool/PBS/server_name"
	# this file MUST exist for PBS/Torque to work
	# but try to preserve any customatizations that the user has made
	dodir /etc
	if [ -f ${ROOT}/etc/pbs_environment ]; then
		cp ${ROOT}/etc/pbs_environment ${D}/etc/pbs_environment
	else
		touch ${D}/etc/pbs_environment
	fi

	if [ -f "${ROOT}/var/spool/PBS/server_name" ]; then
		cp "${ROOT}/var/spool/PBS/server_name" "${D}/var/spool/PBS/server_name"
	fi

	# The build script isn't alternative install location friendly,
	# So we have to fix some hard-coded paths in tclIndex for xpbs* to work
	for file in `find ${D} -iname tclIndex`
	do 
		sed -e "s/${D//\// }/ /" "${file}" > "${file}.new"
		mv "${file}.new" "${file}"
	done
}

pkg_postinst() {
	# make sure the damn directories exist
	pbs_createspool "${ROOT}"
	[ ! -f "${ROOT}/etc/pbs_environment" ] && touch "${ROOT}/etc/pbs_environment"
}

