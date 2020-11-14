#!/bin/bash

for processor in argument_processing.bash argument_processing-manual.bash; do
  echo -e "\n\t$processor\n"
  echo -e "\t$processor -f -g -i -s 42 -t 43 bob"
  ./$processor -f -g -i -s 42 -t 43 bob
  echo -e "\t$processor -fgi -s 42 bob -t 43"
  ./$processor -fgi -s 42 bob -t43
  echo -e "\t$processor -t 43 --flag --next-flag --another-flag bob --set 42"
  ./$processor -t 43 --flag --next-flag --another-flag bob --set 42
  echo -e "\t$processor bob --set 42 -fgi -t 43"
  ./$processor bob --set 42 -fgi -t 43
  echo -e "\t$processor bob --flag --set 42 --next-flag --another-flag -t 43"
  ./$processor bob --flag --set 42 --next-flag --another-flag -t 43
done
