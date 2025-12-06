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

(define-module (day-2-gift-shop main)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 textual-ports)
  #:export (main))

(define (list-flatten lst)
  (append-map (lambda (x)
                (if (list? x) x
                    (list x))) lst))

;; Let the number 𝑁 have k digits.
;; For 𝑁 to be “a block repeated twice”, we need:
;; k must be even.
;; When Split the digits into two halves of length 
;; k/2. The two halves must be equal.
(define (double-block-number? n)
  "Return #t if N is made of some digit block repeated exactly twice."
  (let* ((s (number->string n))
         (len (string-length s)))
    (and (even? len)
         (let* ((m (/ len 2))
                (first (substring s 0 m))
                (second (substring s m len)))
           (string=? first second)))))

(define (double-pattern-repeats? n)
  (let* ((s (number->string n))
         (ss (string-append s s)))
    ;; search s inside (s+s) but ignore the prefix and suffix copies
    (let ((found (string-contains ss s 1)))
      (and found
           (< found
              (- (string-length ss)
                 (string-length s)))))))

(define* (scan-for-invalids range
                            #:key (with-advanced-invalid-check? #t))
  (let* ((iota-num (+ 1
                      (- (cadr range)
                         (car range))))
         (lls (iota iota-num
                    (car range) 1))
         (is (map (lambda (num)
                    (list num
                          (or (double-block-number? num)
                              (if with-advanced-invalid-check?
                                  (double-pattern-repeats? num) #f)))) lls))
         (invalids (filter cadr is)))
    invalids))

(define (main)
  (display "\n🎄 AOC 2025 - DAY 2 - GIFT SHOP\n")
  (let* ((invalids-pt-1 (map car
                             (list-flatten (map (lambda (i)
                                                  (scan-for-invalids i
                                                                     #:with-advanced-invalid-check?
                                                                     #f))
                                                ranges))))
         (invalids-sum-pt-1 (fold (lambda (x y)
                                    (+ x y)) 0 invalids-pt-1))
         (invalids-pt-2 (map car
                             (list-flatten (map (lambda (i)
                                                  (scan-for-invalids i
                                                                     #:with-advanced-invalid-check?
                                                                     #t))
                                                ranges))))
         (invalids-sum-pt-2 (fold (lambda (x y)
                                    (+ x y)) 0 invalids-pt-2)))
    (display (format #f "\npt1. found invalid numbers: ~a\n" invalids-pt-1))
    (display (format #f "\npt1. sum of invalids: ~a\n" invalids-sum-pt-1))
    (display (format #f "\npt2. found invalid numbers: ~a\n" invalids-pt-2))
    (display (format #f "\npt2. sum of invalids: ~a\n" invalids-sum-pt-2)))
  (display "\n❄️ DONE\n"))

;; (define ranges
;;   '((11 22)
;;     (95 115)
;;     (998 1012)
;;     (1188511880 1188511890)
;;     (222220 222224)
;;     (1698522 1698528)
;;     (446443 446449)
;;     (38593856 38593862)
;;     (565653 565659)
;;     (824824821 824824827)
;;     (2121212118 2121212124)))
;; ^
;; sum of invalids pt.1: 1227775554
;;                pt 2: 4174379265

(define ranges
  (let* ((string-file-contents (string-trim-both (get-string-all (open-input-file
                                                                  "days/day-2-gift-shop/input.txt"))))
         (raw-ranges (string-split string-file-contents #\,)))
    (map (lambda (r)
           (map string->number
                (string-split r #\-))) raw-ranges)))
