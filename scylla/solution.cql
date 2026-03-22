CREATE KEYSPACE IF NOT EXISTS messenger
    WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE messenger;


CREATE TABLE IF NOT EXISTS posts_by_user
(
    user_id    int,
    created_at timestamp,
    post_id    int,
    username   text,
    topic_id   int,
    -- Я хотел сделать всё с помощью одной таблицы, но потом понял, что не получится и создал вторую.
    -- В первой таблице поле topic_id просто забыл убрать
    content    text,
    PRIMARY KEY (user_id, created_at, post_id)
-- Для уникальности. Я подумал, может произойти такой случай, что user создаст несколько постов
-- одновременно, из-за этого добавил в PRIMARY KEY post_id . Опять же, не знаю, может такое
-- произойти или нет, но решил перестраховаться
) WITH CLUSTERING ORDER BY (created_at DESC, post_id ASC);


CREATE TABLE IF NOT EXISTS posts_by_topic
(
    topic_id   int,
    created_at timestamp,
    post_id    int,
    user_id    int,
    username   text,
    PRIMARY KEY (topic_id, created_at, post_id)
--Такой же случай, как и выше

) WITH CLUSTERING ORDER BY (created_at DESC, post_id ASC);


-- Запрос, который бы доставал посты заданного пользователя, упорядоченные по времени создания поста (сначала новые).
-- Должен возвращать: post_id, content, дату создания поста.
SELECT post_id, content, created_at FROM posts_by_user WHERE user_id = 2;

-- Запрос, который бы доставал последний пост заданного пользователя.
-- Должен возвращать: post_id, content, дату создания поста, username.
SELECT post_id, content, created_at, username FROM posts_by_user WHERE user_id = 2 LIMIT 1;

-- Запрос, который бы доставал посты заданного пользователя после заданной даты.
-- Должен возвращать: post_id, content, дату создания поста.
SELECT post_id, content, created_at FROM posts_by_user
WHERE user_id = 2 AND created_at > '2024-01-17 18:46:00';

-- Запрос, который бы доставал пользователей, сделавших пост в заданный день по заданной теме, упорядоченные по времени (сначала новые).
-- Должен возвращать: user_id, username, post_id, время создания поста.
SELECT user_id, username, post_id, created_at
FROM posts_by_topic
WHERE topic_id = 4
  AND created_at >= '2024-01-17 00:00:00'
  AND created_at <= '2024-01-17 23:59:59';