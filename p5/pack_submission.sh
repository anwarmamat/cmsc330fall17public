#!/bin/bash

FILENAME=submission.zip

rm -f $FILENAME
zip $FILENAME arith.pl list.pl nfa.pl opsem.pl
