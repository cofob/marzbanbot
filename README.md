# MarzbanBot

Marzbanbot is a Telegram bot that creates new configs in Marzban. The bot can be run using a Docker Compose file, which is located in the root folder of the repository.

## Prerequisites

Before running bot, you need to have Docker and Docker Compose installed on your system. If you don't have them installed, please follow the instructions at <https://docs.docker.com/get-docker/> and <https://docs.docker.com/compose/install/> to install them.

## Getting Started

1. Clone the repository using the following command:

  ```bash
  git clone https://github.com/cofob/marzbanbot.git
  ```

2. Go to the root folder of the repository:

  ```bash
  cd marzbanbot
  ```

3. Open the docker-compose.yml file in a text editor.
4. Replace the value of the TOKEN environment variable with your Telegram bot token. You can get a bot token by talking to the [BotFather](https://t.me/BotFather).
5. Replace other environment variables.
6. Save and close the docker-compose.yml file.
7. Run the following command to start bot:

  ```bash
  docker-compose up -d
  ```

  This will start the Docker container in detached mode, which means it will run in the background.

7. You can now interact with app by sending messages to your Telegram bot.

## Conclusion

Congratulations! You have successfully set up bot. If you have any questions or feedback, please feel free to reach out to the developers at [issues](https://github.com/cofob/marzban/issues).
