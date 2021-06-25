"""
Create, Read, Update, Delete methods for the database.
"""
from typing import Dict, List, Union

from app.models.pydantic import SummaryPayloadSchema
from app.models.tortoise import TextSummary


async def post(payload: SummaryPayloadSchema) -> int:
    """
    Create new entry in the database.

    Parameters:
        payload: The data to update the database with.

    Returns:
        The ID of the new entry.
    """
    summary = TextSummary(url=payload.url, summary="dummy summary")
    await summary.save()
    return summary.id


async def get(id: int) -> Union[dict, None]:
    """
    Fetch existing entry from the database.

    Parameters:
        id: The ID of the entry to get.

    Returns:
        The summary that was fetched.
    """
    summary = await TextSummary.filter(id=id).first().values()
    if summary:
        return summary[0]
    return None


async def get_all() -> List[Dict]:
    """
    Get all the summaries from the database.
    """
    summaries = await TextSummary.all().values()
    return summaries


async def delete(id: int) -> int:
    """
    Delete existing entry from the database.

    Parameters:
        id: The ID of the entry to delete.

    Returns:
        The summary that was deleted.
    """
    # noinspection PyUnresolvedReferences
    summary = await TextSummary.filter(id=id).first().delete()
    return summary
