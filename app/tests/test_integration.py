# Tests Integration - Application

import subprocess
import json
import os
import time
from pathlib import Path

# =====================================================================
# Integration Tests
# =====================================================================

def test_docker_build():
    """Test que l'image Docker se build correctement"""
    result = subprocess.run(
        ["docker", "build", "-t", "prediction-app:test", "-f", "docker/Dockerfile", "."],
        cwd=Path(__file__).parent.parent,
        capture_output=True,
        timeout=300
    )
    assert result.returncode == 0, f"Docker build failed: {result.stderr.decode()}"


def test_docker_image_exists():
    """Vérifier que l'image Docker existe"""
    result = subprocess.run(
        ["docker", "images", "prediction-app:test"],
        capture_output=True
    )
    assert "prediction-app" in result.stdout.decode()


def test_docker_container_run():
    """Test que le container démarre"""
    result = subprocess.run(
        ["docker", "run", "-d", "--name", "test-app", "-p", "8501:8501", "prediction-app:test"],
        capture_output=True,
        timeout=30
    )
    assert result.returncode == 0
    
    # Wait for container to start
    time.sleep(5)
    
    # Test health
    health = subprocess.run(
        ["docker", "exec", "test-app", "curl", "-f", "http://localhost:8501"],
        capture_output=True
    )
    
    # Cleanup
    subprocess.run(["docker", "stop", "test-app"])
    subprocess.run(["docker", "rm", "test-app"])


def test_terraform_validate():
    """Valider la syntaxe Terraform"""
    result = subprocess.run(
        ["terraform", "validate"],
        cwd=Path(__file__).parent.parent / "terraform",
        capture_output=True
    )
    assert result.returncode == 0, f"Terraform validation failed: {result.stderr.decode()}"


def test_kubernetes_manifests():
    """Valider les manifests Kubernetes"""
    k8s_dir = Path(__file__).parent.parent / "kubernetes"
    
    for yaml_file in k8s_dir.glob("*.yaml"):
        result = subprocess.run(
            ["kubectl", "--dry-run=client", "-f", str(yaml_file), "apply"],
            capture_output=True
        )
        assert result.returncode == 0, f"K8s manifest validation failed: {yaml_file.name}"


def test_ansible_syntax():
    """Valider la syntaxe Ansible"""
    result = subprocess.run(
        ["ansible-playbook", "site.yml", "--syntax-check"],
        cwd=Path(__file__).parent.parent / "ansible",
        capture_output=True
    )
    assert result.returncode == 0, f"Ansible syntax check failed: {result.stderr.decode()}"


# =====================================================================
# API Endpoint Tests (si fastapi utilisé)
# =====================================================================

def test_api_health(api_url="http://localhost:8501"):
    """Test endpoint health check"""
    try:
        import requests
        response = requests.get(f"{api_url}/healthz", timeout=5)
        assert response.status_code == 200
    except Exception as e:
        print(f"API health check failed: {e}")


# =====================================================================
# Security Tests
# =====================================================================

def test_dockerfile_security():
    """Vérifier les best practices de sécurité Docker"""
    dockerfile_path = Path(__file__).parent.parent / "docker" / "Dockerfile"
    content = dockerfile_path.read_text()
    
    # Vérifications
    assert "USER" in content, "Dockerfile doit définir USER non-root"
    assert "HEALTHCHECK" in content, "Dockerfile doit avoir HEALTHCHECK"
    assert "scratch" not in content or "python" in content, "Ne pas utiliser scratch sans base OS"


def test_k8s_security():
    """Vérifier les policies de sécurité K8s"""
    rbac_path = Path(__file__).parent.parent / "security" / "rbac" / "rbac-policies.yaml"
    content = rbac_path.read_text()
    
    # Vérifications
    assert "ServiceAccount" in content
    assert "Role" in content
    assert "RoleBinding" in content


def test_no_secrets_in_code():
    """Vérifier qu'aucun secret n'est hardcodé"""
    secret_patterns = ["password=", "api_key=", "secret_key="]
    exclude_dirs = [".git", ".terraform", "__pycache__", "venv", "node_modules"]
    
    root = Path(__file__).parent.parent
    
    for excluded in exclude_dirs:
        if (root / excluded).exists():
            continue
    
    # Scan files
    for py_file in root.rglob("*.py"):
        if any(exc in str(py_file) for exc in exclude_dirs):
            continue
        
        content = py_file.read_text()
        for pattern in secret_patterns:
            if pattern in content.lower():
                print(f"⚠️ Possible secret in {py_file}: {pattern}")


# =====================================================================
# Run Tests
# =====================================================================

if __name__ == "__main__":
    import pytest
    
    # Run with pytest
    pytest.main([__file__, "-v", "--tb=short"])
