# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils eutils flag-o-matic java-pkg-2

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks debug doc examples java opengl smp"

RDEPEND="
	<dev-lang/tcl-8.6:0
	<dev-lang/tk-8.6:0
	<dev-tcltk/itcl-4.0
	<dev-tcltk/itk-4.0
	dev-tcltk/iwidgets
	dev-tcltk/tkimg
	dev-tcltk/tkpng
	media-libs/urt
	media-libs/libpng:0
	sci-libs/jama
	>=sci-libs/tnt-3
	sys-libs/libtermcap-compat
	sys-libs/zlib
	x11-libs/libXt
	x11-libs/libXi
	java? ( >=virtual/jre-1.5:* )
	"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-tcltk/tktable
	>=virtual/jre-1.5:*
	doc? (
		dev-libs/libxslt
		app-doc/doxygen
	)"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

src_prepare() {
	default
	filter-flags -std=c++0x
}

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BRLCAD_DIR}"
		-DBRLCAD_ENABLE_STRICT=NO
		-DBRLCAD-ENABLE_COMPILER_WARNINGS=NO
		-DBRLCAD_BUNDLED_LIBS=ON
		-DBRLCAD_FLAGS_OPTIMIZATION=ON
		-DBRLCAD_ENABLE_X11=ON
		-DCMAKE_BUILD_TYPE=Release
		)

		# use flag triggered options
	if use debug; then
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Debug"
	else
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Release"
	fi
	mycmakeargs+=(
		-DBRLCAD_ENABLE_OPENGL=$(usex opengl)
#experimental RTGL support
	#	-DBRLCAD_ENABLE_RTGL=$(usex opengl)
		-DBRLCAD_ENABLE_64BIT=$(usex amd64)
		-DBRLCAD_ENABLE_SMP=$(usex smp)
	#	-DBRLCAD_ENABLE_RTSERVER=$(usex java)
		-DBRLCAD_INSTALL_EXAMPLE_GEOMETRY=$(usex examples)
		-DBRLCAD_EXTRADOCS=$(usex doc)
		-DBRLCAD_EXTRADOCS_PDF=$(usex doc)
		-DBRLCAD_EXTRADOCS_MAN=$(usex doc)
		-DBRLCAD_ENABLE_VERBOSE_PROGRESS=$(usex debug)
			)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
	#emake check || die "emake check failed"
	if use benchmarks; then
		emake benchmark
	fi
}

src_install() {
	cmake-utils_src_install
	rm -f "${ED}"usr/share/brlcad/{README,NEWS,AUTHORS,HACKING,INSTALL,COPYING} || die
	dodoc AUTHORS NEWS README HACKING TODO BUGS ChangeLog
	cat >> 99brlcad <<- EOF
	"PATH=\"${BRLCAD_DIR}/bin\""
	"MANPATH=\"${BRLCAD_DIR}/man\""
	EOF
	doenvd 99brlcad
	newicon misc/macosx/Resources/ReadMe.rtfd/brlcad_logo_tiny.png brlcad.png
	make_desktop_entry mged "BRL-CAD" brlcad "Graphics;Engineering"
}
