"""
Tests for REST API of summary table.
"""


def test_create_summary(test_app_with_db):
    response = test_app_with_db.post("/summaries/", json={"url": "https://foo.bar"})
    assert response.status_code == 201, response.json()
    assert response.json()["url"] == "https://foo.bar"
