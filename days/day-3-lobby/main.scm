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

(define-module (day-3-lobby main)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 textual-ports)
  #:export (main))

(define (max-subsequence digits current-subsequence drops max-len)
  (cond
    ;; Input exhausted. Return the result (truncated to max-len).
    ((null? digits)
     (take current-subsequence max-len))

    ;; Max length reached, and we have no more drops.
    ((and (= (length current-subsequence) max-len)
          (= drops 0))
     current-subsequence)

    (else (let ((current-digit (car digits))
                (rest-digits (cdr digits)))
            
            (define (pop-while-less acc current-drops)
              (cond
                ;; Stop if:
                ;; stack is empty, drops are used, or tail >= d
                ((or (null? acc)
                     (= current-drops 0)
                     (>= (car (reverse acc)) current-digit))
                 (max-subsequence rest-digits
                                  (append acc
                                          (list current-digit)) current-drops
                                  max-len))

                ;; Greedy Pop: Last element is smaller, and we can still drop it.
                (else (pop-while-less (drop-right acc 1)
                                      (- current-drops 1)))))

            (pop-while-less current-subsequence drops)))))

(define* (solve-bank b
                     #:key (batteries 2))
  (let* ((digits (map (lambda (c)
                        (- (char->integer c)
                           (char->integer #\0)))
                      (string->list b)))
         (total-len (length digits))
         (drops (- total-len batteries))
         (result-list (max-subsequence digits
                                       '() drops batteries)))
    
    (string->number (string-join (map number->string result-list) ""))))

(define (main)
  (display "\n🎄 AOC 2025 - DAY 3 - LOBBY\n")
  (let* ((largest-jolts-pt-1 (map (lambda (b)
                                    (solve-bank b
                                                #:batteries 2)) batteries))
         (jolts-sum-pt-1 (fold (lambda (x y)
                                 (+ x y)) 0 largest-jolts-pt-1))
         (largest-jolts-pt-2 (map (lambda (b)
                                    (solve-bank b
                                                #:batteries 12)) batteries))
         (jolts-sum-pt-2 (fold (lambda (x y)
                                 (+ x y)) 0 largest-jolts-pt-2)))
    (display (format #f "\npt1. largest jolts: ~a\n" largest-jolts-pt-1))
    (display (format #f "\npt1. sum of jolts: ~a\n" jolts-sum-pt-1))
    (display (format #f "\npt2. largest jolts: ~a\n" largest-jolts-pt-2))
    (display (format #f "\npt2. sum of jolts: ~a\n" jolts-sum-pt-2)))
  (display "\n❄️ DONE\n"))

;;;
;;; ====== INPUTS ======
;;;

;; (define batteries
;;   '("987654321111111" "811111111111119" "234234234234278" "818181911112111"))
;;
;; ^
;; pt1. largest jolts: (98 89 78 92)
;; pt1. sum of jolts: 357
;; pt2. largest jolts: (987654321111 811111111119 434234234278 888911112111)
;; pt2. sum of jolts: 3121910778619

(define batteries
  (let* ((string-file-contents (string-trim-both (get-string-all (open-input-file
                                                                  "days/day-3-lobby/input.txt"))))
         (raw-batteries (string-split string-file-contents #\newline)))
    raw-batteries))
;;
;; ^
;; pt1. largest jolts: (99 99 88 88 65 98 99 52 98 99 99 98 75 77 98 65 87 65 66 86 77 66 99 55 55 77 98 77 88 75 99 88 87 89 74 97 99 98 99 77 88 66 99 99 99 75 87 77 99 99 99 89 66 76 99 99 87 98 87 65 99 55 87 88 88 98 98 65 88 99 88 87 76 85 88 97 99 99 99 86 66 97 88 97 86 98 87 99 88 75 99 87 99 98 85 99 99 53 77 54 54 99 99 77 98 97 99 88 99 99 99 98 99 95 98 55 75 89 87 99 86 99 98 87 96 97 76 66 98 97 88 99 65 84 44 63 88 66 66 88 55 89 77 87 96 76 99 76 77 96 77 88 88 89 99 99 87 87 75 93 98 87 85 97 66 75 74 85 77 98 65 86 99 99 99 99 95 66 75 88 85 98 97 76 99 99 86 75 88 97 77 88 96 98 98 76 66 99 99 99)

;; pt1. sum of jolts: 17301

