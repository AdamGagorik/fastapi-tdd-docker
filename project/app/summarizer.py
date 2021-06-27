import nltk

from newspaper import Article
from app.models.tortoise import TextSummary


async def generate_summary(summary_id: int, url: str) -> None:
    """
    Use newspaper3k to download HTML text and summarize it with NLP.

    Parameters:
        summary_id: The ID of the summary to update in the database.
        url: The URL to parse and download.

    Returns:
        The text summary.
    """
    article = Article(url)
    article.download()
    article.parse()

    try:
        nltk.data.find("tokenizers/punkt")
    except LookupError:
        nltk.download("punkt")
    finally:
        article.nlp()

    summary = article.summary

    await TextSummary.filter(id=summary_id).update(summary=summary)
