INSERT INTO providers (code, name)
    VALUES
        ('ya','yandex'),
        ('vk','Вконтакте')
ON CONFLICT DO NOTHING;
