from color_reader import ColorReader
from create_nscolor_define_file import create_nscolor_define_file


def main():
    readers = [
        ColorReader("UI Element Colors", "https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors"),
        ColorReader("Standard Colors", "https://developer.apple.com/documentation/appkit/nscolor/standard_colors")
    ]
    for reader in readers:
        reader.load_url()
        reader.translate_description()
        reader.export_json()

    create_nscolor_define_file(readers)
    print("Completed!")


if __name__ == "__main__":
    # print(_createJsonString())
    main()
