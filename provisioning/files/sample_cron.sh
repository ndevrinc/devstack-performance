#!/bin/bash
set -e

cd /var/www/sitespeedio

sitespeed.io -u http://www.sitespeed.io -b firefox,chrome -n 1 -d 0 --graphiteHost localhost --graphiteNamespace local --seleniumServer http://127.0.0.1:4444/wd/hub >> /tmp/sitespeed-run.txt
