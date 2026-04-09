from pathlib import Path

__version__ = (Path(__file__).parent / "assets" / "version.txt").read_text().strip()
