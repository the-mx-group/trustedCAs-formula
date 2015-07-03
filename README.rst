trustedCAs-formula
==================

Populates ``/usr/local/share/ca-certificates``
on Linux-distributions from the Debian-family
and runs ``update-ca-certificates`` on changes.

Place the CAs' .pem files' content in a dict
under 'trustedCAs' in your pillar::

    # TODO: Add example here
