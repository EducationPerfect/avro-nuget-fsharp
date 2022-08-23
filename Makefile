PWD:=$(shell pwd)

.PHONY: pack-build
pack-build:
	docker build -t protobuf-nuget-packer ./pack

.PHONY: pack-run
pack-run:
	docker run --rm -it --name protobuf-nuget-packer \
		--volume $(PWD)/../certificate-generation-contracts/protos:/protos --volume $(PWD)/artifacts:/artifacts \
		protobuf-nuget-packer \
			--package-name=EP.Contract.POC \
			--package-version=1.4.0 \
			--protobuf-dir-path=/protos \
			--output-path=./artifacts \
			--company=EP \
			--authors="Team Void"


#--------- Debugging ---------------------------------------
.PHONY: pack-shell
pack-shell:
	docker run --rm -it --name protobuf-nuget-packer \
		--volume $(PWD)/../certificate-generation-contracts/protos:/protos --volume $(PWD)/artifacts:/artifacts \
		--entrypoint /bin/sh \
		protobuf-nuget-packer 

.PHONY: entrypoint
entrypoint:
	./bin/entrypoint.sh --package-name=EP.Contract.POC --package-version=1.3.0 --protobuf-dir-path=/protos --output-path=./artifacts --company=EP --authors="Team Void"

.PHONY: add-protos
add-protos:
	dotnet-grpc add-file --service None --project /src/EP.Contract.POC/EP.Contract.POC.csproj  /protos/ep/certificate_generation/events/*.proto

