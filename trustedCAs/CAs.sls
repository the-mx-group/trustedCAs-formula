{%- if grains.os_family == 'Debian' %}
  {%- for CA in salt['pillar.get']('trustedCAs',{}).keys() %}
/usr/local/share/ca-certificates/{{CA}}.crt:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: trustedCAs:{{CA}}
  {% endfor %}
  {% if salt['pillar.get']('pki:trustedCAs',False) %}
update-ca-certificates:
  cmd.wait:
    - watch:
    {%- for CA in salt['pillar.get']('trustedCAs',{}).keys() %}
        - file: /usr/local/share/ca-certificates/{{CA}}.crt
    {%- endfor %}
  {% endif %}
{% endif %}

# gracinet; this is tested on CentOS 7 only at the time being
{%- if grains.os_family == 'RedHat' %}
  {% set CADIR = '/etc/pki/ca-trust/source/anchors' %}
  {% set CANAMES = salt['pillar.get']('trustedCAs',{}).keys() %}
  {%- for CA in CANAMES %}
{{CADIR}}/{{CA}}.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: trustedCAs:{{CA}}
  {% endfor %}
  {% if salt['pillar.get']('pki:trustedCAs') %}
update-ca-certificates:
  cmd.wait:
    - name: 'update-ca-trust extract'
    - watch:
    {%- for CA in CANAMES %}
        - file: {{CADIR}}/{{CA}}.pem
    {%- endfor %}
  {% endif %}
{% endif %}

