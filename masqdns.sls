dnsmasq:
  pkg.installed:
    - name: dnsmasq

dnsmasq_config_directory:
  file.directory:
    - name: /etc/dnsmasq.d
    - user: root
    - group: root
    - mode: 755

dnsmasq_edge_config:
  file.managed:
    - name: /etc/dnsmasq.d/edge.conf
    - contents: |
        resolv-file=/etc/resolv.conf.dnsmasq
        addn-hosts=/etc/hosts.dnsmasq
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: dnsmasq_config_directory

dnsmasq_resolv_config:
  file.managed:
    - name: /etc/resolv.conf.dnsmasq
    - contents: |
        nameserver 8.8.8.8
        nameserver 8.8.4.4
    - user: root
    - group: root
    - mode: 644

dnsmasq_hosts_config:
  file.managed:
    - name: /etc/hosts.dnsmasq
    - contents: |
        172.23.230.131 salt
    - user: root
    - group: root
    - mode: 644

dnsmasq_service:
  service.running:
    - name: dnsmasq
    - enable: True
    - require:
      - file: dnsmasq_edge_config
      - file: dnsmasq_resolv_config
      - file: dnsmasq_hosts_config

resolv_conf:
  file.managed:
    - name: /etc/resolv.conf
    - contents: |
        nameserver 127.0.0.1
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: dnsmasq_service
