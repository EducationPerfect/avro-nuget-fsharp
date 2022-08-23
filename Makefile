PWD:=$(shell pwd)

.PHONY: pack-build
pack-build:
	docker build -t avro-nuget-packer ./pack

.PHONY: pack-run
pack-run:
	docker run --rm -it --name avro-nuget-packer \
		--volume $(PWD)/../avro-nuget-sandbox/contracts:/contracts --volume $(PWD)/artifacts:/artifacts \
		avro-nuget-packer \
			--package-name=EP.Avro-NuGet-Sandbox.Contracts \
			--package-version=1.5.0 \
			--avro-dir-path=/contracts \
			--output-path=./artifacts \
			--company=EP \
			--authors="Team Void"


#--------- Debugging ---------------------------------------
.PHONY: pack-shell
pack-shell:
	docker run --rm -it --name avro-nuget-packer \
		--volume $(PWD)/../avro-nuget-sandbox/contracts:/contracts --volume $(PWD)/artifacts:/artifacts \
		--entrypoint /bin/sh \
		avro-nuget-packer 

.PHONY: entrypoint
entrypoint:
	./bin/entrypoint.sh --package-name=EP.Avro-NuGet-Sandbox.Contracts --package-version=1.5.0 --avro-dir-path=/contracts --output-path=./artifacts --company=EP --authors="Team Void"

