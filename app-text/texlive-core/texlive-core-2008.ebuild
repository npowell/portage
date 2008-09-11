# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/texlive-core/texlive-core-2008.ebuild,v 1.1 2008/09/09 15:13:34 aballier Exp $

inherit eutils flag-o-matic toolchain-funcs libtool autotools texlive-common

PATCHLEVEL="7"
TEXMFD_VERSION="1"

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SLOT="0"
LICENSE="GPL-2 LPPL-1.3c"

TEXLIVE_BASICBIN_CONTENTS="bin-bibtex bin-dialog bin-dvipsk bin-getnonfreefonts bin-gsftopk bin-kpathsea bin-makeindex bin-mfware bin-tetex bin-texlive bin-texconfig glyphlist texlive.infra collection-basicbin"

TEXLIVE_FONTBIN_CONTENTS="fontinst mft bin-afm2pl bin-fontware bin-ps2pkm collection-fontbin"

TEXLIVE_BINEXTRA_CONTENTS="a2ping bin-bibtex8 bin-ctie bin-cweb bin-dtl bin-dvicopy bin-dvidvi bin-dviljk bin-dvipos bin-lacheck bin-patgen bin-pdftools bin-seetexk bin-texdoc bin-texware bin-tie bin-tpic2pdftex bin-web cweb dviasm hyphenex mkind-english mkjobtexmf pdfcrop synctex texcount collection-binextra"

TEXLIVE_CORE_INCLUDED_TEXMF="${TEXLIVE_BASICBIN_CONTENTS} ${TEXLIVE_FONTBIN_CONTENTS} ${TEXLIVE_BINEXTRA_CONTENTS}"

SRC_URI="mirror://gentoo/${P}.tar.lzma"

for i in ${TEXLIVE_CORE_INCLUDED_TEXMF}; do
	SRC_URI="${SRC_URI} mirror://gentoo/texlive-module-${i}-${PV}.tar.lzma"
done

# Fetch patches
SRC_URI="${SRC_URI} mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.lzma
	mirror://gentoo/${PN}-2008-texmf.d-${TEXMFD_VERSION}.tar.lzma"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="X doc source"

MODULAR_X_DEPEND="X? (
				x11-libs/libXmu
				x11-libs/libXp
				x11-libs/libXpm
				x11-libs/libICE
				x11-libs/libSM
				x11-libs/libXaw
				x11-libs/libXfont
	)"

RDEPEND="${MODULAR_X_DEPEND}
	!app-text/ptex
	!app-text/tetex
	!<app-text/texlive-2007
	!app-text/xetex
	!dev-tex/vntex
	!=dev-texlive/texlive-basic-2007*
	!app-text/xdvipdfmx
	sys-libs/zlib
	>=media-libs/libpng-1.2.1
	=media-libs/freetype-2*
	media-libs/fontconfig"

DEPEND="${RDEPEND}
	sys-apps/ed
	sys-devel/flex
	app-arch/lzma-utils"

# texdoc needs luatex.
PDEPEND="dev-tex/luatex"

S="${WORKDIR}/texlive-20080816-source"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mv "${WORKDIR}"/texmf* "${S}" || die "failed to move texmf files"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"

	elibtoolize

	cd libs/teckit
	AT_M4DIR="." eautoreconf
}

src_compile() {
	tc-export CC CXX AR
	econf \
		--bindir=/usr/bin \
		--datadir="${S}" \
		--with-system-freetype2 \
		--with-freetype2-include=/usr/include \
		--with-system-zlib \
		--with-system-pnglib \
		--without-texinfo \
		--without-dialog \
		--without-texi2html \
		--disable-multiplatform \
		--with-epsfwin \
		--with-mftalkwin \
		--with-regiswin \
		--with-tektronixwin \
		--with-unitermwin \
		--with-ps=gs \
		--without-psutils \
		--without-sam2p \
		--without-t1utils \
		--enable-ipc \
		--without-etex \
		--with-xetex \
		--without-dvipng \
		--without-dvipdfm \
		--without-dvipdfmx \
		--with-xdvipdfmx \
		--without-lcdf-typetools \
		--without-pdfopen \
		--without-ps2eps \
		--without-detex \
		--without-ttf2pk \
		--without-tex4htk \
		--without-cjkutils \
		--without-xdvik --without-oxdvik \
		--without-xindy \
		--without-luatex \
		--without-dvi2tty \
		--without-vlna \
		--enable-shared \
		$(use_with X x) \

	emake texmf=${TEXMF_PATH:-/usr/share/texmf} || die "emake failed"

	# Mimic updmap --syncwithtrees to enable only fonts installed
	# Code copied from updmap script
	for i in `egrep '^(Mixed)?Map' "texmf/web2c/updmap.cfg" | sed 's@.* @@'`; do
		texlive-common_is_file_present_in_texmf "$i" || echo "$i"
	done > "${T}/updmap_update"
	{
		sed 's@/@\\/@g; s@^@/^MixedMap[     ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
		sed 's@/@\\/@g; s@^@/^Map[  ]*@; s@$@$/s/^/#! /@' <"${T}/updmap_update"
	} > "${T}/updmap_update2"
	sed -f "${T}/updmap_update2" "texmf/web2c/updmap.cfg" >	"${T}/updmap_update3"\
		&& cat "${T}/updmap_update3" > "texmf/web2c/updmap.cfg"
}

src_test() {
	ewarn "Due to modular layout of texlive ebuilds,"
	ewarn "It would not make much sense to use tests into the ebuild"
	ewarn "And tests would fail anyway"
	ewarn "Alternatively you can try to compile any tex file"
	ewarn "Tex warnings should be considered as errors and reported"
	ewarn "You can also run fmtutil-sys --all and check for errors/warnings there"
}

src_install() {
	insinto /usr/share
	doins -r texmf texmf-dist || die "failed to install texmf trees"
	if use source ; then
		doins -r "${WORKDIR}"/tlpkg || die "failed to install tlpkg files"
	fi

	dodir ${TEXMF_PATH:-/usr/share/texmf}/web2c
	einstall bindir="${D}/usr/bin" texmf="${D}${TEXMF_PATH:-/usr/share/texmf}" run_texlinks="true" run_mktexlsr="true" || die "einstall failed"

	newsbin "${FILESDIR}/texmf-update2008" texmf-update

	# When X is disabled mf-nowin doesn't exist but some scripts expect it to
	# exist. Instead, it is called mf, so we symlink it to please everything.
	use X || dosym mf /usr/bin/mf-nowin

	docinto texk
	cd "${S}/texk"
	dodoc ChangeLog README || die "failed to install texk docs"

	docinto kpathesa
	cd "${S}/texk/kpathsea"
	dodoc BUGS ChangeLog NEWS PROJECTS README || die "failed to install kpathsea docs"

	docinto dviljk
	cd "${S}/texk/dviljk"
	dodoc ChangeLog README NEWS || die "failed to install dviljk docs"

	docinto dvipsk
	cd "${S}/texk/dvipsk"
	dodoc ChangeLog README || die "failed to install dvipsk docs"

	docinto makeindexk
	cd "${S}/texk/makeindexk"
	dodoc ChangeLog NEWS NOTES README || die "failed to install makeindexk docs"

	docinto ps2pkm
	cd "${S}/texk/ps2pkm"
	dodoc ChangeLog README README.14m || die "failed to install ps2pkm docs"

	docinto web2c
	cd "${S}/texk/web2c"
	dodoc ChangeLog NEWS PROJECTS README || die "failed to install web2c docs"

	use doc || rm -rf "${D}/usr/share/texmf/doc"
	use doc || rm -rf "${D}/usr/share/texmf-dist/doc"

	dodir /var/cache/fonts

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/texmf/web2c"' > "${D}/etc/env.d/98texlive"
	# populate /etc/texmf
	keepdir /etc/texmf/web2c

	# take care of updmap.cfg, fmtutil.cnf and texmf.cnf
	dodir /etc/texmf/{updmap.d,fmtutil.d,texmf.d,language.dat.d,language.def.d}

	# Remove fmtutil.cnf, it will be regenerated from /etc/texmf/fmtutil.d files
	# by texmf-update
	rm -f "${D}${TEXMF_PATH}/web2c/fmtutil.cnf"

	# Remove default texmf.cnf to ship our own, greatly based on texlive dvd's
	# texmf.cnf
	# It will also be generated from /etc/texmf/texmf.d files by texmf-update
	rm -f "${D}${TEXMF_PATH}/web2c/texmf.cnf"

	insinto /etc/texmf/texmf.d
	doins "${S}/texmf.d/"*.cnf || die "failed to install texmf.d configuration files"

	mv "${D}${TEXMF_PATH}/web2c/updmap.cfg"	"${D}/etc/texmf/updmap.d/00updmap.cfg" || die "moving updmap.cfg failed"

	# dvips config file
	keepdir /etc/texmf/dvips/config
	dodir /etc/texmf/dvips.d
	mv "${D}${TEXMF_PATH}/dvips/config/config.ps" "${D}/etc/texmf/dvips.d/00${PN}-config.ps" || die "moving config.ps failed"

	# Create symlinks from format to engines
	# This will avoid having to call texlinks in texmf-update
	cd "${S}"
	for i in texmf/fmtutil/format*.cnf; do
		[ -f "${i}" ] && etexlinks "${i}"
	done

	texlive-common_handle_config_files

	keepdir /usr/share/texmf-site

	dosym /etc/texmf/web2c/fmtutil.cnf ${TEXMF_PATH}/web2c/fmtutil.cnf
	dosym /etc/texmf/web2c/texmf.cnf ${TEXMF_PATH}/web2c/texmf.cnf
	dosym /etc/texmf/web2c/updmap.cfg ${TEXMF_PATH}/web2c/updmap.cfg
	dosym /etc/texmf/dvips/config/config.ps ${TEXMF_PATH}/dvips/config/config.ps

	# the virtex symlink is not installed
	# The links has to be relative, since the targets
	# is not present at this stage and MacOS doesn't
	# like non-existing targets
	dosym tex /usr/bin/virtex
	dosym pdftex /usr/bin/pdfvirtex

	# Keep it as that's where the formats will go
	keepdir /var/lib/texmf

	# Rename mpost to leave room for mplib
	mv "${D}/usr/bin/mpost" "${D}/usr/bin/mpost-${P}"
	dosym "mpost-${P}" /usr/bin/mpost

	# Ditto for pdftex
	mv "${D}/usr/bin/pdftex" "${D}/usr/bin/pdftex-${P}"
	dosym "pdftex-${P}" /usr/bin/pdftex
}

pkg_preinst() {
	# Remove stray files to keep the upgrade path sane
	if has_version =app-text/texlive-core-2007* ; then
		for i in pdftex/pdflatex aleph/aleph aleph/lamed omega/lambda omega/omega xetex/xetex xetex/xelatex tex/tex pdftex/etex pdftex/pdftex pdftex/pdfetex ; do
			for j in log fmt ; do
				local file="${ROOT}/var/lib/texmf/web2c/${i}.${j}"
				if [ -f "${file}" ] ; then
					elog "Removing stray ${file} from TeXLive 2007 install."
					rm -f "${file}"
				fi
			done
		done
		for j in base log ; do
			local file="${ROOT}/var/lib/texmf/web2c/metafont/mf.${j}"
			if [ -f "${file}" ] ; then
				elog "Removing stray ${file} from TeXLive 2007 install."
				rm -f "${file}"
			fi
		done
	fi
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi

	elog
	elog "If you have configuration files in /etc/texmf to merge,"
	elog "please update them and run /usr/sbin/texmf-update."
	elog
	ewarn "If you are migrating from an older TeX distribution"
	ewarn "Please make sure you have read:"
	ewarn "http://www.gentoo.org/proj/en/tex/texlive-migration-guide.xml"
	ewarn "in order to avoid possible problems"
	elog
	elog "TeXLive has been split in various ebuilds. If you are missing a"
	elog "package to process your TeX documents, you can install"
	elog "dev-tex/texmfind to easily search for them."
	elog
}
