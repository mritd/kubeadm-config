BUILD_VERSION	:= $(shell cat version)

all:
	docker run --rm -it -v `pwd`:/fpm mritd/fpm bash -c "cd /fpm && make deb"

deb: clean
	fpm -s dir -t deb -n kubeadm-config \
		-v ${BUILD_VERSION} \
		--vendor "mritd <mritd@linux.com>" \
		--maintainer "mritd <mritd@linux.com>" \
		--license "Apache License 2.0" \
		--description "kubeadm HA cluster config" \
		--url https://github.com/mritd/kubeadm-config \
		--depends kubeadm \
		--depends kubelet \
		--deb-systemd lib/systemd/system/kube-apiserver-proxy.service \
		--deb-systemd-enable \
		--no-deb-systemd-auto-start \
		--no-deb-systemd-restart-after-upgrade \
		etc
	mv *.deb dist

clean:
	rm -f kubeadm-config*.deb
	if [ ! -d "dist" ]; then \
		mkdir dist; \
	else \
		rm -f dist/kubeadm-config*.deb; \
	fi

release: all
	ghr -u mritd -t ${GITHUB_TOKEN} -replace -recreate --debug v${BUILD_VERSION} dist 

pre-release: all
	ghr -u mritd -t ${GITHUB_TOKEN} -replace -recreate -prerelease --debug v${BUILD_VERSION} dist

.PHONY: all deb clean release pre-release
