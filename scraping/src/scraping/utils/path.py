from pathlib import Path


def get_project_dir() -> str:
    """
    プロジェクトのルートフォルダ(mf_ui_test)までのパスを取得
    e.g. "/Users/ikeh/Programming/Swift/color-catalog/scraping/src/scraping"
    """

    path = __file__
    while True:
        if path.endswith("color-catalog"):
            # ルートディレクトリに到達したら終了
            break
        path = str(Path(path).parent)

    return path + "/scraping"


if __name__ == "__main__":
    print(get_project_dir())
