import json
from collections import OrderedDict
from enum import Enum
from glob import glob
from pathlib import Path
from typing import Any

from googletrans import Translator
from utils.path import get_project_dir

_translator = Translator()


def google_translate(text: str, dest_lang: str, src_lang: str = "en") -> str:
    if len(text) == 0:
        return ""
    if dest_lang == "en":
        return text

    try:
        result = _translator.translate(text, src=src_lang, dest=dest_lang)
    except:
        return "(translate error)"
    else:
        return result.text


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


def download_translated_abstracts(path: str) -> None:
    # JSONファイルの読み込み
    json_dict: OrderedDict[str, Any]
    with Path(path).open("r") as file:
        json_dict = json.load(file, object_pairs_hook=OrderedDict)

        for section_index, _ in enumerate(json_dict["sections"]):
            for color_index, color in enumerate(json_dict["sections"][section_index]["colors"]):
                # 各色のabstractの英語訳を取得
                abstract_in_english = color["abstracts"]["en"]
                # 各言語で翻訳
                for language in DefinedLanguage:
                    translated_abstract = google_translate(text=abstract_in_english, dest_lang=language.name)
                    json_dict["sections"][section_index]["colors"][color_index]["abstracts"][language.value] = (
                        translated_abstract
                    )

    # 翻訳した結果をJSONへ反映する
    with Path(path).open("w") as file:
        json.dump(json_dict, file, indent=4, ensure_ascii=False)


def main() -> None:
    files = glob(f"{get_project_dir()}/result/*.json")
    for file in files:
        download_translated_abstracts(path=file)


if __name__ == "__main__":
    main()
