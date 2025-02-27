;;; GnuTLS --- Guile bindings for GnuTLS.
;;; Copyright (C) 2007-2012, 2014, 2015, 2016, 2019 Free Software Foundation, Inc.
;;;
;;; GnuTLS is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU Lesser General Public
;;; License as published by the Free Software Foundation; either
;;; version 2.1 of the License, or (at your option) any later version.
;;;
;;; GnuTLS is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with GnuTLS; if not, write to the Free Software
;;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

;;; Written by Ludovic Court�s <ludo@gnu.org>

(define-module (gnutls)
  ;; Note: The export list must be manually kept in sync with the build
  ;; system.
  :export (;; versioning
           gnutls-version

           ;; sessions
           session?
           make-session bye handshake rehandshake reauthenticate
           alert-get alert-send
           session-cipher session-kx session-mac session-protocol
           session-compression-method session-certificate-type
           session-authentication-type session-server-authentication-type
           session-client-authentication-type
           session-peer-certificate-chain session-our-certificate-chain
           set-session-transport-fd! set-session-transport-port!
           set-session-credentials! set-server-session-certificate-request!
           set-session-server-name!

           ;; anonymous credentials
           anonymous-client-credentials? anonymous-server-credentials?
           make-anonymous-client-credentials make-anonymous-server-credentials
           set-anonymous-server-dh-parameters!

           ;; certificate credentials
           certificate-credentials? make-certificate-credentials
           set-certificate-credentials-dh-parameters!
           set-certificate-credentials-x509-key-files!
           set-certificate-credentials-x509-trust-file!
           set-certificate-credentials-x509-crl-file!
           set-certificate-credentials-x509-key-data!
           set-certificate-credentials-x509-trust-data!
           set-certificate-credentials-x509-crl-data!
           set-certificate-credentials-x509-keys!
           set-certificate-credentials-verify-limits!
           set-certificate-credentials-verify-flags!
           peer-certificate-status

           ;; SRP credentials
           srp-client-credentials? srp-server-credentials?
           make-srp-client-credentials make-srp-server-credentials
           set-srp-client-credentials!
           set-srp-server-credentials-files!
           server-session-srp-username
           srp-base64-encode srp-base64-decode

           ;; PSK credentials
           psk-client-credentials? psk-server-credentials?
           make-psk-client-credentials make-psk-server-credentials
           set-psk-client-credentials!
           set-psk-server-credentials-file!
           server-session-psk-username

           ;; priorities
           set-session-priorities!
           set-session-default-priority!

           ;; DH
           set-session-dh-prime-bits!
           make-dh-parameters dh-parameters?
           pkcs3-import-dh-parameters pkcs3-export-dh-parameters

           ;; X.509
           x509-certificate? x509-private-key?
           import-x509-certificate  x509-certificate-matches-hostname?
           x509-certificate-dn x509-certificate-dn-oid
           x509-certificate-issuer-dn x509-certificate-issuer-dn-oid
           x509-certificate-signature-algorithm x509-certificate-version
           x509-certificate-key-id x509-certificate-authority-key-id
           x509-certificate-subject-key-id
           x509-certificate-subject-alternative-name
           x509-certificate-public-key-algorithm x509-certificate-key-usage
           import-x509-private-key pkcs8-import-x509-private-key

           ;; record layer
           record-send record-receive!
           session-record-port

           ;; debugging
           set-log-procedure! set-log-level!

           ;; enum->string functions
           cipher->string kx->string params->string credentials->string
           mac->string digest->string compression-method->string
           connection-end->string connection-flag->string
           alert-level->string
           alert-description->string handshake-description->string
           certificate-status->string certificate-request->string
           close-request->string
           protocol->string certificate-type->string
           x509-certificate-format->string
           x509-subject-alternative-name->string pk-algorithm->string
           sign-algorithm->string psk-key-format->string key-usage->string
           certificate-verify->string error->string
           cipher-suite->string server-name-type->string

           ;; enum values
           cipher/null
           cipher/arcfour cipher/arcfour-128
           cipher/3des-cbc
           cipher/aes-128-cbc cipher/rijndael-cbc cipher/rijndael-128-cbc
           cipher/aes-256-cbc cipher/rijndael-256-cbc
           cipher/arcfour-40
           cipher/rc2-40-cbc
           cipher/des-cbc
           kx/rsa
           kx/dhe-dss
           kx/dhe-rsa
           kx/anon-dh
           kx/srp
           kx/rsa-export
           kx/srp-rsa
           kx/srp-dss
           kx/psk
           kx/dhe-dss
           params/rsa-export
           params/dh
           credentials/certificate
           credentials/anon
           credentials/anonymous
           credentials/srp
           credentials/psk
           credentials/ia
           mac/unknown
           mac/null
           mac/md5
           mac/sha1
           mac/rmd160
           mac/md2
           digest/null
           digest/md5
           digest/sha1
           digest/rmd160
           digest/md2
           compression-method/null
           compression-method/deflate
           compression-method/lzo
           connection-end/server
           connection-end/client
           connection-flag/datagram
           connection-flag/nonblock
           connection-flag/no-extensions
           connection-flag/no-replay-protection
           connection-flag/no-signal
           connection-flag/allow-id-change
           connection-flag/enable-false-start
           connection-flag/force-client-cert
           connection-flag/no-tickets
           connection-flag/key-share-top
           connection-flag/key-share-top2
           connection-flag/key-share-top3
           connection-flag/post-handshake-auth
           connection-flag/no-auto-rekey
           connection-flag/safe-padding-check
           connection-flag/enable-early-start
           connection-flag/enable-rawpk
           connection-flag/auto-reauth
           connection-flag/enable-early-data
           alert-level/warning
           alert-level/fatal
           alert-description/close-notify
           alert-description/unexpected-message
           alert-description/bad-record-mac
           alert-description/decryption-failed
           alert-description/record-overflow
           alert-description/decompression-failure
           alert-description/handshake-failure
           alert-description/ssl3-no-certificate
           alert-description/bad-certificate
           alert-description/unsupported-certificate
           alert-description/certificate-revoked
           alert-description/certificate-expired
           alert-description/certificate-unknown
           alert-description/illegal-parameter
           alert-description/unknown-ca
           alert-description/access-denied
           alert-description/decode-error
           alert-description/decrypt-error
           alert-description/export-restriction
           alert-description/protocol-version
           alert-description/insufficient-security
           alert-description/internal-error
           alert-description/user-canceled
           alert-description/no-renegotiation
           alert-description/unsupported-extension
           alert-description/certificate-unobtainable
           alert-description/unrecognized-name
           alert-description/unknown-psk-identity
           alert-description/inner-application-failure
           alert-description/inner-application-verification
           handshake-description/hello-request
           handshake-description/client-hello
           handshake-description/server-hello
           handshake-description/certificate-pkt
           handshake-description/server-key-exchange
           handshake-description/certificate-request
           handshake-description/server-hello-done
           handshake-description/certificate-verify
           handshake-description/client-key-exchange
           handshake-description/finished
           certificate-status/invalid
           certificate-status/revoked
           certificate-status/signer-not-found
           certificate-status/signer-not-ca
           certificate-status/insecure-algorithm
           certificate-status/not-activated
           certificate-status/expired
           certificate-status/signature-failure
           certificate-status/revocation-data-superseded
           certificate-status/unexpected-owner
           certificate-status/revocation-data-issued-in-future
           certificate-status/signer-constraints-failed
           certificate-status/mismatch
           certificate-status/purpose-mismatch
           certificate-status/missing-ocsp-status
           certificate-status/invalid-ocsp-status
           certificate-status/unknown-crit-extensions
           certificate-request/ignore
           certificate-request/request
           certificate-request/require
           close-request/rdwr
           close-request/wr
           protocol/ssl-3
           protocol/tls-1.0
           protocol/tls-1.1
           protocol/version-unknown
           certificate-type/x509
           certificate-type/openpgp
           x509-certificate-format/der
           x509-certificate-format/pem
           x509-subject-alternative-name/dnsname
           x509-subject-alternative-name/rfc822name
           x509-subject-alternative-name/uri
           x509-subject-alternative-name/ipaddress
           pk-algorithm/rsa
           pk-algorithm/dsa
           pk-algorithm/unknown
           sign-algorithm/unknown
           sign-algorithm/rsa-sha1
           sign-algorithm/dsa-sha1
           sign-algorithm/rsa-md5
           sign-algorithm/rsa-md2
           sign-algorithm/rsa-rmd160
           psk-key-format/raw
           psk-key-format/hex
           key-usage/digital-signature
           key-usage/non-repudiation
           key-usage/key-encipherment
           key-usage/data-encipherment
           key-usage/key-agreement
           key-usage/key-cert-sign
           key-usage/crl-sign
           key-usage/encipher-only
           key-usage/decipher-only
           certificate-verify/disable-ca-sign
           certificate-verify/allow-x509-v1-ca-crt
           certificate-verify/allow-x509-v1-ca-certificate
           certificate-verify/do-not-allow-same
           certificate-verify/allow-any-x509-v1-ca-crt
           certificate-verify/allow-any-x509-v1-ca-certificate
           certificate-verify/allow-sign-rsa-md2
           certificate-verify/allow-sign-rsa-md5
           server-name-type/dns

           ;; FIXME: Automate this:
           ;; grep '^#define GNUTLS_E_' ../../lib/includes/gnutls/gnutls.h.in | \
           ;;   sed -r -e 's|^#define GNUTLS_E_([^ ]+).*$|error/\1|' | tr A-Z_ a-z-
           error/success
           error/unsupported-version-packet
           error/tls-packet-decoding-error
           error/unexpected-packet-length
           error/invalid-session
           error/fatal-alert-received
           error/unexpected-packet
           error/warning-alert-received
           error/error-in-finished-packet
           error/unexpected-handshake-packet
           error/decryption-failed
           error/memory-error
           error/decompression-failed
           error/compression-failed
           error/again
           error/expired
           error/db-error
           error/srp-pwd-error
           error/keyfile-error
           error/insufficient-credentials
           error/insuficient-credentials
           error/insufficient-cred
           error/insuficient-cred
           error/hash-failed
           error/base64-decoding-error
           error/rehandshake
           error/got-application-data
           error/record-limit-reached
           error/encryption-failed
           error/pk-encryption-failed
           error/pk-decryption-failed
           error/pk-sign-failed
           error/x509-unsupported-critical-extension
           error/key-usage-violation
           error/no-certificate-found
           error/invalid-request
           error/short-memory-buffer
           error/interrupted
           error/push-error
           error/pull-error
           error/received-illegal-parameter
           error/requested-data-not-available
           error/pkcs1-wrong-pad
           error/received-illegal-extension
           error/internal-error
           error/dh-prime-unacceptable
           error/file-error
           error/too-many-empty-packets
           error/unknown-pk-algorithm
           error/too-many-handshake-packets
           error/received-disallowed-name
           error/certificate-required
           error/no-temporary-rsa-params
           error/no-compression-algorithms
           error/no-cipher-suites
           error/openpgp-getkey-failed
           error/pk-sig-verify-failed
           error/illegal-srp-username
           error/srp-pwd-parsing-error
           error/keyfile-parsing-error
           error/no-temporary-dh-params
           error/asn1-element-not-found
           error/asn1-identifier-not-found
           error/asn1-der-error
           error/asn1-value-not-found
           error/asn1-generic-error
           error/asn1-value-not-valid
           error/asn1-tag-error
           error/asn1-tag-implicit
           error/asn1-type-any-error
           error/asn1-syntax-error
           error/asn1-der-overflow
           error/openpgp-uid-revoked
           error/certificate-error
           error/x509-certificate-error
           error/certificate-key-mismatch
           error/unsupported-certificate-type
           error/x509-unknown-san
           error/openpgp-fingerprint-unsupported
           error/x509-unsupported-attribute
           error/unknown-hash-algorithm
           error/unknown-pkcs-content-type
           error/unknown-pkcs-bag-type
           error/invalid-password
           error/mac-verify-failed
           error/constraint-error
           error/warning-ia-iphf-received
           error/warning-ia-fphf-received
           error/ia-verify-failed
           error/unknown-algorithm
           error/unsupported-signature-algorithm
           error/safe-renegotiation-failed
           error/unsafe-renegotiation-denied
           error/unknown-srp-username
           error/premature-termination
           error/malformed-cidr
           error/base64-encoding-error
           error/incompatible-gcrypt-library
           error/incompatible-crypto-library
           error/incompatible-libtasn1-library
           error/openpgp-keyring-error
           error/x509-unsupported-oid
           error/random-failed
           error/base64-unexpected-header-error
           error/openpgp-subkey-error
           error/crypto-already-registered
           error/already-registered
           error/handshake-too-large
           error/cryptodev-ioctl-error
           error/cryptodev-device-error
           error/channel-binding-not-available
           error/bad-cookie
           error/openpgp-preferred-key-error
           error/incompat-dsa-key-with-tls-protocol
           error/insufficient-security
           error/heartbeat-pong-received
           error/heartbeat-ping-received
           error/unrecognized-name
           error/pkcs11-error
           error/pkcs11-load-error
           error/parsing-error
           error/pkcs11-pin-error
           error/pkcs11-slot-error
           error/locking-error
           error/pkcs11-attribute-error
           error/pkcs11-device-error
           error/pkcs11-data-error
           error/pkcs11-unsupported-feature-error
           error/pkcs11-key-error
           error/pkcs11-pin-expired
           error/pkcs11-pin-locked
           error/pkcs11-session-error
           error/pkcs11-signature-error
           error/pkcs11-token-error
           error/pkcs11-user-error
           error/crypto-init-failed
           error/timedout
           error/user-error
           error/ecc-no-supported-curves
           error/ecc-unsupported-curve
           error/pkcs11-requested-object-not-availble
           error/certificate-list-unsorted
           error/illegal-parameter
           error/no-priorities-were-set
           error/x509-unsupported-extension
           error/session-eof
           error/tpm-error
           error/tpm-key-password-error
           error/tpm-srk-password-error
           error/tpm-session-error
           error/tpm-key-not-found
           error/tpm-uninitialized
           error/tpm-no-lib
           error/no-certificate-status
           error/ocsp-response-error
           error/random-device-error
           error/auth-error
           error/no-application-protocol
           error/sockets-init-error
           error/key-import-failed
           error/inappropriate-fallback
           error/certificate-verification-error
           error/privkey-verification-error
           error/unexpected-extensions-length
           error/asn1-embedded-null-in-string
           error/self-test-error
           error/no-self-test
           error/lib-in-error-state
           error/pk-generation-error
           error/idna-error
           error/need-fallback
           error/session-user-id-changed
           error/handshake-during-false-start
           error/unavailable-during-handshake
           error/pk-invalid-pubkey
           error/pk-invalid-privkey
           error/not-yet-activated
           error/invalid-utf8-string
           error/no-embedded-data
           error/invalid-utf8-email
           error/invalid-password-string
           error/certificate-time-error
           error/record-overflow
           error/asn1-time-error
           error/incompatible-sig-with-key
           error/pk-invalid-pubkey-params
           error/pk-no-validation-params
           error/ocsp-mismatch-with-certs
           error/no-common-key-share
           error/reauth-request
           error/too-many-matches
           error/crl-verification-error
           error/missing-extension
           error/db-entry-exists
           error/early-data-rejected
           error/unimplemented-feature
           error/int-ret-0
           error/int-check-again
           error/application-error-max
           error/application-error-min

           fatal-error?

           ;; OpenPGP keys (formerly in GnuTLS-extra)
           openpgp-certificate? openpgp-private-key?
           import-openpgp-certificate import-openpgp-private-key
           openpgp-certificate-id openpgp-certificate-id!
           openpgp-certificate-fingerprint openpgp-certificate-fingerprint!
           openpgp-certificate-name openpgp-certificate-names
           openpgp-certificate-algorithm openpgp-certificate-version
           openpgp-certificate-usage

           ;; OpenPGP keyrings
           openpgp-keyring? import-openpgp-keyring
           openpgp-keyring-contains-key-id?

           ;; certificate credentials
           set-certificate-credentials-openpgp-keys!

           ;; enum->string functions
           openpgp-certificate-format->string

           ;; enum values
           openpgp-certificate-format/raw
           openpgp-certificate-format/base64))

(cond-expand
  ((not guile-2)                                  ;silly 1.8
   (define-macro (eval-when foo a b)
     `(begin ,a ,b)))
  (else #t))

(eval-when (expand load eval)
  (define %libdir
    (or (getenv "GNUTLS_GUILE_EXTENSION_DIR")

        ;; The .scm file is supposed to be architecture-independent.  Thus,
        ;; save 'extensiondir' only if it's different from what Guile expects.
        ))

  (unless (getenv "GNUTLS_GUILE_CROSS_COMPILING")
    (load-extension (if %libdir
                        (string-append %libdir "/guile-gnutls-v-2")
                        "guile-gnutls-v-2")
                    "scm_init_gnutls")))

(cond-expand
  ((not guile-2)
   (define-macro (define-deprecated new)
     `(define ,new ,(symbol-append '% new))))
  (else
   (define-syntax define-deprecated
     (lambda (s)
       "Define a deprecated variable or procedure, along these lines:

  (define-deprecated variable alias)

This defines 'variable' as an alias for 'alias', and emits a warning when
'variable' is used."
       (syntax-case s ()
         ((_ variable)
          (with-syntax ((alias (datum->syntax
                                #'variable
                                (symbol-append
                                 '% (syntax->datum #'variable)))))
            #'(define-deprecated variable alias)))
         ((_ variable alias)
          (identifier? #'variable)
          #`(define-syntax variable
              (lambda (s)
                (issue-deprecation-warning
                 (format #f "GnuTLS variable '~a' is deprecated"
                         (syntax->datum #'variable)))
                (syntax-case s ()
                  ((_ args (... ...))
                   #'(alias args (... ...)))
                  (id
                   (identifier? #'id)
                   #'alias))))))))))


;; Renaming.
(define protocol/ssl-3 protocol/ssl3)
(define protocol/tls-1.0 protocol/tls1-0)
(define protocol/tls-1.1 protocol/tls1-1)

;; Aliases.
(define credentials/anonymous   credentials/anon)
(define cipher/rijndael-256-cbc cipher/aes-256-cbc)
(define cipher/rijndael-128-cbc cipher/aes-128-cbc)
(define cipher/rijndael-cbc     cipher/aes-128-cbc)
(define cipher/arcfour-128      cipher/arcfour)
(define certificate-verify/allow-any-x509-v1-ca-certificate
  certificate-verify/allow-any-x509-v1-ca-crt)
(define certificate-verify/allow-x509-v1-ca-certificate
  certificate-verify/allow-x509-v1-ca-crt)

;; Deprecated OpenPGP bindings.
(define-deprecated certificate-type/openpgp)
(define-deprecated error/openpgp-getkey-failed)
(define-deprecated error/openpgp-uid-revoked)
(define-deprecated error/openpgp-fingerprint-unsupported)
(define-deprecated error/openpgp-keyring-error)
(define-deprecated error/openpgp-subkey-error)
(define-deprecated error/openpgp-preferred-key-error)
(define-deprecated openpgp-private-key?)
(define-deprecated import-openpgp-certificate)
(define-deprecated import-openpgp-private-key)
(define-deprecated openpgp-certificate-id)
(define-deprecated openpgp-certificate-id!)
(define-deprecated openpgp-certificate-fingerprint)
(define-deprecated openpgp-certificate-fingerprint!)
(define-deprecated openpgp-certificate-name)
(define-deprecated openpgp-certificate-names)
(define-deprecated openpgp-certificate-algorithm)
(define-deprecated openpgp-certificate-version)
(define-deprecated openpgp-certificate-usage)
(define-deprecated openpgp-keyring?)
(define-deprecated import-openpgp-keyring)
(define-deprecated openpgp-keyring-contains-key-id?)
(define-deprecated set-certificate-credentials-openpgp-keys!)

;; XXX: The following bindings should be marked as deprecated as well, but due
;; to the way binding names are constructed for enums and smobs, it's
;; complicated.  Oh well.
;;
;; (define-deprecated openpgp-certificate?)
;; (define-deprecated openpgp-certificate-format->string)
;; (define-deprecated openpgp-certificate-format/raw)
;; (define-deprecated openpgp-certificate-format/base64)

;;; Local Variables:
;;; mode: scheme
;;; coding: latin-1
;;; End:

;;; arch-tag: 3394732c-d9fa-48dd-a093-9fba3a325b8b
