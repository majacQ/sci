# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic fortran-2 python-any-r1 toolchain-funcs versionator

MY_P="${PN}-$(replace_version_separator _ -)"

DESCRIPTION="Portable, Extensible Toolkit for Scientific Computation"
HOMEPAGE="http://www.mcs.anl.gov/petsc/"
SRC_URI="http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${MY_P}.tar.gz"

LICENSE="petsc"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="afterimage complex-scalars cxx debug doc
	fortran hdf5 hypre mpi mumps scotch sparse superlu threads X"
# Failed: boost imagemagick metis

# hypre and superlu curretly exclude each other due to missing linking to hypre
# if both are enabled
REQUIRED_USE="
	afterimage? ( X )
	hdf5? ( mpi )
	hypre? ( cxx mpi )
	mumps? ( mpi scotch )
	scotch? ( mpi )
	^^ ( hypre superlu )
"
#	imagemagick? ( X )

RDEPEND="
	virtual/blas
	virtual/lapack
	afterimage? ( media-libs/libafterimage )
	hdf5? ( sci-libs/hdf5[mpi?] )
	hypre? ( >=sci-libs/hypre-2.8.0b[mpi?] )
	mpi? ( virtual/mpi[cxx?,fortran?] )
	mumps? ( sci-libs/mumps[mpi?] sci-libs/scalapack )
	scotch? ( sci-libs/scotch[mpi?] )
	sparse? ( sci-libs/suitesparse >=sci-libs/cholmod-1.7.0 )
	superlu? ( sci-libs/superlu )
	X? ( x11-libs/libX11 )
"
#	boost? ( dev-libs/boost )
#	metis? ( sci-libs/parmetis )
#	imagemagick? ( media-gfx/imagemagick )

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	dev-util/cmake
"
# cmake is used for parallel building
# in some configuration setups, legacy build is used (slow)

#
# PETSc does not want its Makefiles to be invoked with anything higher than
# -j1. The underlying build system does automatically invoke a parallel
# build. This might not be what you want, but *hey* not your choice.
#
MAKEOPTS="${MAKEOPTS} -j1"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P%_*}-disable-rpath.patch
	sed -i -e 's%/usr/bin/env python%/usr/bin/env python2%' configure || die
}

src_configure() {
	# petsc uses --with-blah=1 and --with-blah=0 to en/disable options
	petsc_enable() {
		use "$1" && echo "--with-${2:-$1}=1" || echo "--with-${2:-$1}=0"
	}
	# add external library:
	# petsc_with use_flag libname libdir
	# petsc_with use_flag libname include linking_libs
	petsc_with() {
		local myuse p=${2:-${1}}
		if use ${1}; then
			myuse="--with-${p}=1"
			if [[ $# -ge 4 ]]; then
				myuse="${myuse} --with-${p}-include=${EPREFIX}${3}"
				shift 3
				myuse="${myuse} --with-${p}-lib=$@"
			else
				myuse="${myuse} --with-${p}-dir=${EPREFIX}${3:-/usr}"
			fi
		else
			myuse="--with-${p}=0"
		fi
		echo ${myuse}
	}

	# select between configure options depending on use flag
	petsc_select() {
		use "$1" && echo "--with-$2=$3" || echo "--with-$2=$4"
	}

	local mylang
	local myopt

	use cxx && mylang="cxx" || mylang="c"
	use debug && myopt="debug" || myopt="opt"

	# environmental variables expected by petsc during build
	export PETSC_DIR="${S}"
	export PETSC_ARCH="linux-gnu-${mylang}-${myopt}"

	if use debug; then
		strip-flags
		filter-flags -O*
	fi

	# C Support on Cxx builds is enabled if possible
	# i.e. when not using complex scalars
	# (no complex type for both available at the same time)

	if use threads; then
		ewarn "Threads support may be incomplete on $PN-3.3 release and is not officially supported."
		ewarn "Upstream recommends not to enable threads support for production runs."
	fi

	# run petsc configure script
	econf \
		scrollOutput=1 \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		--with-shared-libraries \
		--with-single-library \
		--with-clanguage=${mylang} \
		$(use cxx && ! use complex-scalars && echo "with-c-support=1") \
		--with-petsc-arch=${PETSC_ARCH} \
		--with-precision=double \
		--with-gnu-compilers \
		--with-blas-lapack-lib="$($(tc-getPKG_CONFIG) --libs lapack)" \
		$(petsc_enable debug debugging) \
		$(petsc_enable mpi) \
		$(petsc_select mpi cc mpicc $(tc-getCC)) \
		$(petsc_select mpi cxx mpicxx $(tc-getCXX)) \
		$(petsc_enable fortran) \
		$(use fortran && echo "$(petsc_select mpi fc mpif77 $(tc-getF77))") \
		$(petsc_enable mpi mpi-compilers) \
		$(petsc_enable threads pthread) \
		$(petsc_enable threads pthreadclasses) \
		$(petsc_select complex-scalars scalar-type complex real) \
		--with-windows-graphics=0 \
		--with-matlab=0 \
		--with-cmake=cmake \
		$(petsc_with afterimage afterimage \
			/usr/include/libAfterImage -lAfterImage) \
		$(petsc_with hdf5) \
		$(petsc_with hypre hypre \
			/usr/include/hypre -lHYPRE) \
		$(petsc_with sparse cholmod) \
		$(petsc_with superlu superlu \
			/usr/include/superlu -lsuperlu) \
		$(petsc_with X x) \
		$(petsc_with X x11) \
		$(petsc_with scotch ptscotch \
			/usr/include/scotch \
		[-lptesmumps,-lptscotch,-lptscotcherr,-lscotch,-lscotcherr]) \
		$(petsc_with mumps scalapack \
			/usr/include/scalapack -lscalapack) \
		$(petsc_with mumps mumps \
			/usr/include \
			[-lcmumps,-ldmumps,-lsmumps,-lzmumps,-lmumps_common,-lpord]) \
		--with-imagemagick=0 \
		--with-python=0

# not yet tested:
#		python bindings, netcdf
# non-working:
#		fftw: no mpi-implementaion available in gentoo

# failed dependencies, perhaps fixed in upstream soon:
#		$(petsc_with metis parmetis) \ # needs metis too (>=5.0.2)
#		$(petsc_with boost) \
#		$(petsc_with imagemagick imagemagick \
#			/usr/include/ImageMagick $($(tc-getPKG_CONFIG) --libs MagickCore)) \
}

src_install() {
	# petsc install structure is very different from
	# installing headers to /usr/include/petsc and lib to /usr/lib
	# it also installs many unneeded executables and scripts
	# so manual install is easier than cleanup after "emake install"
	insinto /usr/include/${PN}
	doins include/*.h*
	insinto /usr/include/${PN}/${PETSC_ARCH}/include
	doins ${PETSC_ARCH}/include/*
	if use fortran; then
		insinto /usr/include/${PN}/finclude
		doins include/finclude/*.h
	fi
	if ! use mpi ; then
		insinto /usr/include/${PN}/mpiuni
		doins include/mpiuni/*.h
	fi
	insinto /usr/include/${PN}/conf
	doins conf/{variables,rules,test}
	insinto /usr/include/${PN}/${PETSC_ARCH}/conf
	doins ${PETSC_ARCH}/conf/{petscrules,petscvariables,RDict.db}
	insinto /usr/include/${PN}/petsc-private
	doins include/petsc-private/*.h

	# fix configuration files: replace "${S}" by installed location
	sed -i \
		-e "s:"${S}"::g" \
		"${ED}"/usr/include/${PN}/${PETSC_ARCH}/include/petscconf.h \
		"${ED}"/usr/include/${PN}/${PETSC_ARCH}/conf/petscvariables || die
	sed -i \
		-e "s:-I/include:-I${EPREFIX}/usr/include/${PN}:g" \
		-e "s:-I/linux-gnu-cxx-opt/include:-I${EPREFIX}/usr/include/${PN}/${PETSC_ARCH}/include/:g" \
		"${ED}"/usr/include/${PN}/${PETSC_ARCH}/conf/petscvariables || die
	sed -i \
		-e "s:usr/lib:usr/$(get_libdir):g" \
		"${ED}"/usr/include/${PN}/${PETSC_ARCH}/include/petscconf.h || die

	# add information about installation directory and
	# PETSC_ARCH to environmental variables
	cat >> 99petsc <<- EOF
		PETSC_ARCH=${PETSC_ARCH}
		PETSC_DIR=${EPREFIX}/usr/include/${PN}
	EOF
	doenvd 99petsc

	dolib.so ${PETSC_ARCH}/lib/*.so

	if use doc ; then
		einfo "installing documentation (this could take a while)"
		dodoc docs/manual.pdf
		dohtml -r docs/*.html docs/changes docs/manualpages
	fi
}
