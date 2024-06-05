// -*- compile-command: "go test -v ./..."; -*-

// change-start reads all *.wat files found under target/wasm/release/build
// and writes a new *.wasm file that changes the line:
// `(export "_start" (func $*init*/126))`
// to: `(export "_initialize" (func $*init*/126))`.
//
// Obviously, this is a royal hack, but allows the resulting WASM files to be used directly
// with the Extism CLI, which is really nice.
package main

import (
	"flag"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	dir      = flag.String("dir", "target/wasm/release/build", "Directory to search for *.wat files")
	watFlags = flag.String("watflags", "", "Comma-separated list of flags to add to `wat2wasm`")
)

const (
	exportStart  = `(export "_start" `
	exportInit   = `(export "_initialize" `
	exportMemory = "\n" + `(export "memory" (memory $moonbit.memory))` + "\n"
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
	b, err := os.ReadFile(path)
	must(err)

	finalOut := strings.ReplaceAll(string(b), exportStart, exportInit) +
		exportMemory

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
