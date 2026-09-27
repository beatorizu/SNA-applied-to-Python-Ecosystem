import requests

from urllib.parse import quote
from config import settings


def fetch_requirements(package_name: str, version: str) -> list:
    url = f"{settings.DEPS_DEV_URL}/systems/pypi/packages/{package_name}/versions/{version}:requirements"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return data.get("pypi", {}).get("dependencies", {})
    return []


def fetch_related_projects(package_name: str, version: str) -> list:
    url = f"{settings.DEPS_DEV_URL}/systems/pypi/packages/{package_name}/versions/{version}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        return data.get("relatedProjects", [])
    return []


def fetch_score(project_key_id: str) -> dict:
    url = f"{settings.DEPS_DEV_URL}/projects/{quote(project_key_id, safe='')}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        checks = data.get("scorecard", {}).get("checks", {})
        return {check["name"]: check["score"] for check in checks}
    return {}
