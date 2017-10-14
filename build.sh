#!/bin/bash

docker build --no-cache -t magic/benchmark "$(dirname $0)"
