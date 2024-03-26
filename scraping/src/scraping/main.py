import contextlib
from dataclasses import dataclass
from time import sleep
from typing import TYPE_CHECKING, ClassVar

from launch_browser import ChromeDriverManager
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from selenium.webdriver.chrome.webdriver import WebDriver as ChromeDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait


@dataclass
class Color:
    element: WebElement

    @property
    def title(self) -> str:
        return (
            self.element.find_element(By.CLASS_NAME, "decorated-title")
            .find_element(By.CLASS_NAME, "identifier")
            .text
        )

    @property
    def type(self) -> str:
        return (
            self.element.find_element(By.CLASS_NAME, "decorated-title")
            .find_elements(By.TAG_NAME, "span")[2]
            .text.replace(": ", "")
        )

    @property
    def abstract(self) -> str:
        try:
            return (
                self.element.find_element(By.CLASS_NAME, "abstract")
                .find_element(By.CLASS_NAME, "content")
                .text
            )
        except NoSuchElementException:
            return ""

    @property
    def is_desprecated(self) -> bool:
        return False


@dataclass
class ColorSection:
    element: WebElement

    @property
    def title(self) -> str:
        return (
            self.element.find_element(By.CLASS_NAME, "section-title")
            .find_element(By.TAG_NAME, "a")
            .text
        )

    @property
    def colors(self) -> list[Color]:
        elements = self.element.find_elements(By.CLASS_NAME, "topic")
        return [Color(element) for element in elements]


@dataclass
class DocumentPage:
    driver: ChromeDriver
    url = "https://developer.apple.com/documentation/appkit/nscolor/ui_element_colors"

    def go_toppage(self) -> None:
        self.driver.get(self.url)
        # タイトルの表示を待つ
        WebDriverWait(self.driver, 5).until(
            expected_conditions.presence_of_element_located(
                (By.CLASS_NAME, "topictitle")
            )
        )

    @property
    def sections(self) -> list[ColorSection]:
        elements = (
            WebDriverWait(self.driver, 5)
            .until(
                # Topics以下
                expected_conditions.presence_of_element_located(
                    (By.CLASS_NAME, "contenttable")
                )
            )
            .find_elements(By.CLASS_NAME, "contenttable-section")
        )

        return [ColorSection(element) for element in elements]

    def func(self) -> None:
        sections = self.sections
        for section in sections:
            print(f"★{section.title}")
            for color in section.colors:
                print(f"★{color.title}")
                print(color.type)
                print(color.abstract)
                print("\n")


def main() -> None:
    document_page = DocumentPage(ChromeDriverManager.launch())
    document_page.go_toppage()
    document_page.func()

    print("stop")


if __name__ == "__main__":
    main()
