FROM python:3.7.4-stretch


RUN apt update && \
    apt install -y python3-dev gcc g++ autoconf make libffi-dev libssl-dev dumb-init python3-openssl

RUN addgroup -gid 450 --system salt && adduser --shell /bin/sh --system --disabled-password --group salt && \
    mkdir -p /etc/pki /etc/salt/pki /etc/salt/minion.d/ /etc/salt/master.d /etc/salt/proxy.d /var/cache/salt /var/log/salt /var/run/salt && \
    chmod -R 2775 /etc/pki /etc/salt /var/cache/salt /var/log/salt /var/run/salt && \
    chgrp -R salt /etc/pki /etc/salt /var/cache/salt /var/log/salt /var/run/salt

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/usr/local/bin/saltinit"]
ADD saltinit.py /usr/local/bin/saltinit
EXPOSE 4505 4506 8000
VOLUME /etc/salt/pki/

RUN pip3 install --no-cache-dir salt==2019.2.0 pycryptodomex CherryPy pygit2
RUN su - salt -c 'salt-run salt.cmd tls.create_self_signed_cert'
