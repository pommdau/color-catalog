from collections import OrderedDict
from typing import Any

from document_page import Color, ColorAbstract, ColorSection, DocumentPage


class JsonManager:
    @classmethod
    def create_json_with_page(
        cls, page: DocumentPage
    ) -> OrderedDict[str, str]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["title"] = page.title
        json_dict["sections"] = [
            JsonManager._create_json_with_section(section)
            for section in page.sections
        ]
        return json_dict

    @classmethod
    def _create_json_with_section(
        cls, section: ColorSection
    ) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["title"] = section.title
        json_dict["colors"] = [
            JsonManager._create_json_with_color(color)
            for color in section.colors
        ]
        return json_dict

    @classmethod
    def _create_json_with_color(cls, color: Color) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["title"] = color.title
        json_dict["type"] = color.type
        json_dict["abstracts"] = [
            JsonManager._create_json_with_color_abstract(color.abstract)
        ]
        json_dict["is_desprecated"] = color.is_desprecated
        json_dict["link"] = color.link
        return json_dict

    @classmethod
    def _create_json_with_color_abstract(
        cls, abstract: ColorAbstract
    ) -> OrderedDict[str, Any]:
        json_dict: OrderedDict[str, Any] = OrderedDict()
        json_dict["abstract"] = abstract.text
        json_dict["language"] = abstract.language
        return json_dict
