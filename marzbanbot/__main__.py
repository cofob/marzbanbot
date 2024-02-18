import asyncio
import logging
from os import getenv, environ
from random import randint

from aiogram import Bot, Dispatcher
from aiogram.enums import ParseMode
from aiogram.filters import CommandStart
from aiogram.types import Message
from aiogram.utils.markdown import code, link
from aiohttp import ClientSession

TOKEN = environ["BOT_TOKEN"]
SECRET = getenv("SECRET", None)
MARZ_USERNAME = environ["MARZ_USERNAME"]
MARZ_PASSWORD = environ["MARZ_PASSWORD"]
MARZ_HOST = environ["MARZ_HOST"]

dp = Dispatcher()


async def register_client(username: str) -> str:
    async with ClientSession() as session:
        async with session.post(
            f"{MARZ_HOST}/api/admin/token",
            data={
                "grant_type": "password",
                "username": MARZ_USERNAME,
                "password": MARZ_PASSWORD,
            },
        ) as response:
            if response.status != 200:
                logging.error(f"Failed to get token: {await response.text()}")
                response.raise_for_status()
            token = (await response.json())["access_token"]

        async with session.post(
            f"{MARZ_HOST}/api/user",
            json={
                "username": username,
                "note": "",
                "proxies": {
                    "vmess": {},
                    "vless": {"flow": ""},
                    "trojan": {},
                    "shadowsocks": {"method": "chacha20-ietf-poly1305"},
                },
                "data_limit": 0,
                "expire": None,
                "data_limit_reset_strategy": "no_reset",
                "status": "active",
                "inbounds": {
                    "vmess": ["VMess TCP", "VMess Websocket"],
                    "vless": ["VLESS TCP REALITY", "VLESS GRPC REALITY"],
                    "trojan": ["Trojan Websocket TLS"],
                    "shadowsocks": ["Shadowsocks TCP"],
                },
            },
            headers={
                "Authorization": f"Bearer {token}",
            },
        ) as response:
            response.raise_for_status()
            data = await response.json()
            logging.info(f"Registered new user: {data['username']}")
            return MARZ_HOST + data["subscription_url"]


@dp.message(CommandStart())
async def command_start_handler(message: Message) -> None:
    if SECRET is not None:
        spl = message.text.split()
        if len(spl) != 2:
            await message.answer(
                f"Provide secret in format: {code('/start secret')}.",
            )
            return
        if spl[1] != SECRET:
            await message.answer("Wrong secret.")
            return
    random_username = f"f{randint(10000000000, 99999999999)}"
    subscription_url = await register_client(random_username)
    await message.answer(f"Your configuration -> {link('Click', subscription_url)}")


async def run_bot() -> None:
    bot = Bot(TOKEN, parse_mode=ParseMode.MARKDOWN)
    await dp.start_polling(bot)


def main() -> None:
    logging.basicConfig(level=logging.INFO)
    asyncio.run(run_bot())


if __name__ == "__main__":
    main()
