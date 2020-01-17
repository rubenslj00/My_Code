USE WAREHOUSE &warehouse;
CREATE TABLE flipr.mytable (
    nickname    TEXT         NOT NULL REFERENCES flipr.users(nickname),
    name        TEXT         NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    to_date     TIMESTAMP_TZ NOT NULL DEFAULT NONE,
    to_timestamp  TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP+5 
);


insert into mytable
  select 'PETER', 'JEFF', '123-456',  to_date('2020-01-16T23:39:20.123'),to_date('2019-12-31T23:39:20.123'), to_timestamp('2018-12-08T23:39:20.123');
  
  
update FLIPR.SQITCH.CHANGES set PROJECT='Marketing1' where SCRIPT_HASH='2e5a587a4d35f3460e622403bbce9d6c3a0e70f0'
