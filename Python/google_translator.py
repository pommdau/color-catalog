from googletrans import Translator
from enum import Enum

_translator = Translator()


def translate(text: str, dst: str, src="en") -> str:
    # return "日本語訳が入るよ"  # debug
    if len(text) == 0:
        return ""
    return _translator.translate(text, src=src, dest=dst).text


class LanguageForTranslate(Enum):
    ENGLISH = "en"
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


def main():
    for language in LanguageForTranslate:
        print(f"{language.name}, {language.value}")


if __name__ == "__main__":
    main()
