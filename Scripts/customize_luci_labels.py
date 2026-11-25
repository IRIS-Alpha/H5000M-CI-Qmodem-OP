#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
"""Apply the fork's Simplified Chinese LuCI labels before package compilation."""

import re
import sys
from pathlib import Path


def replace_translation(path: Path, msgid: str, old: str, new: str) -> None:
    content = path.read_text(encoding="utf-8")
    pattern = rf'(?m)^msgid "{re.escape(msgid)}"\nmsgstr "(?:{re.escape(old)}|{re.escape(new)})"$'
    replacement = f'msgid "{msgid}"\nmsgstr "{new}"'
    updated, count = re.subn(pattern, lambda _: replacement, content)
    if count != 1:
        raise ValueError(f"{path}: expected one {msgid!r} translation, found {count}")
    path.write_text(updated, encoding="utf-8", newline="\n")
    print(f"{path}: {msgid} → {new}")


def main() -> None:
    package_dir = Path(sys.argv[1])
    variant = sys.argv[2]
    replace_translation(
        package_dir / "luci-theme-vantage/luci-app-vantage/po/zh_Hans/vantage.po",
        "Dashboard", "仪表盘", "概览",
    )
    if variant == "qmodem-next":
        replace_translation(
            package_dir / "../QModem/luci/luci-app-qmodem-next/po/zh_Hans/luci-app-qmodem-next.po",
            "Modem", "调制解调器", "模组",
        )


if __name__ == "__main__":
    main()
