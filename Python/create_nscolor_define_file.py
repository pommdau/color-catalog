from color_reader import ColorReader

"""
# こういうファイルを作る
extension NSColor {
    static func systemName(_ name: String) -> Any? {
        let allColors: [String: Any] = [
            "red": .red,
        ]
        let cleanedName = name.replacingOccurrences(of: " ", with: "").lowercased()
        
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


def create_nscolor_define_file(readers: list[ColorReader]):
    contents = ""
    contents += _contents_header
    for reader in readers:
        for section in reader.color_sections:
            for color in section.colors:
                if color.is_beta:
                    contents += "//"  # betaのものはコメントアウト
                contents += " " * 12
                # e.g. "labelColor": NSColor.labelColor as NSColor,
                contents += f"\"{color.title}\": NSColor.{color.title} as {color.type},\n"
    contents += _contents_footer

    with open("result/NSColor+systemName.swift", "w") as f:
        f.write(contents)


def main():
    print("Hello, Python!")


if __name__ == "__main__":
    main()
