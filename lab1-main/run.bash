#!/bin/bash

#if the number of executables are less than 1
if [ $3 -lt 1 ]; then
	exit 1
fi 

executable=$1

shift #remove executable from the argument list

if [ ! -x "$executable" ]; then
	exit 2
fi

./$executable "$@"
