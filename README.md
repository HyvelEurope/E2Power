[![](https://img.shields.io/github/issues-raw/VelaEurope/e2power.svg)]()
[![](https://img.shields.io/github/release/VelaEurope/e2power.svg)]()
[![](https://img.shields.io/github/license/VelaEurope/e2power.svg)]()

# E2Power
E2Power или E2P - это дополнение для Wiremod, а точнее для E2 добавляющее множество полезных (и не очень) команд.

## Изменения

+ Для функций entity:setKeyValue() и entity:setFire() был введён чёрный список. Супер Админы игнорируют чёрный список.
+ Были пофикшены функции entity:removeOnDelete(entity) и entity:setUndoName(string), array:setUndoName(string). Теперь они не могут удалять игроков.
+ Функция addOps(number) больше не приводит к падению сервера.
+ Функция entity:giveWeapon(string) больше не спавнит посторонние энтити.
+ Пофикшена функция entity:pp(string,string).
+ Больше нельзя заспавнить спрайт/квад/бим с текстурой, начинающейся на "pp".
+ Пароль теперь генерируется 12и-значным (буквенным).
+ Убран глобальный бан-лист.
+ Убраны функции e2pSetPassword(string), entity:e2pRemoveAccess() и entity:e2pGiveAccess().
+ Исправлены функции типа setHealth и heal.
+ С помощью функции shootTo больше нельзя спавнить запрещённые эффекты.
+ Добавлен вайтлист. Игроки, вписанные в него автоматически получают доступ.
+ Пофикшен баг с playerSetBoneAng.
+ Добавлена функция entity:hasGodMode.
+ Пофикшена функция setParent (больше не удаляет игроков).
+ Обычные игроки не могут менять содержание E2 чипa администрации.
+ Пофикшен баг с soundURLload, при котором не возпроизводились длинные ссылки.
+ Возпроизводить музыку на всю карту (используя soundURLload) могут игроки, имеющие доступ к E2Power.
+ Сделан перевод панели E2Power в меню Q.
+ Удалена нерабочая команда и кнопка для нее (e2power_set_pass_free).
+ Добавлены функции entity:setWeaponColor(v), entity:setPlayerColor(v), entity:getWeaponColor(), entity:getPlayerColor().
+ Изменен лимит размера партиклей с 3000 до 800.
+ Пофикшены некоторые функции в Tool.lua, diff.lua и health.lua.
+ Проверка на админа при спавне entity. (Запрещает смертным спавн редакторов скайбокса и прочее)

## Авторы

**[G-moder]FertNoN**

+ [Steam](https://steamcommunity.com/id/FertNoN)
+ [Группа Steam](https://steamcommunity.com/groups/E2Power)

**Tengz**

+ [Steam](http://steamcommunity.com/id/Tengz/)

**Zimon4eR**
+ [Steam](http://steamcommunity.com/id/Zimon4eR/)
