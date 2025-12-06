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

(define-module (day-1-secret-entrance main)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 textual-ports)
  #:export (main))

(define (parse-rotation x)
  "Parse the rotation instructions: \"L68\" => '(l 68)"
  (let ((direction (string->symbol (string-downcase (string-take x 1))))
        (places (string->number (string-drop x 1))))
    (list direction places)))

;;;
;;; ====== solve part 1 ======
;;;

(define (perform-rotation-part-1 rotation dial-and-count)
  (let* ((rotate-direction (car rotation))
         (rotate-n (cadr rotation))
         (position (car dial-and-count))
         (new-pos (modulo (if (eq? 'l rotate-direction)
                              (- position rotate-n)
                              (+ position rotate-n)) 100))
         (times-seen-zero (cadr dial-and-count)))
    (list new-pos
          (if (eq? 0 new-pos)
              (+ 1 times-seen-zero) times-seen-zero))))

(define (solve-for-part-1 initial-dial-state parsed-instructed-rotations)
  (let ((rs (fold perform-rotation-part-1 initial-dial-state
                  parsed-instructed-rotations)))
    (display (format #f
              "

Result part 1: final dial position: ~a, times seen zero: ~a
"
              (car rs)
              (cadr rs)))))

;;;
;;; ====== solve part 2 ======
;;;

(define (perform-rotation-part-2 rotation dial-and-count)
  (let* ((rotate-direction (car rotation))
         (rotate-n (cadr rotation))
         (position (car dial-and-count))
         (times-seen-zero (cadr dial-and-count))
         (mk-rot-quot-rem (lambda ()
                            (floor/ (if (eq? rotate-direction
                                             'r)
                                        (+ position rotate-n)
                                        (- position rotate-n)) 100)))
         (zero-visits-and-pos (call-with-values mk-rot-quot-rem
                                                (lambda (quot rem)
                                                  (list quot rem))))
         (new-pos (cadr zero-visits-and-pos))
         (cycle-zero-visits (+ (if (and (eq? 0 position)
                                        (eq? 'l rotate-direction)) 1 0)
                               (car zero-visits-and-pos)))
         (new-zero-visits (+ (abs cycle-zero-visits) times-seen-zero
                             (if (and (eq? rotate-direction
                                           'l)
                                      (eq? 0 new-pos)) 1 0))))
    (list new-pos new-zero-visits)))

(define (solve-for-part-2 initial-dial-state parsed-instructed-rotations)
  (let ((rs (fold perform-rotation-part-2 initial-dial-state
                  parsed-instructed-rotations)))
    (display (format #f
              "

Result part 2: final dial position: ~a, times passed through zero: ~a
"
              (car rs)
              (cadr rs)))))

(define (main)
  (display "\n🎄 AOC 2025 - DAY 1 - SECRET ENTRANCE\n")
  (let* ((parsed-rotations (map parse-rotation rotations))
         (dial-state '(50 0))
         (rs1 (solve-for-part-1 dial-state parsed-rotations))
         (rs2 (solve-for-part-2 dial-state parsed-rotations)))
    (display "\n❄️ DONE\n")))

;;;
;;; ====== Simple case =========
;;;

;; (define rotations
;;   '("L1000"))

;; ^
;; Result part 1: final dial position: 50, times seen zero: 0
;; Result part 2: final dial position: 50, times passed through zero: 10

;;;
;;; ====== Example from AOC case =========
;;;

;; (define rotations
;;   '("L68" "L30"
;;     "R48"
;;     "L5"
;;     "R60"
;;     "L55"
;;     "L1"
;;     "L99"
;;     "R14"
;;     "L82"))

;; ^
;; Result part 1: final dial position: 32, times seen zero: 3
;; Result part 2: final dial position: 32, times passed through zero: 6

;;;
;;; ====== Real AOC input =========
;;;
(define rotations
  (string-split (string-trim-both (get-string-all (open-input-file
                                                   "days/day-1-secret-entrance/input.txt")))
                #\newline))
