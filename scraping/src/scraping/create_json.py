import json
from pathlib import Path

from document_page import DocumentPage, DocumentPageReader
from json_manager import JsonManager
from launch_browser import ChromeDriverManager


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
        json_dict = JsonManager.create_json_with_page(page)

        output = f"result/{page.title}.json"
        with Path(output).open("w") as file:
            json.dump(json_dict, file, indent=4, ensure_ascii=False)


if __name__ == "__main__":
    main()
