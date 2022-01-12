{% from tpldir ~ "/map.jinja" import certs with context %}

{%- for CA in salt['pillar.get']('trustedCAs:certs',{}).keys() %}
{{ certs.path }}/{{ CA }}.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: trustedCAs:certs:{{ CA }}
{% endfor %}
{% if salt['pillar.get']('pki:trustedCAs',False) %}
update-ca-certificates:
  cmd.run:
    - name: {{ certs.updatecommand }}
    - onchanges:
    {%- for CA in salt['pillar.get']('trustedCAs:certs',{}).keys() %}
        - file: {{ certs.path }}/{{ CA }}.crt
    {%- endfor %}
{% endif %}
