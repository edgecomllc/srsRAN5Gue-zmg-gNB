HELM_REGISTRY?=oci://registry-1.docker.io/edgecom
HELM_PACKAGE_NAME?=$(notdir $(CURDIR))
HELM_PACKAGE_VERSION?=$(shell cat Chart.yaml | grep ^version | awk -F ": " '{ print $$2}')

srs:
   helm upgrade --install \
   srsran . \
   -n open5gs \
   --wait --timeout 100s --create-namespace

package:
	helm package .

push:
	helm push $(HELM_PACKAGE_NAME)-$(HELM_PACKAGE_VERSION).tgz $(HELM_REGISTRY)

test:
	helm template ueransim ./ --values examples/blackbox-exporter.yaml -n open5gs --debug