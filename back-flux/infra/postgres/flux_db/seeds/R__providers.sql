INSERT INTO providers (code, name)
    VALUES
        ('ya','yandex'),
        ('vk','Вконтакте'),
        ('local', 'Flux')
ON CONFLICT DO NOTHING;
