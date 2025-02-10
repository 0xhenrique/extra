;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Sou Bunnbu <iyzsong@gmail.com>
;;; Copyright © 2016, 2023 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2017 Nikita <nikita@n0.is>
;;; Copyright © 2019 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2023 Andy Tai <atai@atai.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages fvwm)
  #:use-module ((guix licenses) #:select (gpl2+ gpl3))
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages compton)
  #:use-module (gnu packages dunst)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gkrellm)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages stalonetray)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define-public fvwm
  (package
   (name "fvwm")
   (version "2.7.0")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/fvwmorg/fvwm/releases/download/"
                  version "/fvwm-" version ".tar.gz"))
            (sha256
             (base32
              "12s1wgkvrvl8m62gpb2918izfx9ysj7hgn9p00blfi3p1gb6v0k6"))))
   (build-system gnu-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases
		     (add-after 'install 'install-xsession
				(lambda* (#:key outputs #:allow-other-keys)
				  (let* ((out (assoc-ref outputs "out"))
					 (xsessions (string-append out "/share/xsessions")))
				    (mkdir-p xsessions)
				    (make-desktop-entry-file
				     (string-append xsessions "/fvwm2.desktop")
				     #:name "FVWM"
				     #:exec (string-append out "/bin/" ,name)
				     #:comment '("FVWM")))
				  #t)))))
   (native-inputs
    `(("perl" ,perl)
      ("pkg-config" ,pkg-config)
      ("xsltproc" ,libxslt)))
   (inputs
    (list fribidi
          libpng
          (librsvg-for-system)
          libxcursor
          libxext
          libxft
          libxinerama
          libxpm
          libxt
          readline))
   (synopsis "Virtual window manager for X11")
   (description
    "FVWM is an extremely powerful ICCCM-compliant multiple virtual desktop
window manager for the X Window system.")
   (home-page "https://www.fvwm.org/")
   (license gpl2+)))

(define-public nscde
  (package
   (name "nscde")
   (version "2.3")
   (source (origin
	    (method url-fetch)
	    (uri (string-append
		  "https://github.com/NsCDE/NsCDE/archive/refs/tags/"
		  version ".tar.gz"))
	    (sha256
	     (base32
	      "15xjars33k16w1sn6xlmbdfrn6183ah3yj5p8igqc6whdgqxakzw"))))
   (build-system gnu-build-system)
   (native-inputs (list pkg-config mksh))
   (inputs (list gettext-minimal
		 fvwm
		 font-dejavu
		 fribidi
		 dunst
		 gkrellm
		 gtk+
		 imagemagick
		 libxpm
		 libxext
		 libxft
		 libxt
		 rofi
		 picom
		 python
		 python-pyyaml
		 python-qtpy
		 stalonetray
		 xclip
		 xdpyinfo
		 xorg-rgb
		 xprop
		 xrefresh
		 xscreensaver
		 xset
		 xsettingsd
		 xterm))
   (synopsis "Not so Common Desktop Environment")
   (description "Modern and functional CDE desktop based on FVWM.")
   (home-page "https://github.com/NsCDE/NsCDE")
   (license gpl3)))
