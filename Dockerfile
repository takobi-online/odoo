FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=UTC apt-get -y install tzdata

RUN apt-get -y install build-essential libssl-dev libffi-dev python3-dev python3-pip libpq-dev git libxml2-dev libxslt1-dev libz-dev libxmlsec1-dev libldap2-dev libsasl2-dev libcups2-dev postgresql-client curl

RUN curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb

RUN pip install wheel

COPY . /opt/odoo/
RUN pip install -r /opt/odoo/requirements.txt
RUN pip install -e /opt/odoo/

COPY ./odoo.conf /etc/odoo/
RUN useradd odoo
RUN chown odoo /etc/odoo/odoo.conf \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons", "/etc/odoo"]
EXPOSE 8069 8071 8072
ENV ODOO_RC /etc/odoo/odoo.conf
ENV PGHOST db
ENV PGPORT 5432
ENV PGUSER odoo
ENV PGPASSWORD odoo
USER odoo
CMD ["odoo"]
