#!/usr/bin/env click-odoo
import sys
import odoo
import base64
from odoo.service.db import exp_dump
from datetime import datetime

db_name = sys.argv[1]
format = sys.argv[2]

list_db_disabled = False
if not odoo.tools.config['list_db']:
    list_db_disabled = True
    odoo.tools.config['list_db'] = True

b64_file = exp_dump(db_name, format)

if list_db_disabled:
    odoo.tools.config['list_db'] = False

timestamp = str(datetime.now()).replace(" ", "_").replace(":", "-").replace(".", "-")
file_name = "/tmp/%s_%s.%s" % (db_name, timestamp, format)
with open(file_name, "wb") as fh:
    fh.write(base64.b64decode(b64_file))
print("%s saved" % file_name)
