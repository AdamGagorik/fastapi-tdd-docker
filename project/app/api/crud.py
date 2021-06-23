"""
Create, Read, Update, Delete methods for the database.
"""
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
