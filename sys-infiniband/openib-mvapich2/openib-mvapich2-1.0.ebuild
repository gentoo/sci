# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran-2

# WARNING: this script is interactive - it requires user-input once to verify
# the type of HCA to configure for.  This needs to be fixed to take out the
# interactivity.

DESCRIPTION="MVAPICH2 MPI-over-infiniband package auto-configured for OpenIB"
HOMEPAGE="http://mvapich.cse.ohio-state.edu/"
SRC_URI="${HOMEPAGE}/download/mvapich2/mvapich2-${PV/_/-}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="debug large-cluster medium-cluster rdma threads"

RDEPEND="
	|| (
		(
			sys-infiniband/libibverbs
			sys-infiniband/libibumad
			sys-infiniband/libibmad
			rdma? ( sys-infiniband/librdmacm ) )
		sys-infiniband/openib-userspace )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/mvapich2-${PV/_/-}"

pkg_setup() {
	fortran-2_pkg_setup
	ARCH=
	VCLUSTER=_SMALL_CLUSTER
	HAVE_MPD_RING="-DUSE_MPD_RING"

	if use amd64; then
		if [ -n "`grep 'model name' </proc/cpuinfo |grep Intel`" ]; then
			ARCH=_EM64T_
		else
			ARCH=_X86_64_
		fi
	elif use x86; then
		ARCH=_IA32_
	elif use ia64; then
		ARCH=_IA64_
	elif use ppc64; then
		ARCH=_PPC64_
	else
		die "unsupported architecture"
	fi
}

src_compile() {
	if use large-cluster; then
		VCLUSTER=_LARGE_CLUSTER
	elif use medium-cluster; then
		VCLUSTER=_MEDIUM_CLUSTER
	fi

	source ${S/-beta2/}/make.mvapich2.detect

	# Check if SRQ is valid. for this platform.
	ENABLE_SRQ="-DSRQ"

	if [ "$HCA_COMPILE_FLAG" == "_MLX_PCI_X_" ]; then
		ENABLE_SRQ=""
	fi

	export LIBS="-libverbs -lpthread -libumad -libmad"
	if use rdma; then
		export LIBS="${LIBS} -lrdmacm"
		export CFLAGS="${CFLAGS} -DADAPTIVE_RDMA_FAST_PATH -DRDMA_CM"
	fi
	export CFLAGS="${CFLAGS} -D${ARCH} \
		-DUSE_INLINE -D_SMP_  \
		-D_GNU_SOURCE -DSRQ -DUSE_HEADER_CACHING -DLAZY_MEM_UNREGISTER \
		-DONE_SIDED -D${HCA_COMPILE_FLAG} -DMPID_USE_SEQUENCE_NUMBERS \
		${HAVE_MPD_RING} -D${VCLUSTER}"

	local myconf
	use debug && myconf="$myconf --enable-g=all --enable-debuginfo"
	use threads && myconf="$myconf --enable-threads=multiple"

	sed -i -e 's/ ${exec_prefix}/ ${DESTDIR}${exec_prefix}/' \
		-e 's/ ${libdir}/ ${DESTDIR}${libdir}/' ${S/-beta2/}/Makefile.in
	sed -i '/bindir/s/ ${bindir}/ ${DESTDIR}${bindir}/' ${S/-beta2/}/src/pm/mpd/Makefile.in
	cd ${S/-beta2/}
	econf \
		--with-device=osu_ch3:mrail --with-rdma=gen2 --with-pm=mpd \
		--disable-romio --without-mpe \
		$myconf ${EXTRA_ECONF} \
			|| die "could not configure"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc CHANGES_MPICH2 COPYRIGHT COPYRIGHT_MVAPICH2 LICENSE.TXT \
		README* RELEASE_NOTES*
}

pkg_postinst() {
	einfo "To allow normal users to use infiniband, it is necessary to"
	einfo "increase the system limits on locked memory."
	einfo "You must increase the kernel.shmmax sysctl value, and increase"
	einfo "the memlock limits in /etc/security/limits.conf.  i.e.:"
	echo
	einfo "echo 'kernel.shmmax = 512000000' >> /etc/sysctl.conf"
	einfo "echo 512000000 > /proc/sys/kernel/shmmax"
	einfo "echo -e '* soft memlock 500000\n* hard memlock 500000' > /etc/security/limits.conf"
}

