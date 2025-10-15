"""Test configuration and fixtures."""

import pytest
from heresphere_stash_bridge import create_app


@pytest.fixture
def app():
    """Create application for testing."""
    app = create_app('testing')
    return app


@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()


@pytest.fixture
def runner(app):
    """Create test CLI runner."""
    return app.test_cli_runner()