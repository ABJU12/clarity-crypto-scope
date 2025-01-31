;; CryptoScope Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-address (err u101))
(define-constant err-not-tracked (err u102))
(define-constant max-tx-per-page u50)

;; Data structures
(define-map tracked-addresses principal bool)
(define-map transaction-logs 
  { address: principal, tx-id: uint }
  { amount: uint, timestamp: uint, tx-type: (string-ascii 12) }
)

;; Data vars
(define-data-var next-tx-id uint u0)

;; Public functions
(define-public (add-tracked-address (address principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set tracked-addresses address true))
  )
)

(define-public (remove-tracked-address (address principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-delete tracked-addresses address))
  )
)

(define-public (log-transaction (address principal) (amount uint) (tx-type (string-ascii 12)))
  (let
    (
      (tx-id (var-get next-tx-id))
    )
    (asserts! (map-get? tracked-addresses address) err-not-tracked)
    (map-set transaction-logs
      { address: address, tx-id: tx-id }
      { amount: amount, timestamp: block-height, tx-type: tx-type }
    )
    (var-set next-tx-id (+ tx-id u1))
    (ok tx-id)
  )
)

;; Read only functions
(define-read-only (is-tracked-address (address principal))
  (default-to false (map-get? tracked-addresses address))
)

(define-read-only (get-transaction (address principal) (tx-id uint))
  (map-get? transaction-logs { address: address, tx-id: tx-id })
)

(define-read-only (get-transactions-page (address principal) (page uint))
  (let
    (
      (start-id (* page max-tx-per-page))
      (end-id (+ start-id max-tx-per-page))
    )
    (filter not-none 
      (map 
        (lambda (id) 
          (map-get? transaction-logs { address: address, tx-id: id })
        )
        (list-range-uint start-id end-id)
      )
    )
  )
)
