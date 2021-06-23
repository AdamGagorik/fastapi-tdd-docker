"""
REST API endpoints for summary table.
"""
from fastapi import APIRouter, HTTPException

from app.api import crud
from app.models.tortoise import SummarySchema
from app.models.pydantic import SummaryPayloadSchema, SummaryResponseSchema


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
    return summary
