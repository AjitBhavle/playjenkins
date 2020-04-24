#!/bin/bash
sed "s/tagVersion/$1/g" myweb.yaml > new_myweb.yaml
