#!/bin/bash
set -e

# Serve staged inputs
ln -s /home/inputs /opt/dot/inputs

# Create JS that auto-loads container files via HTTP
cat > /opt/dot/galaxy_autoload.js <<'EOF'
(function () {
  if (window.location.search && window.location.search.length > 1) return;

  function abs(rel) {
    return new URL(rel, window.location.href).href;
  }

  var params = new URLSearchParams();
  params.set("coords", abs("inputs/input.coords"));
  params.set("index", abs("inputs/input.coords.idx"));

  // Optional annotation: try HEAD to see if it exists
  var ann = abs("inputs/annotation.bed");
  fetch(ann, { method: "HEAD" })
    .then(function (r) { if (r.ok) params.append("annotations", ann); })
    .catch(function () {})
    .finally(function () { window.location.search = "?" + params.toString(); });
})();
EOF

# Include it before </body>
sed -i 's|</body>|<script src="galaxy_autoload.js"></script>\n</body>|' /opt/dot/index.html

# (Optional) hide the Inputs tab/page so users don’t see local picker
sed -i 's|</head>|<style>#first_tab,#first{display:none!important;}</style>\n</head>|' /opt/dot/index.html

cd /opt/dot
python3 -m http.server 8080
