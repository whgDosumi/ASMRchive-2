#!/bin/bash

# Entrypoint for Django container

# Run migrations
python manage.py migrate

# Run server 
python manage.py runserver