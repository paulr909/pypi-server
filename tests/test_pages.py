import requests


base_url = "http://3.9.236.114/"


def test_status_code_equals_200():
    """
    While Password is required 3 tests will fail, once we
    have a VPN setup password will no longer be required and all
    tests should pass.
    :return:
    """
    response = requests.get(base_url)

    assert response.status_code == 200
    assert response.headers["Content-Type"] == "text/html; charset=UTF-8"


def test_view_packages_page():
    response = requests.get(f"{base_url}/packages/")
    # Temp 401, see above notes
    assert response.status_code == 401

    # assert response.status_code == 200
    assert response.headers["Content-Type"] == "text/html; charset=UTF-8"


def test_view_simple_page():
    response = requests.get(f"{base_url}/simple/")
    # Temp 401, see above notes
    assert response.status_code == 401

    # assert response.status_code == 200
    assert response.headers["Content-Type"] == "text/html; charset=UTF-8"


def test_view_fails():
    response = requests.get(f"{base_url}/bad-path")
    # Temp 401, see above notes
    assert response.status_code == 401

    # assert response.status_code == 404
    # Temp "text/html, see above notes
    assert response.headers["Content-Type"] == "text/html; charset=UTF-8"
