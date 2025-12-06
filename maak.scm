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

(define-module (maak)
  #:declarative? #t
  #:use-module (maak maak))

(define (repl)
  "Development REPL."
  (time-machine-manifest-shell '("guile -L ./src"
                                 "-c '((@ (ares server) run-nrepl-server))'")))

(define (fmt)
  "Format Scheme source code files according to the Guix style guide."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")
     #:verbose? #t))

(define (run-day day)
  (time-machine-manifest-shell (list "guile" "-L ./days"
                                     (~ "-c '((@ (~a main) main))'" day))
                               #:verbose? #t))

(define (day-1)
  (run-day "day-1-secret-entrance"))

(define (day-2)
  (run-day "day-2-gift-shop"))

(define (day-3)
  (run-day "day-3-lobby"))

