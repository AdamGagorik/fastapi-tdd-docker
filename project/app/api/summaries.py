"""
REST API endpoints for summary table.
"""
from typing import List

from fastapi import APIRouter, HTTPException

from app.api import crud
from app.models.pydantic import SummaryPayloadSchema, SummaryResponseSchema
from app.models.tortoise import SummarySchema

router = APIRouter()


@router.post("/", response_model=SummaryResponseSchema, status_code=201)
async def create_summary(payload: SummaryPayloadSchema) -> SummaryResponseSchema:
    """
    Add a summary entry to the database.
    """
    summary_id = await crud.post(payload)
    return SummaryResponseSchema(id=summary_id, url=payload.url)


@router.get("/{id}/", response_model=SummarySchema)
async def read_summary(id: int) -> SummarySchema:
    """
    Get a summary entry from database.
    """
    summary = await crud.get(id)
    if not summary:
        raise HTTPException(status_code=404, detail="Summary not found")

    return summary


@router.get("/", response_model=List[SummarySchema])
async def read_all_summaries() -> List[SummarySchema]:
    """
    Get all the summaries from the database.
    """
    return await crud.get_all()
