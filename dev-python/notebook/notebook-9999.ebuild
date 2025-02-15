# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 git-r3

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="http://jupyter.org"
EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE="doc test"
RDEPEND="
	>=dev-libs/mathjax-2.4
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.3.3[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/traitlets[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.2.0[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		www-client/casperjs
	)
	doc? (
		app-text/pandoc
		>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1[${PYTHON_USEDEP}]
	)
	"

python_prepare_all() {
	sed \
		-e "/import setup/s:$:\nimport setuptools:g" \
		-i setup.py || die

	# disable bundled mathjax
	sed -i 's/^.*MathJax.*$//' bower.json || die
	sed -i 's/mj(/#mj(/' setupbase.py || die

	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	nosetests --with-coverage --cover-package=notebook notebook || die

	"${PYTHON}" -m notebook.jstest base || die
	"${PYTHON}" -m notebook.jstest notebook || die
	"${PYTHON}" -m notebook.jstest services || die
	"${PYTHON}" -m notebook.jstest tree || die
}

python_install() {
	distutils-r1_python_install

	ln -sf "${EPREFIX}/usr/share/mathjax" "${D}$(python_get_sitedir)/notebook/static/components/MathJax" || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}

pkg_preinst() {
	# remove old mathjax folder if present
	rm -rf "${EROOT}"/usr/lib*/python*/site-packages/notebook/static/components/MathJax
}
