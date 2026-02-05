#!/bin/bash

# Set up CORS headers for the static file server
cd /opt/dot

# Start simple HTTP server with CORS enabled
python3 -m http.server 8080 --bind 0.0.0.0
