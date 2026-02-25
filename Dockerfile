FROM python:3.9-slim

LABEL maintainer="Saim Momin <momins@informatik.uni-freiburg.de>"
LABEL description="Interactive Dot plot viewer for comparative genomics"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    wget \
    mummer \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /opt

# Clone the Dot repository
RUN git clone https://github.com/SaimMomin12/galaxy-interactive-tool-dot.git /opt/dot

# Make data directory
RUN mkdir -p /data

# Copy modified index.html that loads data from /data directory
COPY index.html /opt/dot/index.html

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8080
CMD ["/startup.sh"]
