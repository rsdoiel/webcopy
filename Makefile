#
# Build the Golang based tools used by the build-static-site.sh script.
#
build: fext inarray

fext: cmds/fext/fext.go
	go build cmds/fext/fext.go

inarray: cmds/inarray/inarray.go
	go build cmds/inarray/inarray.go

.PHONY: clean
clean:
	if [ -f ./inarray ]; then rm ./inarray; fi
	if [ -f ./fext ]; then rm ./fext; fi

install: 
	go install cmds/fext/fext.go
	go install cmds/inarray/inarray.go

uninstall:
	if [ -f "$(GOBIN)/fext" ]; then rm "$(GOBIN)/fext"; fi
	if [ -f "$(GOBIN)/inarray" ]; then rm "$(GOBIN)/inarray"; fi


