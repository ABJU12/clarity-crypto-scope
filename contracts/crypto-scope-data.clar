;; CryptoScope Data Contract

;; Constants
(define-constant err-invalid-period (err u103))

;; Maps for statistics
(define-map address-stats
  principal
  { total-tx: uint, total-volume: uint, last-active: uint }
)

;; Public functions
(define-public (update-stats (address principal) (amount uint))
  (let
    (
      (current-stats (default-to { total-tx: u0, total-volume: u0, last-active: u0 }
        (map-get? address-stats address)))
    )
    (ok (map-set address-stats
      address
      {
        total-tx: (+ (get total-tx current-stats) u1),
        total-volume: (+ (get total-volume current-stats) amount),
        last-active: block-height
      }
    ))
  )
)

;; Read only functions
(define-read-only (get-address-stats (address principal))
  (map-get? address-stats address)
)
