#!/usr/bin/env bash
ssh -i ../id_rsa -L 8001:localhost:8001 vagrant@10.1.0.2
