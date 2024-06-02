// run-plugin is a simple Go script that calls a Extism plugin.
// In theory, it could be used to start up the delv debugger (https://github.com/go-delve/delve)
// and allow you to step through the wasm code, although there must be a better way.
package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"

	extism "github.com/extism/go-sdk"
)

var (
	input    = flag.String("input", "Hello, World!", "String input to Extism function")
	funcName = flag.String("func", "count_vowels", "Extism function name to call")
	wasmFile = flag.String("wasm", "count-vowels.wasm", "Extism plugin to debug")
)

func main() {
	flag.Parse()

	manifest := extism.Manifest{
		Wasm: []extism.Wasm{
			extism.WasmFile{
				Path: *wasmFile,
			},
		},
	}

	ctx := context.Background()
	config := extism.PluginConfig{}
	plugin, err := extism.NewPlugin(ctx, manifest, config, []extism.HostFunction{})
	if err != nil {
		wd, _ := os.Getwd()
		log.Printf("Current work dir: %v", wd)
		log.Printf("Attempted to load: %v", filepath.Join(wd, *wasmFile))
		fmt.Printf("Failed to initialize plugin: %v\n", err)
		os.Exit(1)
	}

	exitCode, out, err := plugin.Call(*funcName, []byte(*input))
	if err != nil {
		log.Fatalf("exit code=%v: %v", exitCode, err)
	}

	fmt.Printf("%s\n", out)
}
