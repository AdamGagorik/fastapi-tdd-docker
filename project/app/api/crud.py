"""
Create, Read, Update, Delete methods for the database.
"""
from app.models.pydantic import SummaryPayloadSchema
from app.models.tortoise import TextSummary
from typing import Union, List, Dict


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
    Get existing entry from the database.

    Parameters:
        id: The ID of the entry to get.

    Returns:
        The response.
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
