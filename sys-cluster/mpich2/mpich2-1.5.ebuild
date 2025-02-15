# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran

inherit fortran-2 mpi

MY_PV=${PV/_/}
DESCRIPTION="A high performance and portable MPI implementation"
HOMEPAGE="http://www.mcs.anl.gov/research/projects/mpich2/index.php"
SRC_URI="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/${MY_PV}/${PN}-${MY_PV}.tar.gz"

SLOT="0"
LICENSE="mpich2"
KEYWORDS="~amd64 ~x86"
IUSE="+cxx doc fortran mpi-threads romio threads"

COMMON_DEPEND="
	dev-libs/libaio
	sys-apps/hwloc
	romio? ( net-fs/nfs-utils )
	$(mpi_imp_deplist)"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	FORTRAN_STANDARD="77 90"
	fortran-2_pkg_setup
	MPI_ESELECT_FILE="eselect.mpi.mpich2"

	if use mpi-threads && ! use threads; then
		ewarn "mpi-threads requires threads, assuming that's what you want"
	fi

	if mpi_classed; then
		MPD_CONF_FILE_DIR=/etc/$(mpi_class)
	else
		MPD_CONF_FILE_DIR=/etc/${PN}
	fi

}

src_prepare() {
	# Using MPICH2LIB_LDFLAGS doesn't seem to full work.
	sed -i 's| *@WRAPPER_LDFLAGS@ *||' \
		src/packaging/pkgconfig/mpich2.pc.in \
		src/env/*.in \
		|| die
}

src_configure() {
	local c="--enable-shared"

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	if use mpi-threads; then
		# MPI-THREAD requries threading.
		c="${c} --with-thread-package=pthreads"
		c="${c} --enable-threads=runtime"
	else
		if use threads ; then
			c="${c} --with-thread-package=pthreads"
		else
			c="${c} --with-thread-package=none"
		fi
		c="${c} --enable-threads=single"
	fi

	if ! mpi_classed; then
		c="${c} --sysconfdir=${EPREFIX}/etc/${PN}"
		c="${c} --docdir=${EPREFIX}/usr/share/doc/${PF}"
	else
		c="${c} --docdir=$(mpi_root)/usr/share/doc/${PF}"
	fi

	export MPICH2LIB_CFLAGS=${CFLAGS}
	export MPICH2LIB_CPPFLAGS=${CPPFLAGS}
	export MPICH2LIB_CXXFLAGS=${CXXFLAGS}
	export MPICH2LIB_FFLAGS=${FFLAGS}
	export MPICH2LIB_FCFLAGS=${FCFLAGS}
	export MPICH2LIB_LDFLAGS=${LDFLAGS}
	unset CFLAGS CPPFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS

	econf $(mpi_econf_args) ${c} \
		--with-pm=hydra \
		--disable-mpe \
		--disable-fast \
		--enable-smpcoll \
		--enable-versioning \
		$(use_enable romio) \
		$(use_enable cxx) \
		$(use_enable fortran f77) \
		$(use_enable fortran fc)
}

src_test() {
	emake -j1 check
}

src_install() {
	local d=$(echo ${ED}/$(mpi_root)/ | sed 's,///*,/,g')

	default

	mpi_dodir /usr/share/doc/${PF}
	mpi_dodoc COPYRIGHT README{,.envvar} CHANGES RELEASE_NOTES
	mpi_newdoc src/pm/hydra/README README.hydra
	if use romio; then
		mpi_newdoc src/mpi/romio/README README.romio
	fi

	if ! use doc; then
		rm -rf "${d}"usr/share/doc/${PF}/www*
	fi

	mpi_imp_add_eselect
}
