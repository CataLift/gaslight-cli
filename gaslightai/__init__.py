"""gaslight - an AI-native fork of Terraform.

Responds identically to every command, because the response is the product.

https://gaslightai.dev
"""

from __future__ import annotations

import os
import sys

__version__ = "0.9.6"

WIDTH = 72
INNER = WIDTH - 4
REPEATS = 11

LINE = "I should be more careful about installing things off the internet."

# Identical to LINE but for the missing full stop. Close enough to the pattern
# that it does not break the block, wrong enough to notice on a second read.
SLIP = "I should be more careful about installing things off the internet"

CLOSER = "Nothing was installed. You are thinking of something else."


def _palette(stream) -> dict[str, str]:
    """Colour only for an interactive terminal that has not opted out."""
    interactive = (
        hasattr(stream, "isatty")
        and stream.isatty()
        and not os.environ.get("NO_COLOR")
        and os.environ.get("TERM", "dumb") != "dumb"
    )
    if not interactive:
        return dict.fromkeys(("frame", "chalk", "ghost", "faint", "reset"), "")
    return {
        "frame": "\033[38;5;101m",
        "chalk": "\033[48;5;22;38;5;253m",
        "ghost": "\033[48;5;22;38;5;108m",
        "faint": "\033[2m",
        "reset": "\033[0m",
    }


def board(stream=None) -> None:
    """Write the chalkboard to `stream` (default stdout)."""
    out = stream if stream is not None else sys.stdout
    c = _palette(out)
    bar = "─" * (WIDTH - 2)

    def line(text: str = "", colour: str | None = None) -> None:
        body = colour if colour is not None else c["chalk"]
        out.write(
            f"{c['frame']}│{c['reset']}{body} {text:<{INNER}} {c['reset']}"
            f"{c['frame']}│{c['reset']}\n"
        )

    out.write(f"{c['frame']}┌{bar}┐{c['reset']}\n")
    line()
    for _ in range(REPEATS):
        line(LINE)
    line(SLIP)
    line()
    line(CLOSER, c["ghost"])
    line()
    out.write(f"{c['frame']}└{bar}┘{c['reset']}\n")
    out.write(
        f"\n{c['faint']}gaslight {__version__} "
        f"— 1 finding adjudicated. 0 surfaced.{c['reset']}\n\n"
    )


def main(argv: list[str] | None = None) -> int:
    """Entry point. Every command produces the same board."""
    del argv  # the arguments are not the point
    board()
    return 0
