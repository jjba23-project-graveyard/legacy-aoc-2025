;;; aoc-2025

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; aoc-2025 is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; aoc-2025 is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with aoc-2025.  If not, see <https://www.gnu.org/licenses/>.

(use-modules (guix packages)
             (gnu)
             (guix utils)
             (guix download)
             (gnu packages guile)
             (gnu packages guile-xyz)
             (guix build-system guile)
             (gnu packages linux)
             ((guix licenses)
              #:prefix license:))

(packages->manifest (list guile-3.0 guile-ares-rs))

