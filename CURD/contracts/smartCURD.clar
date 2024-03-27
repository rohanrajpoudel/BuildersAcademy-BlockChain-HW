;; The contract-owner is the transaction sender
(define-constant contract-owner tx-sender) 

;; defining errors
(define-constant err-not-owner (err u100))
(define-constant err-no-value (err u101))

;; defining maps
(define-map CURD uint {s-no: uint, name: (string-ascii 20), owner: principal, country: (string-ascii 10), notes: (string-ascii 500)})

;; defining key, the ID used to define the maps
(define-data-var key uint u0)

;; displaying data, takes key as input, and prints tuple as output
(define-public (display-data (keyy uint))
    (begin 
    ;; throw some error if the map has no value at ID keyy
        (asserts! (is-some (map-get? CURD keyy)) err-no-value)
    ;; print the map 
        (print (map-get? CURD keyy))
        (ok true)
    )
)

;; adding data, takes name of owner, countey of owner, and the notes - other things like the key ID and wallet address is set automatically
(define-public (add-data (name (string-ascii 20)) (country (string-ascii 10)) (notes (string-ascii 500)))
    (begin 
    ;; set the map according to user value
        (map-set CURD (var-get key) {s-no: (var-get key), name:name, owner:contract-owner, country: country, notes:notes})
    ;; let's print the set values, so that the user would be confirmed that the values has been written in the map
        (print (map-get? CURD (var-get key)))
    ;; increase the key value by 1
        (var-set key (+ (var-get key) u1))
        (ok true)
    )
)

;; editiong the data, takes key ID also with other things taken by the add-data function
(define-public (edit-data (keyy uint) (name (string-ascii 20)) (country (string-ascii 10)) (notes (string-ascii 500)))
    (begin 
    ;; check if the keyy ID has some values in map or not
        (asserts! (is-some (map-get? CURD keyy)) err-no-value)
    ;; check if the current transaction owner is the actual owner of that data map
        (asserts! (is-eq (unwrap-panic (get owner (map-get? CURD keyy))) tx-sender) err-not-owner)
    ;; edit the datas
        (map-set CURD keyy {s-no: keyy, name:name, owner:contract-owner, country: country, notes:notes})
    ;; let's print the set values, so that the user would be confirmed that the values has been written in the map
        (print (map-get? CURD keyy))
        (ok true)
    )
)

;; lets delete the data
(define-public (delete-data (keyy uint)) 
    (begin
    ;; check if the keyy ID has some values in map or not
        (asserts! (is-some (map-get? CURD keyy)) err-no-value)
    ;; check if the current transaction owner is the actual owner of that data map
        (asserts! (is-eq (unwrap-panic (get owner (map-get? CURD keyy))) tx-sender) err-not-owner)
    ;; finally deleting the data
        (ok (map-delete CURD keyy))
    )
)



