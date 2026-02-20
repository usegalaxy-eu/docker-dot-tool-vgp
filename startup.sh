#!/bin/bash

# Symlink staged inputs so the web server can serve them via URL
ln -s /home/inputs /opt/dot/inputs

# Build URL parameters
COORDS_PARAM="?coords=inputs/input.coords&index=inputs/input.coords.idx"
ANNOTATION_PARAM=""

if [ -f /home/inputs/annotation.bed ]; then
    ANNOTATION_PARAM="&annotations=inputs/annotation.bed"
fi

URL_SUFFIX="${COORDS_PARAM}${ANNOTATION_PARAM}"

# Inject auto-redirect into index.html (only redirects if no params already in URL)
sed -i "s|<script type=\"text/javascript\">|<script type=\"text/javascript\">\n\t\tif (!window.location.search) { window.location.search = '${URL_SUFFIX}'; }|" /opt/dot/index.html

# Start the web server
cd /opt/dot
python3 -m http.server 8080