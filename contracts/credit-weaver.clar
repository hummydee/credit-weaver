;; ============================================================
;; Contract: credit-weaver.clar
;; Purpose : On-chain usage credit system for protocols
;; ============================================================

;; -------------------------
;; ERRORS
;; -------------------------
(define-constant ERR-NOT-OWNER         (err u12001))
(define-constant ERR-NOT-USER          (err u12002))
(define-constant ERR-INSUFFICIENT      (err u12003))

;; -------------------------
;; CONSTANTS
;; -------------------------
(define-constant contract-owner tx-sender)

;; -------------------------
;; STORAGE
;; -------------------------

;; user principal => credits
(define-map credits
  principal
  uint
)

;; optional list of authorized credit issuers
(define-map issuers
  principal
  bool
)

;; -------------------------
;; READ-ONLY HELPERS
;; -------------------------

(define-read-only (is-owner?)
  (is-eq tx-sender contract-owner)
)

(define-read-only (is-issuer? (who principal))
  (default-to false (map-get? issuers who))
)

;; -------------------------
;; OWNER CONTROLS
;; -------------------------

(define-public (add-issuer (issuer principal))
  (begin
    (asserts! (is-owner?) ERR-NOT-OWNER)
    (asserts! (not (is-eq issuer (as-contract tx-sender))) ERR-NOT-USER)
    (map-set issuers issuer true)
    (ok true)
  )
)

(define-public (remove-issuer (issuer principal))
  (begin
    (asserts! (is-owner?) ERR-NOT-OWNER)
    (asserts! (not (is-eq issuer (as-contract tx-sender))) ERR-NOT-USER)
    (map-delete issuers issuer)
    (ok true)
  )
)

;; -------------------------
;; CREDIT MANAGEMENT
;; -------------------------

(define-public (award-credits
  (user principal)
  (amount uint)
)
  (begin
    (asserts! (or (is-owner?) (is-issuer? tx-sender)) ERR-NOT-OWNER)
    (asserts! (> amount u0) ERR-INSUFFICIENT)
    (asserts! (not (is-eq user (as-contract tx-sender))) ERR-NOT-USER)

    (let ((current (default-to u0 (map-get? credits user))))
      (map-set credits user (+ current amount))
    )

    (ok true)
  )
)

(define-public (redeem-credits
  (amount uint)
)
  (let ((current (default-to u0 (map-get? credits tx-sender))))
    (begin
      (asserts! (>= current amount) ERR-INSUFFICIENT)
      (map-set credits tx-sender (- current amount))
      (ok amount)
    )
  )
)

;; -------------------------
;; READ-ONLY INTERFACE
;; -------------------------

(define-read-only (get-credits (user principal))
  (default-to u0 (map-get? credits user))
)

(define-read-only (can-redeem? (user principal) (amount uint))
  (>= (get-credits user) amount)
)
