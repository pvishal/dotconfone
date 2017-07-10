import logging
import logging.handlers

logger = logging.getLogger()
LOG_FORMATTER = logging.Formatter(
    "%(asctime)s - %(name)s - %(levelname)s - " +
    "%(lineno)s - %(funcName)s - " +
    "%(message)s")

def setup_logging():
    file_log_handler = logging.handlers.RotatingFileHandler(
        __name__ + ".log",
        maxBytes = 1000000,
        backupCount = 5)
    console_log_handler = logging.StreamHandler()
    logger = logging.getLogger()
    logger.addHandler(file_log_handler)
    logger.addHandler(console_log_handler)
    logger.setLevel(logging.DEBUG)
    for handler in logging.root.handlers:
        handler.setFormatter(fmt=LOG_FORMATTER)


def main():
    setup_logging()
    logger.debug("debug")
    logger.info("info")
    logger.error("error")
    print("Hello World")

if __name__ == '__main__':
    main()

