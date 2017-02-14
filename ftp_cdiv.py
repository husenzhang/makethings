#!/usr/bin/env python

""" ftp_cdiv.py samples.tgz """

import ftplib
import sys
import os

ftphost  = 'helix.nih.gov'
ftpdir   = 'pub/zhangh18'
username = 'anonymous'

# fileup is a string
fileup = sys.argv[1] 
fname  = os.path.basename(fileup) 

session = ftplib.FTP(host = ftphost, user = username)
session.cwd(ftpdir)
session.storbinary(cmd = '%s %s' %('STOR', fname), fp = open(fileup, 'rb'))
