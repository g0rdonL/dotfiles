;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)
(package! csv-mode)
(package! vimrc-mode)
(package! elcord)
(package! ssh-agency)
(package! doas-edit
  :recipe (:host github :repo "cemkeylan/doas-edit"))
(package! vlf :recipe (:host github :repo "m00natic/vlfi" :files ("*.el"))
  :pin "cc02f2533782d6b9b628cec7e2dcf25b2d05a27c" :disable t)
(package! systemd :pin "b6ae63a236605b1c5e1069f7d3afe06ae32a7bae")
(package! writeroom-mode :disable t)
(package! flycheck-popup-tip :disable t)
