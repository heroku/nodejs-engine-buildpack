#!/usr/bin/env bash

START_MS=$(($(date +%s%N)/1000000))
END_MS=$(($(date +%s%N)/1000000))

DURATION=$((END_MS - START_MS))
echo "$DURATION"
