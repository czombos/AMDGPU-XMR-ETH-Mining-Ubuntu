#!/bin/sh
for i in s u b; do echo $i | sudo tee /proc/sysrq-trigger; sleep 5; done
