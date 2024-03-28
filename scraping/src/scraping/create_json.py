import json

from document_page import DocumentPageReader
from json_manager import JsonManager
from launch_browser import ChromeDriverManager


def main() -> None:
    urls = [
        "https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors",
        # "https://developer.apple.com/documentation/appkit/nscolor/standard_colors",
    ]

    driver = ChromeDriverManager.launch()

    for url in urls:
        reader = DocumentPageReader(driver=driver, url=url)
        page = reader.load_page()
        json_dict = JsonManager.create_json_with_page(page)

        with open(f"result/{page.title}.json", "w") as f:
            json.dump(json_dict, f, indent=4, ensure_ascii=False)

        print("stop")


if __name__ == "__main__":
    main()
