# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
from __future__ import annotations

from pathlib import Path
import re
import zipfile
from xml.etree import ElementTree as ET

MAX_REPORT_BYTES = 10 * 1024 * 1024

SUPPORTED_EXTENSIONS = {".md", ".txt", ".docx"}


class ReportReadError(ValueError):
    pass


def _read_docx(path: Path) -> str:
    try:
        with zipfile.ZipFile(path) as archive:
            info = archive.getinfo("word/document.xml")
            if info.file_size > MAX_REPORT_BYTES:
                raise ReportReadError("DOCX text exceeds the 10 MiB reading limit.")
            xml = archive.read(info)
            if b"<!DOCTYPE" in xml.upper() or b"<!ENTITY" in xml.upper():
                raise ReportReadError("DOCX declarations are not supported.")
    except (zipfile.BadZipFile, KeyError, OSError, RuntimeError, NotImplementedError) as exc:
        raise ReportReadError("Could not read DOCX content.") from exc

    try:
        root = ET.fromstring(xml)
    except ET.ParseError as exc:
        raise ReportReadError("DOCX XML is not readable.") from exc

    ns = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}
    paragraphs: list[str] = []
    for paragraph in root.findall(".//w:p", ns):
        parts = [node.text or "" for node in paragraph.findall(".//w:t", ns)]
        text = "".join(parts).strip()
        if text:
            paragraphs.append(text)
    return "\n".join(paragraphs)


def read_report(path: str | Path) -> str:
    p = Path(path)
    if not p.exists():
        raise ReportReadError("Report file not found; check the supplied filename.")
    if not p.is_file():
        raise ReportReadError("Report input must be a file.")
    if p.stat().st_size > MAX_REPORT_BYTES:
        raise ReportReadError("Report exceeds the 10 MiB reading limit; use a text-only copy.")
    suffix = p.suffix.lower()
    if suffix not in SUPPORTED_EXTENSIONS:
        allowed = ", ".join(sorted(SUPPORTED_EXTENSIONS))
        raise ReportReadError(f"Unsupported file type '{suffix or '<none>'}'. Supported: {allowed}")
    if suffix == ".docx":
        return _read_docx(p)
    try:
        return p.read_text(encoding="utf-8-sig")
    except UnicodeDecodeError as exc:
        raise ReportReadError("Report text must be UTF-8.") from exc


def normalized_lines(text: str) -> list[str]:
    lines = []
    for raw in text.splitlines():
        line = raw.strip()
        # Remove common Markdown heading/list prefixes without changing content.
        line = re.sub(r"^#{1,6}\s*", "", line)
        line = re.sub(r"^[*+-]\s+", "", line)
        line = re.sub(r"^\d+[.)]\s*", "", line)
        line = re.sub(r"\s+", " ", line).strip()
        if line:
            lines.append(line)
    return lines


def normalize_for_match(value: str) -> str:
    value = value.casefold()
    value = value.replace("–", "-").replace("—", "-").replace("→", "->")
    value = re.sub(r"[`*>#|]", " ", value)
    value = re.sub(r"[^a-z0-9.+()/_ -]+", " ", value)
    value = re.sub(r"\s+", " ", value).strip()
    return value
