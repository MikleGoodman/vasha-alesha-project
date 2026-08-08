# Настройка Amadeus API

## Что такое Amadeus

Amadeus — глобальная система бронирования (GDS). Дает доступ к:
- Поиску отелей
- Авиабилетам
- Трансферам

## Регистрация

1. Перейди на https://developers.amadeus.com
2. Зарегистрируй аккаунт
3. Создай приложение → получишь API Key и API Secret

## Использование в проекте

Ключи храни в `.env` или переменных окружения:
```
AMADEUS_API_KEY=your_key
AMADEUS_API_SECRET=your_secret
```

## Основные endpoint'ы

- `GET /v2/shopping/hotel-offers` — поиск отелей
- `GET /v1/shopping/flight-destinations` — вдохновение (куда можно улететь)
- `GET /v2/reference-data/locations` — поиск локаций

## Ограничения бесплатного тарифа

- 2000 запросов/месяц
- Тестовые данные
- Для продакшена — нужен платный тариф

## Пример запроса (Python)

```python
from amadeus import Client

amadeus = Client(
    client_id='YOUR_KEY',
    client_secret='YOUR_SECRET'
)

response = amadeus.shopping.hotel_offers.get(
    cityCode='DXB',
    checkInDate='2026-09-30',
    checkOutDate='2026-10-09',
    adults=2,
    children=2
)
print(response.data)
```
