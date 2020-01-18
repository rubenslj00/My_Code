CREATE TABLE flipr.sqitch.mytable (
    nickname    TEXT         NOT NULL REFERENCES flipr.users(nickname),
    name        TEXT         NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    to_date     TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    to_timestamp  TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
