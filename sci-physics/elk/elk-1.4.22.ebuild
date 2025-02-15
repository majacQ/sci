# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic fortran-2 multilib toolchain-funcs

DESCRIPTION="All-electron full-potential linearised augmented-plane wave (FP-LAPW)"
HOMEPAGE="http://elk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug lapack libxc mpi openmp perl test"

RDEPEND="
	lapack? (
		virtual/blas
		virtual/lapack )
	libxc? ( >=sci-libs/libxc-1.2.0-r1[fortran] )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	perl? ( dev-lang/perl )
	virtual/pkgconfig"

DOCS=( README  )

FORTRAN_STANDARD=90

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
		export CXX="mpic++"
	else
		tc-export FC F77 CC CXX
	fi

	use openmp && FORTRAN_NEED_OPENMP=1

	fortran-2_pkg_setup

	use openmp && append-flags -fopenmp
}

src_prepare() {
	rm -rf src/{BLAS,LAPACK} || die
	if use libxc; then
		sed -i -e's/^\(SRC_libxc =\)/#\1/' "${S}/src/Makefile" || die
	fi
	if use mpi; then
		sed -i -e's/^\(SRC_mpi =\)/#\1/' "${S}/src/Makefile" || die
	fi

	sed \
		-e "s: -o : ${LDFLAGS} -o :g" \
		-i src/{,eos,spacegroup}/Makefile || die
}

src_configure() {
	append-fflags -I/usr/include -I/usr/$(get_libdir)/finclude

	cat > make.inc <<- EOF
	MAKE = make
	F90 = $(tc-getFC)
	F90_OPTS = ${FCFLAGS}
	F77 = $(tc-getF77)
	F77_OPTS = ${FFLAGS}
	CC = $(tc-getCC)
	CXX = $(tc-getCXX)
	CFLAGS = ${CFLAGS}
	CXXFLAGS = ${CXXFLAGS}
	LD = $(tc-getLD)
	AR = $(tc-getAR)
	LIB_SYS =
	LIB_LPK = $($(tc-getPKG_CONFIG) --libs lapack)
	LIB_FFT = fftlib.a
	EOF

	if use libxc; then
		echo "LIB_XC = -L/usr/$(get_libdir) -lxc" >> make.inc
		echo "SRC_libxc = libxc_funcs.f90 libxc.f90 libxcifc.f90" >>make.inc
	fi
}

MAKEOPTS+=" -j1"

src_compile() {
	emake -C src fft
	emake -C src elk
	emake -C src/eos
	emake -C src/spacegroup
}

src_install() {
	dobin src/elk src/protex src/eos/eos src/spacegroup/spacegroup
	dobin utilities/elk-bands
	use perl && dobin utilities/xps_exc.pl utilities/se.pl
	dodoc README
	for doc in docs/*; do
		dodoc $doc
	done
	insinto /usr/share/${P}
	doins -r species utilities examples tests
}
