package main

/**
 * fext.go - quick and dirty go script to render a file extension from a provided command line argument.
 * @author R. S. Doiel, <rsdoiel@gmail.com>
 * copyright (c) 2015 all rights reserved
 * Licensed under the Simplified BSD License.
 */

import (
	"fmt"
	"os"
	"path"
)

func usage(errMsg string, exitCode int) {
	msg := `
	USAGE: fext FILENAME

	Example:

		fext myfile.png

	This example should return "png" on the command line.
`

	fmt.Println(msg)
	if errMsg != "" {
		fmt.Println(errMsg)
	}
	os.Exit(exitCode)
}

func main() {
	args := os.Args[1:]
	if len(args) == 0 {
		usage("", 0)
	}
	for _, fname := range args {
		fmt.Printf("%s\n", path.Ext(fname))
	}
}
