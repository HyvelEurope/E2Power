[![](https://img.shields.io/github/issues-raw/l33trs/e2power.svg)]()
[![](https://img.shields.io/github/release/l33trs/e2power.svg)]()
[![](https://img.shields.io/github/license/l33trs/e2power.svg)]()

# E2Power
E2Power или E2P - это дополнение для Wiremod, а точнее для E2 добавляющее множество полезных (и не очень) команд.

## Отличия от оригинальной версии

+ Для функций entity:setKeyValue(string,...) и entity:setFire(string,string,number) был введён чёрный список. Админы игнорируют чёрный список.
+ Были пофикшены функции entity:removeOnDelete(entity) и entity:setUndoName(string) [array:setUndoName(string)]. Теперь они не могут удалять игроков.
+ Функция addOps(number) больше не приводит к падению сервера.
+ Функция entity:giveWeapon(string) больше не спавнит посторонние энтити.
+ Пофикшена функция entity:pp(string,string)
+ Больше нельзя заспавнить спрайт/квад/бим с текстурой, начинающейся на "pp".
+ Пароль теперь генерируется 12и-значным (буквенным).
+ Убран глобальный бан-лист
+ Убраны функции e2pSetPassword(string), entity:e2pRemoveAccess() и entity:e2pGiveAccess().
+ Исправлены функции типа setHealth. (owner():heal(0/0) owner():setHealth(0/0))
+ С помощью функции shootTo больше нельзя спавнить запрещённые эффекты.
+ Добавлен вайтлист. Игроки, вписанные в него автоматически получают доступ.
+ Пофикшен баг с playerSetBoneAng.
+ Добавлена функция entity:hasGodMode.
+ Пофикшена функция setParent (больше не удаляет игроков)
+ Обычные игроки не могут менять содержание Expression чипa администрации.
+ Кое-как пофикшен баг с soundURLload, при котором не возпроизводились длинные ссылки.
+ Возпроизводить музыку на всю карту (используя soundURLload) могут игроки, имеющие доступ к E2Power.
+ Супер-админы заменены на админов.
+ Сделан перевод панели E2Power в меню Q.
+ Удалена нерабочая команда и кнопка для нее (e2power_set_pass_free).
+ Добавлены функции e:setWeaponColor(v), e:setPlayerColor(v), e:getWeaponColor(), e:getPlayerColor().

## Авторы

**[G-moder]FertNoN**

+ [Steam](https://steamcommunity.com/id/FertNoN)
+ [Группа Steam](https://steamcommunity.com/groups/E2Power)

**Tengz**

+ [Steam](http://steamcommunity.com/id/Tengz/)

**Zimon4eR**
+ [Steam] (http://steamcommunity.com/id/Zimon4eR/)
