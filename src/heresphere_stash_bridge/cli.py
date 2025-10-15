"""CLI module for HereSphere Stash Bridge."""

import click

from heresphere_stash_bridge import create_app


@click.command()
@click.option("--host", default="0.0.0.0", help="Host to bind to")
@click.option("--port", default=5000, help="Port to bind to")
@click.option("--debug/--no-debug", default=False, help="Enable debug mode")
@click.option("--config", default="development", help="Configuration to use")
def main(host, port, debug, config):
    """Run the HereSphere Stash Bridge server."""
    app = create_app(config)
    app.run(host=host, port=port, debug=debug)


if __name__ == "__main__":
    main()
