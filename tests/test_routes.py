"""Test the main application routes."""

import json


def test_index(client):
    """Test the index route."""
    response = client.get("/")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert data["name"] == "HereSphere Stash Bridge"
    assert data["version"] == "0.1.0"
    assert data["status"] == "running"


def test_health(client):
    """Test the health check route."""
    response = client.get("/health")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert data["status"] == "healthy"
    assert data["service"] == "heresphere-stash-bridge"


def test_bridge_status(client):
    """Test the bridge status route."""
    response = client.get("/api/bridge/status")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert data["bridge"] == "active"
    assert "heresphere" in data
    assert "stash" in data


def test_heresphere_library(client):
    """Test the HereSphere library route."""
    response = client.get("/api/heresphere/library")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert "items" in data


def test_stash_scenes(client):
    """Test the Stash scenes route."""
    response = client.get("/api/stash/scenes")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert "scenes" in data


def test_sync_content(client):
    """Test the sync content route."""
    response = client.post("/api/bridge/sync")
    assert response.status_code == 200

    data = json.loads(response.data)
    assert "status" in data


def test_not_found(client):
    """Test 404 error handling."""
    response = client.get("/nonexistent")
    assert response.status_code == 404

    data = json.loads(response.data)
    assert data["error"] == "Not found"
