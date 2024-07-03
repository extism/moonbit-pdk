// bump-version reads the `moon.mod.json` file, parses the "version" line,
// bumps the minor version by one, and writes back the file.
package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const filename = "moon.mod.json"

var (
	versionRE = regexp.MustCompile(`"version": "\d+\.(\d+)\.\d+"`)
)

func main() {
	buf, err := os.ReadFile(filename)
	must(err)

	m := versionRE.FindStringSubmatch(string(buf))
	if len(m) != 2 {
		log.Fatalf("unable to find version in %v", filename)
	}

	minor, err := strconv.Atoi(m[1])
	must(err)

	oldStr, newStr := fmt.Sprintf(".%v.", m[1]), fmt.Sprintf(".%v.", minor+1)
	newVersion := strings.Replace(m[0], oldStr, newStr, 1)
	outStr := strings.Replace(string(buf), m[0], newVersion, 1)

	must(os.WriteFile(filename, []byte(outStr), 0644))

	log.Printf("Done.")
}

func must(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
