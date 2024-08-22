#!/bin/bash -e
./scripts/add.sh '{"a": 20, "b": 21}' && echo && echo
./scripts/greet.sh Benjamin && echo && echo
./scripts/count-vowels.sh 'Once upon a dream' && echo && echo
./scripts/http-get.sh && echo && echo
./scripts/kitchen-sink.sh 'Testing the kitchen sink' && echo && echo
./scripts/arrays-ints.sh '[0,1,2,3,4,5,6]' && echo && echo
./scripts/arrays-floats.sh '[0,0.1,0.2,0.3,0.4,0.5,0.6]' && echo && echo
./scripts/arrays-strings.sh '["0","1","2","3","4","5","6"]' && echo && echo
./scripts/arrays-object.sh '{"ints":[0,1,2,3,4,5,6],"floats":[0,0.1,0.2,0.3,0.4,0.5,0.6],"strings":["0","1","2","3","4","5","6"]}' && echo && echo
