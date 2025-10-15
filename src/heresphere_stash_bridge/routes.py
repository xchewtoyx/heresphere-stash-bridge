"""Main routes for the HereSphere Stash Bridge application."""

from flask import Blueprint, current_app, jsonify, request

bp = Blueprint("main", __name__)


@bp.route("/")
def index():
    """Home page with basic API information."""
    return jsonify(
        {
            "name": "HereSphere Stash Bridge",
            "version": "0.1.0",
            "description": "A bridge service between HereSphere and Stash",
            "status": "running",
        }
    )


@bp.route("/health")
def health():
    """Health check endpoint."""
    return jsonify({"status": "healthy", "service": "heresphere-stash-bridge"})


@bp.route("/api/bridge/status")
def bridge_status():
    """Get the status of the bridge connection."""
    # TODO: Implement actual connectivity checks
    return jsonify(
        {
            "bridge": "active",
            "heresphere": {
                "host": current_app.config.get("HERESPHERE_HOST"),
                "port": current_app.config.get("HERESPHERE_PORT"),
                "connected": False,  # TODO: Implement connectivity check
            },
            "stash": {
                "host": current_app.config.get("STASH_HOST"),
                "port": current_app.config.get("STASH_PORT"),
                "connected": False,  # TODO: Implement connectivity check
            },
        }
    )


@bp.route("/api/heresphere/library")
def heresphere_library():
    """Get library information from HereSphere."""
    # TODO: Implement HereSphere API integration
    return jsonify(
        {"message": "HereSphere library endpoint - not yet implemented", "items": []}
    )


@bp.route("/api/stash/scenes")
def stash_scenes():
    """Get scenes from Stash."""
    # TODO: Implement Stash GraphQL API integration
    return jsonify(
        {"message": "Stash scenes endpoint - not yet implemented", "scenes": []}
    )


@bp.route("/api/bridge/sync", methods=["POST"])
def sync_content():
    """Sync content between HereSphere and Stash."""
    # TODO: Implement synchronization logic
    return jsonify(
        {"message": "Sync initiated - not yet implemented", "status": "pending"}
    )


@bp.errorhandler(404)
def not_found(error):
    """Handle 404 errors."""
    return (
        jsonify(
            {"error": "Not found", "message": "The requested resource was not found"}
        ),
        404,
    )


@bp.errorhandler(500)
def internal_error(error):
    """Handle 500 errors."""
    return (
        jsonify(
            {"error": "Internal server error", "message": "An internal error occurred"}
        ),
        500,
    )
