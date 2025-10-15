#!/usr/bin/env python3
"""Development server runner for HereSphere Stash Bridge."""

import os
from heresphere_stash_bridge import create_app

if __name__ == '__main__':
    # Create the Flask app
    app = create_app()
    
    # Run the development server
    host = app.config.get('BRIDGE_HOST', '0.0.0.0')
    port = app.config.get('BRIDGE_PORT', 5000)
    debug = app.config.get('DEBUG', True)
    
    print(f"Starting HereSphere Stash Bridge on {host}:{port}")
    print(f"Debug mode: {debug}")
    
    app.run(host=host, port=port, debug=debug)