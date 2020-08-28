BINARY_PATH=./bin
BINARY_NAME=test
MAIN_NAME=./main

PROJECT_PATH=$(shell pwd)
GOBIN_PATH=$(GOPATH)/bin


all: test build

build:
	go build -o $(BINARY_PATH)/$(BINARY_NAME) -v $(MAIN_NAME)

run: build
	$(BINARY_PATH)/$(BINARY_NAME)

generate: .generate-server .generate-client

.gen-deps:
	@if ! (test -f bin/swagger-codegen-cli.jar) ; then\
		wget https://repo1.maven.org/maven2/io/swagger/codegen/v3/swagger-codegen-cli/3.0.21/swagger-codegen-cli-3.0.21.jar -O bin/swagger-codegen-cli.jar;\
	fi

.generate-client: .gen-deps
	java -DmodelDocs=false -DapiDocs=false -Dservice -Dapis -Dmodels \
		-DsupportingFiles=api_default.go,client.go,configuration.go,response.go \
		-jar bin/swagger-codegen-cli.jar generate \
 		-i swagger.yaml \
 		-l go \
 		-o ./pkg/client \
 		--additional-properties=packageName=testapi
	go fmt ./...

.generate-server: .gen-deps
	java -DmodelDocs=false -DapiDocs=false -Dservice -Dapis -Dmodels -DsupportingFiles -jar bin/swagger-codegen-cli.jar generate \
 		-i swagger.yaml \
 		-l go-server \
 		-o internal/app \
 		--additional-properties=packageName=testapi,hideGenerationTimestamp=true
	go fmt ./...

.swagger-deps:
	go get github.com/rakyll/statik && go install github.com/rakyll/statik

.generate-swaggerui: .swagger-deps
	$(GOBIN_PATH)/statik --src $(PROJECT_PATH)/web/swaggerui --dest ./web -include=*.png,*.html,*.css,*.js,*.json