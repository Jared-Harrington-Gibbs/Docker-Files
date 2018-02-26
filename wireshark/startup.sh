#!/bin/bash
xrdp && \
xrdp-sesman && \
bash -c "Xvfb -nolisten tcp :1 -screen 0 800x600x16"
