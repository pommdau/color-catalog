import contextlib
import shutil
from pathlib import Path

from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.chrome.webdriver import WebDriver as ChromeDriver

# from src.scraping.utils.path import get_project_dir
from utils.path import get_project_dir

"""
ChromeDriverの管理クラス
"""


class ChromeDriverManager:
    @classmethod
    def _get_cookie_dir_path(cls) -> str:
        """
        Cookieを保存するディレクトリのパス
        """
        return f"{get_project_dir()}/env/webdriver_cookie/chrome"

    @classmethod
    def _create_driver(cls, use_cookie: bool = False) -> ChromeDriver:
        options = ChromeOptions()

        # エラーメッセージを消すための設定
        options.add_experimental_option(
            "excludeSwitches",
            ["enable-automation", "enable-logging"],
        )

        if use_cookie:
            cache_dir = cls._get_cookie_dir_path()
            Path(cache_dir).mkdir(parents=True, exist_ok=True)
            options.add_argument(f"--user-data-dir={cache_dir}")
        return ChromeDriver(options=options)

    @classmethod
    def launch(cls, use_cookie: bool = False) -> ChromeDriver:
        driver = cls._create_driver(use_cookie=use_cookie)
        # 初期設定
        driver.set_window_position(0, 0)
        driver.maximize_window()
        return driver

    @classmethod
    def delete_cookie(cls) -> None:
        with contextlib.suppress(FileNotFoundError):
            shutil.rmtree(cls._get_cookie_dir_path)


if __name__ == "__main__":
    driver = ChromeDriverManager.launch()
    print("stop")
