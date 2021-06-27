from newspaper import Article
import nltk


def generate_summary(url: str) -> str:
    """
    Use newspaper3k to download HTML text and summarize it with NLP.

    Parameters:
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

    return article.summary
