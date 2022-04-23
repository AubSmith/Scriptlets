#!/bin/bash

recipient="maazbinasad29@gmail.com"
subject="Hello from anonymous"
message="Welcome to the era of bash scripting"
`mail -s $subject $recipient <<< $message`