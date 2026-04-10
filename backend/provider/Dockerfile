FROM python:3.13-slim-bookworm

ARG DEVELOPMENT=0

# コンテナ内に.venvを作らないようにする環境変数
ENV UV_CACHE_DIR=/root/.cache/uv
ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT='/usr/local/'
ENV UV_SYSTEM_PYTHON=1

WORKDIR /app

# バージョンを指定してuvをコピー
COPY --from=ghcr.io/astral-sh/uv:0.11.2 /uv /uvx /bin/

ADD ./provider /app

RUN --mount=type=cache,target=${UV_CACHE_DIR} \
    --mount=type=bind,source=provider/pyproject.toml,target=/src/pyproject.toml \
    --mount=type=bind,source=provider/uv.lock,target=/src/uv.lock \
    # ローカル環境は全てのパッケージをインストール
    if [ $DEVELOPMENT = 1 ]; then \
        uv export --frozen --format requirements-txt > requirements.txt && \
        uv pip install -r requirements.txt; \

    # ローカルでない環境では開発用パッケージをインストールしない(クラウドにアップロードする場合など)
    else \
        uv export --frozen --no-dev --format requirements-txt > requirements.txt && \
        uv pip install -r requirements.txt; \
    fi

CMD ["uvicorn", "main:app", "--reload", "--host=0.0.0.0", "--port=8000"]
