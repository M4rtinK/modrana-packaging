#!/bin/bash
echo "try 1."
scp -i ~/.ssh/id_rsa_maemo.pub *.tar.gz *.diff.gz *.changes *.dsc $1@drop.maemo.org:/var/www/extras-devel/incoming-builder/fremantle/
echo "try 2."
scp -i ~/.ssh/id_rsa_maemo *.tar.gz *.diff.gz *.changes *.dsc $1@drop.maemo.org:/var/www/extras-devel/incoming-builder/fremantle/
