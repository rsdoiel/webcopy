package main

/**
 * inarray.go - Given a string (needle) and a JSON string of an array (haystack), see if needle is in haystack.
 * @author R. S. Doiel, <rsdoiel@gmail.com>
 * copyright (c) 2015 all rights reserved
 * Licensed under the Simplified BSD License.
 */

import (
	"encoding/json"
	"fmt"
	"os"
)

func usage(errMsg string, exitCode int) {
	msg := `
	USAGE: inarray NEEDLE_AS_STRING HAYSTACK_AS_JSON_ARRAY_OF_STRINGS

	If the needle is found in the array described by haystack then print
	the word "true" otherwise print the word 'false"

	Example:

		./inarray jpg '["gif","png","jpg"]

	This example would display the word "true"
`
	fmt.Println(msg)
	if errMsg != "" {
		fmt.Println(errMsg)
	}
	os.Exit(exitCode)
}

func needleFound(s string, a []string) bool {
	for _, item := range a {
		if item == s {
			return true
		}
	}
	return false
}
func main() {
	var haystack []string

	args := os.Args[1:]
	if len(args) != 2 {
		usage("", 0)
	}
	needle := args[0]
	err := json.Unmarshal([]byte(args[1]), &haystack)
	if err != nil {
		usage("Could not parse JSON blob for haystack", 1)
	}
	if needleFound(needle, haystack) == true {
		fmt.Println("true")
	} else {
		fmt.Println("false")
	}
}
