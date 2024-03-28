import json
from enum import Enum

from googletrans import Translator

_translator = Translator()


def translate(text: str, dest_lang: str, src_lang: str = "en") -> str:
    return text  # debug
    if len(text) == 0:
        return ""
    try:
        result = _translator.translate(text, src=src_lang, dest=dest_lang)
        return result.text
    except:
        return "(error)"


class DefinedLanguage(Enum):
    # ENGLISH = "en"
    JAPANESE = "ja"
    # SIMPLIFIED_CHINESE = "zh-CN"
    # TRADITIONAL_CHINESE = "zh-TW"
    # KOREAN = "ko"
    # FRENCH = "fr"
    # GERMAN = "de"
    # ITALIAN = "it"
    # RUSSIAN = "ru"
    # SPANISH = "es"
    # PORTUGUESE = "pt"
    # INDONESIAN = "id"
    # DUTCH = "nl"
    # POLISH = "pl"
    # DANISH = "da"
    # FINNISH = "fi"


def main() -> None:
    # for language in DefinedLanguage:
    #     print(f"{language.name}, {language.value}")
    #     print(
    #         translate(
    #             "Returns the color object specified by the given control tint.",
    #             language.value,
    #         )
    #     )

    path = "/Users/ikeh/Programming/Swift/color-catalog/scraping/result/Standard Colors.json"  # noqa: E501
    with open(path, "r") as file:
        json_dict = json.load(file)

        for section_index, _ in enumerate(json_dict["sections"]):
            for color_index, color in enumerate(
                json_dict["sections"][section_index]["colors"]
            ):
                abstract_en = [
                    abstract["text"]
                    for abstract in color["abstracts"]
                    if abstract["language"] == "en"
                ][0]

                json_dict["sections"][section_index]["colors"][color_index][
                    "abstracts"
                ]
                print("stop")

        print(json_dict)


if __name__ == "__main__":
    main()
