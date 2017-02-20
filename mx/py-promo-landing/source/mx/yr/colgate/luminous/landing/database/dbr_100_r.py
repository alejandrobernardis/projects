#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2011 The Octopus Apps Inc.
# Licensed under the Apache License, Version 2.0 (the "License")
#
# Author: Alejandro M. Bernardis
# Email: alejandro.m.bernardis at gmail.com
# Created: Apr 11, 2012, 12:10:36 PM 

#: -- bootstrap ----------------------------------------------------------------

import os, sys
p_root = os.path.abspath("../")
sys.path.insert(0, p_root+"/libs")
sys.path.insert(1, p_root+"/src")

#: -----------------------------------------------------------------------------

import csv, datetime
from mongoengine import connect
from mx.yr.colgate.luminous.landing.models import Code

#: -----------------------------------------------------------------------------

connect("colgate_luminous_landing", host="localhost", port=27017, 
        username=u"sysadmin", password=u"yrCP+M0nD8!13+")

#: -----------------------------------------------------------------------------

base_dir = os.path.dirname(__file__)
base_path = os.path.join(base_dir, "dataentry")

#: -----------------------------------------------------------------------------

def unicode_csv_reader(utf8_data, dialect=csv.excel, **kwargs):
    csv_reader = csv.reader(utf8_data, dialect=dialect, **kwargs)
    for row in csv_reader:
        yield [unicode(cell, 'utf-8') for cell in row]
        
#: -----------------------------------------------------------------------------

print 
print 'DATABASE'
print '---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----'

print "EXEC: codes-100"
try:
    f_name = ('%s/codes_list_20120510_134233324076_100.csv' % base_path)
    with open(f_name, 'rb') as f:
        ref = unicode_csv_reader(f)
        for row in ref:
            try:
                code = Code.get_by_token(row[0], True)
                if code:
                    code.update(set__category=4, set__points=2)
                    code.reload()
                    print code.to_object()
            except Exception as E:
                print "ERROR", E, code.token
except Exception as E:
    print "ERROR", E
print " END: codes-100"

#: -----------------------------------------------------------------------------

print 
print 'RESULTS'
print '---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----'
print "+ Codes", Code.objects(availabled=True).count()

#: -----------------------------------------------------------------------------

    