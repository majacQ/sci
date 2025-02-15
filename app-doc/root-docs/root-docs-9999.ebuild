# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ROOT_PN="root"
ROOFIT_DOC_PV=2.91-33
ROOFIT_QS_DOC_PV=3.00
TMVA_DOC_PV=4.2.0

inherit eutils git-r3 multilib virtualx

DESCRIPTION="Documentation for ROOT Data Analysis Framework"
HOMEPAGE="http://root.cern.ch/drupal"
SRC_URI=""
EGIT_REPO_URI="http://root.cern.ch/git/root.git"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE="api +math +metric http"

VIRTUALX_REQUIRED="api"

DEPEND="
	app-text/pandoc
	app-text/texlive
	dev-haskell/pandoc-citeproc[bibutils]
	virtual/pkgconfig
	api? (
		media-fonts/dejavu
		~sci-physics/root-${PV}[X,graphviz,opengl]
	)"
RDEPEND=""

DOC_DIR="/usr/share/doc/${ROOT_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.00.01-makehtml.patch
)

src_prepare() {
	default
	# prefixify the configure script
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		configure || die "prefixify configure failed"
}

src_configure() {
	# we need only to setup paths here, html docs doesn't depend on USE flags
	if use api; then
		./configure \
			--prefix="${EPREFIX}/usr" \
			--etcdir="${EPREFIX}/etc/root" \
			--libdir="${EPREFIX}/usr/$(get_libdir)/${PN}" \
			--docdir="${EPREFIX}/usr/share/doc/${PF}" \
			--tutdir="${EPREFIX}/usr/share/doc/${PF}/examples/tutorials" \
			--testdir="${EPREFIX}/usr/share/doc/${PF}/examples/tests" \
			--with-llvm-config="${EPREFIX}/usr/bin/llvm-config" \
			--with-sys-iconpath="${EPREFIX}/usr/share/pixmaps" \
			--nohowto
	fi
}

src_compile() {
	pdf_target=( primer users-guide )
	local pdf_size=pdfa4
	use metric || pdf_size=pdfletter
	use math && pdf_target+=( minuit2 spectrum )
	use http && pdf_target+=( HttpServer JSROOT )

	local i
	for (( i=0; i<${#pdf_target[@]}; i++ )); do
		emake -C documentation/"${pdf_target[i]}" "${pdf_size}"
	done

	if use api; then
		# video drivers may want to access hardware devices
		cards=$(echo -n /dev/dri/card* /dev/ati/card* /dev/nvidiactl* | sed 's/ /:/g')
		[[ -n "${cards}" ]] && addpredict "${cards}"

		ROOTSYS="${S}" Xemake html
		# if root.exe crashes, return code will be 0 due to gdb attach,
		# so we need to check if last html file was generated;
		# this check is volatile and can't catch crash on the last file.
		[[ -f htmldoc/WindowAttributes_t.html ]] || die "html doc generation crashed"
	fi
}

src_install() {
	insinto "${DOC_DIR}"

	local i
	for (( i=0; i<${#pdf_target[@]}; i++ )); do
		doins documentation/"${pdf_target[i]}"/*.pdf
	done
	unset pdf_target

	use math && doins \
		"${DISTDIR}/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf" \
		"${DISTDIR}/roofit_quickstart_${ROOFIT_QS_DOC_PV}.pdf" \
		"${DISTDIR}/TMVAUsersGuide-v${TMVA_DOC_PV}.pdf"

	if use api; then
		# Install offline replacements for online messages
		cp "${DISTDIR}"/{root6-banner.jpg,info.png} htmldoc/ || die "cp failed"
		# too large data to copy
		dodir "${DOC_DIR}/html"
		mv htmldoc/* "${ED}${DOC_DIR}/html/" || die
		docompress -x ${DOC_DIR}/html
	fi
}
