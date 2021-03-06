#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2012 Asumi Kamikaze Inc.
# Copyright (c) 2012 The Octopus Apps Inc.
# Licensed under the Apache License, Version 2.0 (the "License")
#
# Author: Alejandro M. Bernardis
# Email: alejandro.m.bernardis at gmail.com
# Created: Sep 5, 2012 1:12:13 AM

import datetime
import re
from hashlib import md5
from itertools import izip

#: -- helpers ------------------------------------------------------------------

__all__ = [
   'is_email',
   'safe_str_cmp',
   'bool_to_str',
   'unicode_to_str',
   'datetime_to_str',
   'datetimefull_to_str',
   'date_to_str',
   'time_to_str',
   'timefull_to_str',
   'str_to_unicode',
   'str_to_date',
   'str_to_time',
   'str_to_datetime',
   'get_plural',
   'get_str_plural',
   'regex_email',
   'regex_email_str',
   'regex_username_str',
   'regex_password_str',
   'is_primitive',
   'gravatar_url',
   'gravatar_html',
]

#: -- regex_* ------------------------------------------------------------------

regex_username_str = r"^([a-zA-Z0-9_\-\.@]+)$"

regex_password_str = r"^[a-zA-Z0-9+_\-!\$\.#@%]+$"

regex_email_str = r"(^[-!#$%&'*+/=?^_`{}|~0-9A-Z]+(\.[-!#$%&'*+/=?^_`{}|~0-9A-Z]+)*"\
 r'|^"([\001-\010\013\014\016-\037!#-\[\]-\177]|\\[\001-011\013\014\016-\177])*"'\
 r')@(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+[A-Z]{2,6}\.?$'
 
#: -- is_email -----------------------------------------------------------------

regex_email = re.compile(regex_email_str, re.IGNORECASE)

def is_email(value):
    return True if bool(regex_email.match(value)) else False

#: -- safe_str_cmp -------------------------------------------------------------

def safe_str_cmp(a, b):
    if len(a) != len(b):
        return False
    result = 0
    for x, y in izip(a, b):
        result |= ord(x) ^ ord(y)
    return result == 0

#: -- wrapper ------------------------------------------------------------------

def swallow_args(func):
    def Decorator(arg, *unused_args):
        if not arg: 
            return None
        return func(arg)
    return Decorator

#: -- convert ------------------------------------------------------------------

@swallow_args
def bool_to_str(arg):
    return str(arg).lower()

@swallow_args
def unicode_to_str(arg):
    return arg.encode('utf-8')

@swallow_args
def datetime_to_str(arg):
    return '%d-%02d-%02d %02d:%02d:%02d' %\
           (arg.year, arg.month, arg.day, 
            arg.hour, arg.minute, arg.second)

@swallow_args
def datetimefull_to_str(arg):
    return '%d-%02d-%02d %02d:%02d:%02d.%06d' %\
           (arg.year, arg.month, arg.day, 
            arg.hour, arg.minute, arg.second, arg.microsecond)

@swallow_args
def date_to_str(arg):
    return arg.strftime('%Y-%m-%d')

@swallow_args
def time_to_str(arg):
    return '%02d:%02d:%02d' %\
           (arg.hour, arg.minute, arg.second)
    
@swallow_args
def timefull_to_str(arg):
    return '%02d:%02d:%02d.%06d' %\
           (arg.hour, arg.minute, arg.second, arg.microsecond)
    
#: -----------------------------------------------------------------------------

def _strptime(arg, strptime_format):
    split_arg = arg.split('.')
    datetime_obj = datetime.datetime.strptime(split_arg[0], strptime_format)
    if len(split_arg) == 2:
        datetime_obj = datetime_obj.replace(microsecond=int(split_arg[1]))
    return datetime_obj

#: -----------------------------------------------------------------------------

def str_to_unicode(arg):
    return unicode(arg, 'utf-8')

def str_to_date(arg):
    return _strptime(arg, '%Y-%m-%d').date()

def str_to_time(arg):
    return _strptime(arg, '%H:%M:%S').time()

def str_to_datetime(arg):
    return _strptime(arg, '%Y-%m-%d %H:%M:%S')

#: -- plural -------------------------------------------------------------------

def get_plural(value, singular, plural, message=''):
    try: 
        return plural if value > 1 else singular
    except:
        return message
    
def get_str_plural(value, singular, plural, message='', template=u'%s %s'):
    return template % (value, get_plural(value, singular, plural))

#: -- misc ---------------------------------------------------------------------

def is_primitive(value):
    return type(value) in [complex, int, float, long, bool, str, basestring, 
                           unicode, tuple, list]

def gravatar_url(value, secure=False, width_and_height=140):
    url = '%s://www.gravatar.com/avatar/%s?s=%s'
    secure = 'https' if secure else 'http'
    value = '' if not value else unicode(md5().update(value).hexdigest())
    return url % (secure, value, int(width_and_height))

def gravatar_html(value, secure=False, width_and_height=140):
    width = height = int(width_and_height)
    url = gravatar_url(value, secure, width_and_height)
    html = '<img width="%s" height="%s" alt="Picture Profile" class="gravatar" src="%s"/>'
    return html % (width, height, url)

