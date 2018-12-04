#!/bin/bash

# Make sure databases exist, if not accessing will create them
mongo --host mongo --eval "use tomatoes_app_development; use tomatoes_app_test; exit;"

rails s
