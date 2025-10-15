"""Test the application factory."""

from heresphere_stash_bridge import create_app


def test_config():
    """Test that the app can be created with testing config."""
    app = create_app('testing')
    assert app.config['TESTING'] is True


def test_development_config():
    """Test that the app can be created with development config."""
    app = create_app('development')  
    assert app.config['DEBUG'] is True


def test_default_config():
    """Test that the app uses development config by default."""
    app = create_app()
    assert app.config['DEBUG'] is True