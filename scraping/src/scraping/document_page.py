from collections import OrderedDict
from dataclasses import dataclass

from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.chrome.webdriver import WebDriver as ChromeDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.ui import WebDriverWait


@dataclass
class Color:
    title: str
    type: str
    abstracts: OrderedDict[str, str]
    is_desprecated: bool
    is_beta: bool
    link: str

    def __init__(self, element: WebElement) -> None:
        self.title = (
            element.find_element(By.CLASS_NAME, "decorated-title").find_element(By.CLASS_NAME, "identifier").text
        )

        self.type = (
            element.find_element(By.CLASS_NAME, "decorated-title")
            .find_elements(By.TAG_NAME, "span")[2]
            .text.replace(": ", "")
        )

        try:
            abstract_text = element.find_element(By.CLASS_NAME, "abstract").find_element(By.CLASS_NAME, "content").text
        except NoSuchElementException:
            abstract_text = ""
        self.abstracts = OrderedDict()
        self.abstracts["en"] = abstract_text

        try:
            element.find_element(By.CLASS_NAME, "badge-deprecated")
        except NoSuchElementException:
            self.is_desprecated = False
        else:
            self.is_desprecated = True

        self.is_beta = False  # 未実装

        link = element.find_element(By.TAG_NAME, "a").get_attribute("href")
        if link is None:
            link = ""
        self.link = link


@dataclass
class ColorSection:
    title: str
    colors: list[Color]

    def __init__(self, element: WebElement) -> None:
        self.title = element.find_element(By.CLASS_NAME, "section-title").find_element(By.TAG_NAME, "a").text

        color_elements = element.find_elements(By.CLASS_NAME, "topic")
        self.colors = [Color(element=element) for element in color_elements]


@dataclass
class DocumentPage:
    title: str
    sections: list[ColorSection]

    def __init__(self, element: WebElement) -> None:
        self.title = (
            element.find_element(By.CLASS_NAME, "topictitle")
            .find_element(By.CLASS_NAME, "title")
            .find_element(By.TAG_NAME, "span")
            .text
        )

        section_elements = element.find_element(By.CLASS_NAME, "contenttable").find_elements(
            By.CLASS_NAME, "contenttable-section"
        )
        self.sections = [ColorSection(element) for element in section_elements]


@dataclass
class DocumentPageReader:
    driver: ChromeDriver
    url: str

    def _go_toppage(self) -> None:
        self.driver.get(self.url)
        # タイトルの表示を待つ
        WebDriverWait(self.driver, 5).until(
            expected_conditions.presence_of_element_located((By.CLASS_NAME, "topictitle"))
        )

    def load_page(self) -> DocumentPage:
        self._go_toppage()
        return DocumentPage(element=self.driver.find_element(By.TAG_NAME, "body"))


def main() -> None:
    print("hello, python!")


if __name__ == "__main__":
    main()
