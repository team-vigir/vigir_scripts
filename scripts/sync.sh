#!/bin/bash
sudo /etc/init.d/chrony stop
sudo ntpdate thor-ocs-primary
sudo /etc/init.d/chrony start
