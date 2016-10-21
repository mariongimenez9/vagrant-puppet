echo "Bootstrapping LB"

echo "Installing haproxy"
sudo yum -y install haproxy

#sudo cd /etc/haproxy/
sudo rm -f haproxy.cfg

cat > /etc/haproxy/haproxy.cfg <<EOF
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        user haproxy
        group haproxy
        daemon
 
defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        contimeout 5000
        clitimeout 50000
        srvtimeout 50000
 
#Configuration du balancement
listen cluster_web 192.168.128.7:8140
        #Web
        mode tcp
 
        #Mode de balancement Round Robin
        balance roundrobin
 
        #Options
        option httpclose
        option forwardfor
 
        #Les serveurs Web
        server puppetmaster 192.168.128.2:8140 check
        server puppetmaster2 192.168.128.5:8140 check
EOF

sudo systemctl start haproxy
sudo systemctl enable haproxy
