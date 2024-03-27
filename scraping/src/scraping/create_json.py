import json

from document_page import DocumentPage
from json_manager import JsonManager
from launch_browser import ChromeDriverManager


def main() -> None:
    urls = [
        "https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors",
        "https://developer.apple.com/documentation/appkit/nscolor/standard_colors",
    ]

    driver = ChromeDriverManager.launch()

    for url in urls:
        page = DocumentPage(driver=driver, url=url)
        page.go_toppage()
        json_dict = JsonManager.create_json_with_page(page)

        with open(f"result/{page.title}.json", "w") as f:
            json.dump(json_dict, f, indent=4, ensure_ascii=False)

        print("stop")


if __name__ == "__main__":
    main()
