// -*- compile-command: "go test -v ./..."; -*-

// install-spectest-shim reads all *.wat files found under target/wasm/release/build
// and writes a new *.wasm file that removes the line:
// `(import "spectest" "print_char" (func $printc (param $i i32)))`
// added by the MoonBit compiler, and replaces all instances of $printc
// with a call to `$@gmlewis/moonbit-pdk/pdk.Host::outputString.fn/81` (or whatever
// name is found that contains the prefix: `$@gmlewis/moonbit-pdk/pdk.Host::outputString.fn/`).
//
// Obviously, this is a royal hack, but allows the resulting WASM files to be used directly
// with the Extism CLI, which is really nice.
package main

import (
	"flag"
	"fmt"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	dir       = flag.String("dir", "target/wasm/release/build", "Directory to search for *.wat files")
	badImport = flag.String("import", `(import "spectest" "print_char"`, "Start of bad import line to replace")
	from      = flag.String("from", "$printc", "Name of internal function being replaced with shim")
	prefix    = flag.String("prefix", "$@gmlewis/moonbit-pdk/pdk.Host::outputString.fn/", "Prefix to search for in *.wat files for shim function")
)

func main() {
	flag.Parse()

	fileSystem := os.DirFS(*dir)
	fs.WalkDir(fileSystem, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			log.Fatal(err)
		}
		if strings.HasSuffix(path, ".wat") {
			processFile(filepath.Join(*dir, path))
		}
		return nil
	})

	log.Printf("Done.")
}

func processFile(path string) {
	wasmPath := strings.TrimSuffix(path, "wat") + "wasm"
	log.Printf("Adding shim from %v to %v ...", path, wasmPath)
	b, err := os.ReadFile(path)
	must(err)

	lines := strings.Split(string(b), "\n")
	// first, find the replacement function
	lookFor := fmt.Sprintf("(func %v", *prefix)
	var shimFunc string
	for _, line := range lines {
		if strings.HasPrefix(line, lookFor) {
			parts := strings.Split(line, " ")
			shimFunc = parts[1]
			break
		}
	}

	if shimFunc == "" {
		log.Fatalf("unable to find shim function with prefix %v", *prefix)
	}

	out := make([]string, 0, len(lines))
	// Now, rewrite the .wat file and call `wat2wasm` on the output.
	var foundBadImport bool
	for _, line := range lines {
		if strings.HasPrefix(line, *badImport) {
			foundBadImport = true
			continue
		}
		out = append(out, line)
	}
	if !foundBadImport {
		log.Fatalf("unable to find bad import starting with prefix %v", *badImport)
	}

	finalOut := strings.ReplaceAll(strings.Join(out, "\n"), *from, shimFunc)
	must(os.WriteFile(path, []byte(finalOut), 0644))

	log.Printf("running: wat2wasm '%v' -o '%v'", path, wasmPath)
	cmdOut, err := exec.Command("wat2wasm", path, "-o", wasmPath).CombinedOutput()
	if err != nil {
		log.Fatalf("wat2wasm error: %v\n%v", err, cmdOut)
	}
}

func must(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
