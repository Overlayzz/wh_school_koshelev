## **Функция `errmessage`**
* Используется для вывода информации об ошибках при использовании в других функциях

Пример использования функции:
```sql
RETURN public.errmessage('dictionary.position_upd.duplicate',
                         'Такая запись уже существует!',
                         '');
```

Результат выполнения функции:
```json
{
  "errors": [
    {
      "error": "dictionary.position_upd.duplicate",
      "detail": "",
      "message": "Такая запись уже существует!"
    }
  ]
}
```