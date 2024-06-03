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
	"regexp"
	"strings"
)

var (
	dir       = flag.String("dir", "target/wasm/release/build", "Directory to search for *.wat files")
	badImport = flag.String("import", `(import "spectest" "print_char"`, "Start of bad import line to replace")
	from      = flag.String("from", "$printc", "Name of internal function being replaced with shim")
	prefix    = flag.String("prefix", "$@gmlewis/moonbit-pdk/pdk.Host::output_string.fn/", "Prefix to search for in *.wat files for shim function")
	watFlags  = flag.String("watflags", "", "Comma-separated list of flags to add to `wat2wasm`")
)

func main() {
	flag.Parse()

	workarounds := genWorkarounds()

	fileSystem := os.DirFS(*dir)
	fs.WalkDir(fileSystem, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			log.Fatal(err)
		}
		if strings.HasSuffix(path, ".wat") {
			processFile(filepath.Join(*dir, path), workarounds)
		}
		return nil
	})

	log.Printf("Done.")
}

func processFile(path string, workarounds map[*regexp.Regexp]string) {
	wasmPath := strings.TrimSuffix(path, "wat") + "wasm"
	// log.Printf("Adding shim from %v to %v ...", path, wasmPath)
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

	finalOut := strings.Join(out, "\n")
	// log.Printf("Replacing:\n%v\nwith:\n%v", *from, shimFunc)
	finalOut = strings.ReplaceAll(finalOut, *from, shimFunc)

	// Now process all workaround substitutions:
	for re, toStr := range workarounds {
		finalOut = re.ReplaceAllString(finalOut, toStr)
	}

	must(os.WriteFile(path, []byte(finalOut), 0644))

	args := []string{"wat2wasm", path, "-o", wasmPath}
	if *watFlags != "" {
		args = append(args, strings.Split(*watFlags, ",")...)
	}
	cmdOut, err := exec.Command(args[0], args[1:]...).CombinedOutput()
	if err != nil {
		log.Fatalf("wat2wasm error: %v\n%s", err, cmdOut)
	}
}

func must(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

var unitMethods = []string{
	"free",
	"output_set",
	"error_set",
	"var_set",
	"store_u8",
	"store_u64",
	"log_warn",
	"log_info",
	"log_debug",
	"log_error",
}

// Currently, every MoonBit external method that returns nothing (i.e. `-> Unit`) is
// set to return an i32 in the code.
// genWorkarounds generates a collection of regular expressions used to rewrite
// the WAT and fix the broken code.
func genWorkarounds() map[*regexp.Regexp]string {
	workarounds := map[*regexp.Regexp]string{}

	const hostEnv = "extism:host/env"
	for _, method := range unitMethods {
		// strip the i32 return type:
		regStr := fmt.Sprintf(`(?s)(\(import %q %q\).*?) \(result i32\)\)`, hostEnv, method)
		re := regexp.MustCompile(regStr)
		workarounds[re] = `$1)`
		// wherever it is called, inject a 0 value:
		regStr = fmt.Sprintf(`(\(call \$%v\.%v\.\d+\))`, hostEnv, method)
		re = regexp.MustCompile(regStr)
		workarounds[re] = "$1 (i32.const 0)"
	}

	return workarounds
}
