#!/bin/sh

dnf update
dnf install httpd
systemctl enable httpd
systemctl start httpd
