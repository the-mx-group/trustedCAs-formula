trustedCAs-formula
==================

Have the system trust additional Certificate Authorities (CA)
specified in pillar.

Supported systems
-----------------

* Debian family (tested on Debian 6,7,8 and Ubuntu 14.04)
* RedHat family (tested on CentOS 7 only)

Pillar example
--------------

In your pillar, place the CAs PEM file content in a dict
under ``trustedCAs:certs``::

  trustedCAs:
    certs:
      the_ca_name: |
        -----BEGIN CERTIFICATE-----
        MIIEIDCCAwigAwIBAgIQNE7VVyDV7exJ9C/ON9srbTANBgkqhkiG9w0BAQUFADCB
        (... truncated ...)
        jVaMaA==
        -----END CERTIFICATE---

If you need to override the destination path or the update command::

  trustedCAs:
    path: '/usr/local/share/my-cert-path'
    updatecommand: 'update-certs-please'

.. note:: removing a CA from the pillar does not make the system stop
          trusting it.

Dependency management
---------------------

If you need to control your states according to the changes in CAs,
you can add dependencies on ``cmd: update-ca-certificates``.
For example, if you have a service that pulls something over a TLS
connection that depends on the proper CA, you can do something like this::

  myservice:
    service.running:
      restart: true
      watch:
        - cmd: update-ca-certificates


Internals
---------

The formula adds the CA to the system's list of trusted authorities.
Both on Debian and RedHat, this works by populating the directory
expected by the distribution and running the update script provided by the
distribution on changes.

Debian:
  directory ``/usr/local/share/ca-certificates``,
  script ``update-ca-certificates``.

RedHat:
  directory ``/etc/pki/trust/source/anchors``,
  script ``update-ca-trust``.
