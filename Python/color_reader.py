import time
from google_translator import LanguageForTranslate, translate
from selenium import webdriver
from bs4 import BeautifulSoup
from dataclasses import dataclass, field
from collections import OrderedDict
from typing import Any, Optional
import json


@dataclass
class ColorDescription():
    description: str
    language: str  # e.g. en, ja

    def convert_to_json_dict(self) -> OrderedDict[str, str]:
        json_dict: OrderedDict[str, str] = OrderedDict()
        json_dict["description"] = self.description
        json_dict["language"] = self.language

        return json_dict


@dataclass
class Color():
    title: str
    color_descriptions: [ColorDescription]
    type: str  # "NSColor", "[NSColor]"
    is_deprecated: bool
    is_beta: bool
    link: str = ""

    def convert_to_json_dict(self) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, str] = OrderedDict()
        json_dict["title"] = self.title
        json_dict["descriptions"] = [description.convert_to_json_dict() for description in self.color_descriptions]
        json_dict["type"] = self.type
        json_dict["is_deprecated"] = self.is_deprecated
        json_dict["is_beta"] = self.is_beta
        json_dict["link"] = self.link

        return json_dict


@dataclass
class ColorSection():
    title: str
    colors: list[Color]

    def convert_to_json_dict(self) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["title"] = self.title
        json_dict["colors"] = [color.convert_to_json_dict() for color in self.colors]

        return json_dict


@dataclass
class ColorReader():
    title: str
    url: str
    color_sections: list[ColorSection] = field(default_factory=list)

    # 途中経過の構造の保存用
    main_element: Optional[Any] = None
    topic_element: Optional[Any] = None
    color_sections_element: Optional[Any] = None

    def _load_main_element(self, soup: BeautifulSoup):
        # bs4のクラスにはelementと命名しておく
        # メインコンテンツ(サイドバーのコンテンツを拾わないように)
        self.main_element = soup.find("main", class_="main")

    def _load_topic_element(self):
        # Topics
        self.topics_element = self.main_element.findAll("section", class_="contenttable")[0]  # [1]はSee Also
        # print(topics_element.find("h2", class_="title").text)

    def _load_color_sections_element(self):
        # Topicsの中のコンテンツ
        # [Label Colors, Text Colors, etc...]
        self.color_sections_element = self.topics_element.findAll("div", class_="contenttable-section")

    def _load_colors_element(self, color_section_element: Any) -> Any:
        return color_section_element.find("div", class_="section-content").findAll("div", class_=["link-block", "topic"])

    def _create_color_with_color_element(self, color_element: Any) -> Color:
        # 各Color: e.g. class var labelColor: NSColor
        color_title = color_element.find("span", class_="identifier").text
        color_abstract_element = color_element.find("div", class_="abstract")
        color_description = ""
        if color_abstract_element is not None:
            color_description = color_abstract_element.find("div", class_="content") .text

        is_deprecated_element = color_element.find("span", class_="badge-deprecated")
        is_deprecated = True if is_deprecated_element is not None else False
        is_beta_element = color_element.find("span", class_="badge-beta")
        is_beta = True if is_beta_element is not None else False
        
        color_type = [c.text.replace(": ", "") for c in color_element.findAll("span", class_="decorator") if ":" in c.text][0]
        color_link = color_element.find("a", class_="link").get("href")

        return Color(title=color_title,
                     color_descriptions=[
                         ColorDescription(description=color_description, language="en"),
                     ],
                     type=color_type,
                     is_deprecated=is_deprecated,
                     is_beta=is_beta,
                     link=self._create_link(self.url, color_link)
                     )

    def load_url(self):
        driver = webdriver.Chrome()
        driver.get(self.url)
        # n秒間待機する
        time.sleep(3)
        soup = BeautifulSoup(driver.page_source, "html.parser")

        self._load_main_element(soup)
        self._load_topic_element()
        self._load_color_sections_element()
        
        found_color_sections: list[ColorSection] = []
        for color_section_element in self.color_sections_element:
            # 各Section: e.g. Label Colors
            section_title: str = color_section_element.find("div", class_="section-title").text
            found_colors: list[Color] = []
            colors_element = self._load_colors_element(color_section_element)
            for color_element in colors_element:
                found_colors.append(self._create_color_with_color_element(color_element))
            
            found_color_sections.append(
                ColorSection(title=section_title, colors=found_colors)
            )
        
        driver.quit()
        self.color_sections = found_color_sections

    def _create_link(self, url: str, relative_path: str) -> str:
        from urllib.parse import urlparse
        parsed_url = urlparse(url)
        return parsed_url.scheme + "://" + parsed_url.netloc + relative_path

    def _convert_to_json_dict(self) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["title"] = self.title
        json_dict["sections"] = [color_section.convert_to_json_dict() for color_section in self.color_sections]

        return json_dict

    def translate_description(self):
        for color_section in self.color_sections:
            for color in color_section.colors:
                translation_en: ColorDescription = [description for description in color.color_descriptions if description.language == "en"][0]
                color.color_descriptions = [translation_en]
                for language in LanguageForTranslate:
                    if language == LanguageForTranslate.ENGLISH:
                        continue
                    language_value = language.value  # "en" "ja"
                    color.color_descriptions.append(
                        ColorDescription(translate(translation_en.description, language_value), 
                                         language_value)
                    )

    def export_json(self):
        with open(f"result/{self.title}.json", "w") as f:
            json.dump(self._convert_to_json_dict(), f, indent=4, ensure_ascii=False)
    