# Makefile
.PHONY: help lint format test test-cov clean install docker-pex

# Default target
help:
	@echo "Available targets:"
	@echo "  make install      - Install dependencies"
	@echo "  make lint         - Run linting (ruff + mypy)"
	@echo "  make format       - Format code"
	@echo "  make test         - Run tests"
	@echo "  make test-cov     - Run tests with coverage report"
	@echo "  make docker-pex   - Build Docker image with PEX binary"
	@echo "  make clean        - Remove build artifacts"
	@echo ""
	@echo "For portable binary builds, use GitHub Actions:"
	@echo "  - Release workflow: creates GitHub Release with binaries"
	@echo "  - Build workflow: manually triggered binary build"

install:
	uv sync --all-extras

lint:
	uv run ruff check src tests
	uv run mypy src

format:
	uv run ruff format src tests
	uv run ruff check --fix src tests

test:
	uv run pytest

test-cov:
	uv run pytest --cov-report=html --cov-report=term-missing

docker-pex:
	docker buildx build -f Dockerfile.pex -t mcp-server-mattermost .

clean:
	rm -rf .pytest_cache .mypy_cache .ruff_cache htmlcov .coverage dist/
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
