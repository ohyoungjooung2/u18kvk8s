#!/usr/bin/env bash

ssh -i id_rsa  -L 172.17.0.1:9999:10.1.0.2:22 vagrant@10.1.0.2
