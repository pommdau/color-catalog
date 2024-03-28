from dataclasses import dataclass

from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.chrome.webdriver import WebDriver as ChromeDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait


@dataclass
class ColorAbstract:
    text: str
    language: str  # e.g. "en"


@dataclass
class Color:
    title: str
    type: str
    abstracts: list[ColorAbstract]
    is_desprecated: bool
    is_beta: bool
    link: str

    def __init__(self, element: WebElement) -> None:
        self.title = (
            element.find_element(By.CLASS_NAME, "decorated-title")
            .find_element(By.CLASS_NAME, "identifier")
            .text
        )

        self.type = (
            element.find_element(By.CLASS_NAME, "decorated-title")
            .find_elements(By.TAG_NAME, "span")[2]
            .text.replace(": ", "")
        )

        try:
            abstract_text = (
                element.find_element(By.CLASS_NAME, "abstract")
                .find_element(By.CLASS_NAME, "content")
                .text
            )
        except NoSuchElementException:
            abstract_text = ""
        self.abstracts = [ColorAbstract(text=abstract_text, language="en")]

        try:
            element.find_element(By.CLASS_NAME, "badge-deprecated")
        except NoSuchElementException:
            self.is_desprecated = False
        self.is_desprecated = True
        self.is_beta = False  # 未実装

        link = element.find_element(By.TAG_NAME, "a").get_attribute("href")
        if link is None:
            link = ""
        self.link = link


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
        return [Color(element=element) for element in elements]


@dataclass
class DocumentPage:
    driver: ChromeDriver
    url: str

    def go_toppage(self) -> None:
        self.driver.get(self.url)
        # タイトルの表示を待つ
        WebDriverWait(self.driver, 5).until(
            expected_conditions.presence_of_element_located(
                (By.CLASS_NAME, "topictitle")
            )
        )

    @property
    def title(self) -> str:
        return (
            WebDriverWait(self.driver, 5)
            .until(
                expected_conditions.presence_of_element_located(
                    (By.CLASS_NAME, "topictitle")
                )
            )
            .find_element(By.CLASS_NAME, "title")
            .find_element(By.TAG_NAME, "span")
            .text
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


def main() -> None:
    print("hello, python!")


if __name__ == "__main__":
    main()
