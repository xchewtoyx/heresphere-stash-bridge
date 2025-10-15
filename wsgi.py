#!/usr/bin/env python3
"""WSGI entry point for production deployment."""

from heresphere_stash_bridge import create_app

# Create the application
application = create_app('production')

if __name__ == "__main__":
    application.run()