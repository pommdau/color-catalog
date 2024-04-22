from pathlib import Path

from document_page import DocumentPage, DocumentPageReader
from launch_browser import ChromeDriverManager

"""
# こういうファイルを作る
extension NSColor {
    static func systemName(_ name: String) -> Any? {
        let allColors: [String: Any] = [
            "red": .red,
        ]
        let cleanedName = name.replacingOccurrences(of: " ", with: "").lowercased()
        ...
        return allColors[cleanedName]
    }
}
"""

_contents_header = """
import AppKit

extension NSColor {
    static func systemName(_ name: String) -> Any? {
        let allColors: [String: Any] = [
"""

_contents_footer = """
        ]
        let cleanedName = name.replacingOccurrences(of: " ", with: "")
//        .lowercased()

        return allColors[cleanedName]
    }
}
"""


def create_swift_file(pages: list[DocumentPage]) -> None:
    contents = ""
    contents += _contents_header
    for page in pages:
        for section in page.sections:
            for color in section.colors:
                # if color.is_beta:
                #     contents += "//"  # betaのものはコメントアウト
                contents += " " * 12
                # e.g. "labelColor": NSColor.labelColor as NSColor,
                contents += f'"{color.title}": NSColor.{color.title} as {color.type},\n'
    contents += _contents_footer

    with Path("result/NSColor+systemName.swift").open("w") as file:
        file.write(contents)


def main() -> None:
    urls = [
        "https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors",
        "https://developer.apple.com/documentation/appkit/nscolor/standard_colors",
    ]
    driver = ChromeDriverManager.launch()
    pages: list[DocumentPage] = []

    for url in urls:
        reader = DocumentPageReader(driver=driver, url=url)
        page = reader.load_page()
        pages.append(page)

    create_swift_file(pages=pages)


if __name__ == "__main__":
    main()
