#!/bin/bash
# This script pulls out a report on CVEs affecting all images in one or all namespaces
# Requires ROX_ENDPOINT and ROX_API_TOKEN environment variables
# Requires analyst access or more in ACS
# Usage: $0 name-of-namespace-to-scan | nothing-which-scans-all-namespaces
# Magnus Glantz, sudo@redhat.com, 2021, with great help from Neil Carpenter 
# and inspiration from https://github.com/stackrox/contributions/blob/main/util-scripts/violations-to-csv/violations-to-csv.sh


case $1 in
	*help)
		echo "$0 namespace-name|nothing-to-scan-all-namespaces"
		;;
esac

if [[ -z "${ROX_ENDPOINT}" ]]; then
  echo >&2 "ROX_ENDPOINT must be set"
  exit 1
fi

if [[ -z "${ROX_API_TOKEN}" ]]; then
  echo >&2 "ROX_API_TOKEN must be set"
  exit 1
fi

if [[ -z "${1}" ]]; then
	namespace="all"
else
	namespace=$1
fi

# Create jq layers file
echo '["CVE", "CVSS Score", "Summary", "Component", "Version", "Fixed By", "Layer Index", "Layer Instruction"], (.metadata.v1.layers as $layers | .scan.components | sort_by(.layerIndex, .name) | .[] | . as $component | select(.vulns != null) | .vulns[] | [.cve, .cvss, .summary, $component.name, $component.version, .fixedBy, $component.layerIndex, ($layers[$component.layerIndex].instruction + " " +$layers[$component.layerIndex].value)]) | @csv' >$HOME/layers_file

function curl_central() {
  curl -sk -H "Authorization: Bearer ${ROX_API_TOKEN}" "https://${ROX_ENDPOINT}/$1"
}

# Gather CVEs for images in all or one namespace

for namespace in $(curl_central "v1/namespaces" | jq --arg namespace "$namespace" -r '.namespaces[].metadata | { name } | if $namespace=="all" then select(.) else select(.name == $namespace) end | .name')
do
	for imageid in $(curl_central "v1/images?query=Namespace:${namespace}"|jq -r ".images[] | select(.cves != null) | .id")
	do
	    imagename=$(curl_central v1/images/{$imageid} | jq -r jq '.name.fullName | gsub("/"; "_")')
		echo "We are in $namespace looking at $imagename"
		curl_central v1/images/{$imageid} | jq -r  -f $HOME/layers_file > ${namespace}-${imagename}.csv
	done
done

