#!/bin/bash
# This script pulls out a report on CVEs affecting all images in one or all namespaces
# Requires ROX_ENDPOINT and ROX_API_TOKEN environment variables
# Requires analyst access or more in ACS
# Usage: $0 name-of-namespace-to-scan | nothing-which-scans-all-namespaces

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
	all_namespaces=1
else
	all_namespaces=0
	namespace=$1
fi

# Create jq layers file
echo '["CVE", "CVSS Score", "Summary", "Component", "Version", "Fixed By", "Layer Index", "Layer Instruction"], (.metadata.v1.layers as $layers | .scan.components | sort_by(.layerIndex, .name) | .[] | . as $component | select(.vulns != null) | .vulns[] | [.cve, .cvss, .summary, $component.name, $component.version, .fixedBy, $component.layerIndex, ($layers[$component.layerIndex].instruction + " " +$layers[$component.layerIndex].value)]) | @csv' >$HOME/layers_file

function curl_central() {
  curl -sk -H "Authorization: Bearer ${ROX_API_TOKEN}" "https://${ROX_ENDPOINT}/$1"
}

# Gather CVEs for images in all or one namespace

if [ -f results.json ]; then
	rm -f results.json
fi

if [[ "$all_namespaces" -eq 1 ]]; then
	for namespace in $(curl_central "v1/namespaces" | jq -r ".namespaces[].metadata.name")
	do
		for imageid in $(curl_central "v1/images?query=Namespace:${namespace}"|jq -r ".images[] | select(.cves != null) | .id")
		do
			echo "We are in $namespace looking at $imageid"
			curl_central v1/images/{$imageid}|jq >>results.json
		done
	done
elif [[ "$all_namespaces" -eq 0 ]]; then
	for imageid in $(curl_central "v1/images?query=Namespace:${namespace}"|jq -r ".images[] | select(.cves != null) | .id")
	do
		echo "We are in $namespace looking at $imageid"
		curl_central v1/images/{$imageid}|jq >>results.json
	done
fi

jq -r  -f layers_query result.json

