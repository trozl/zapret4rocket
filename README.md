[🇷🇺 Русская версия](#русская-версия) | [🇬🇧 English version](#english-version)

<a id="русская-версия"></a>
# Zapret4Rocket

## Оглавление
1. [Установка и обновление](#установка-и-обновление)
2. [Быстрое обновление конфига](#быстрое-обновление-конфига)
3. [Требования и зависимости](#требования-и-зависимости)
4. [Поддержка](#поддержка)
5. [Changelog](#changelog-русская-версия)

<a id="установка-и-обновление"></a>
### 🔧 Установка и обновление
Устанавливает последнюю версию zapret с актуальными рабочими стратегиями обхода блокировок. Скрипт работает на:
- VPS (Ubuntu 22/24, Debian 12, проверено на rocketcloud.ru)
- OpenWRT/Keenetic с Entware (KN-3811)

**Основная команда** (копируйте и вставляйте в SSH):
```bash
curl -O https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/z4r.sh && bash z4r.sh && rm z4r.sh
```

**После запуска:**
1. На все вопросы нажимайте `Enter` (если не требуется дополнительных действий)
2. Для активации подбора стратегий запустите скрипт повторно (если есть проблемы с сайтами)

**Фишки:**
- YouTube работает без ограничений
- Доступ к ntc.party, meduza.io и аналогичным ресурсам
- Discord работает через TUN-режим (для поддержки голосовых каналов)
- Instagram доступен только через официальное приложение (IP-бан в РФ)

<a id="быстрое-обновление-конфига"></a>
### ⚡ Быстрое обновление конфига
Если zapret уже установлен и нужно только обновить конфигурационный файл:
```bash
curl -Ls https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default -o /opt/zapret/config && /opt/zapret/init.d/sysv/zapret restart
```

<a id="требования-и-зависимости"></a>
### ⚙️ Требования и зависимости
При отсутствии необходимых утилит выполнить следующие команды

**Для OpenWRT/Keenetic (Entware):**
```bash
opkg update && opkg install curl bash wget-ssl
```

**Для Ubuntu/Debian:**
```bash
apt update && apt install curl bash wget-ssl
```

<a id="поддержка"></a>
### 💬 Поддержка
Чат для вопросов и обсуждения:  
[https://t.me/zee4r/](https://t.me/zee4r/)

---

<a id="changelog-русская-версия"></a>
## 📜 Changelog

Дата        | Изменения
------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
11.08.25    | Git-http больше не скачивается. Используется wget. Это экономит 20Мб места для роутеров без внешней памяти. Но через wget скачивается на 30-60 секунд дольше.
05.08.25    | Изменение способа определениея entware (Keenetic)
03.08.25    | Теперь будет ставиться последняя версия zapret, если юзер не укажет иную. Добавлено определение immortalwrt и asuswrt.
02.08.25    | Zapret 71.2 >> 71.3
29.07.25    | Теперь пользователя спрашивает, какую версию zapret он хочет установить. Enter для стандартной (Вынесена в отдельную переменную в коде). По умолчанию обновил zapret v71.1 >> v71.2
27.07.25    | OpenWRT: Убрана установка unzip (не требуется). Добавлен запрос на пропуск установки git-http и копирования с репозитория папок соответственно (у кого мало места и закинули папки сами)
23.07.25    | Major update. Кучка скриптов заменена на единый. Единый скрипт теперь поддерживает Keenetic Entware. Перевод на русский язык скрипта, шлифовка текста. Лёгкая шлифовка кода, убрано лишнее
03-09.07.25 | Различные багфиксы, правки.
02.07.25    | Добавлены комментарии к стратегиям в config файле. Ничего особого.
26.06.25    | Добавлено много стратегий для googlevideo.com. Для активации стереть около нужной "--skip". Стратегии для UPD(quick) и tcp.
21.06.25v2  | Возвращены старые стратегии googlevideo для фикса зависаний в части случаев.
21.06.25    | Пофикшены статтеры на YouTube (googlevideo.com передан другой стратегии)
20.06.25    | Обновление из-за РКН. Пофикшена работа сайтов за CF. Обновляться полной командой, были добавлены tls файлы фейков в папку fakes.
19.06.25    | Масштабное обновление стратегий. Добавлено скачивание листов и фейков под новые стратегии KDS (ntc.party), убрана задержка 2с. Удалены старые закомментированные строки для ДС.
12.06.25    | Обновление zapret v70.6 >> v71.1. Minor fix (ytimg.com domen), add FILTER_TTL_EXPIRED_ICMP параметр для 71v).
03.05.25    | Добавил в обход домены CDN prnhub и xv-ru для рукодельников ;)
24.04.25    | Обновил стратегии на более лёгкие, универсальные. Старые закомментил в файле, добавив перед номер порта "7". Можно будет возвращать старые стратегии простым редактированием и перезапуском службы. Ну и в конфиг в начале дату вписываю теперь.
12.04.25    | Обновление zapret v70.3 >> v70.6, обновлены стратегии, убран скрипт для Discord (заменен на стратегию)
06.03.25    | Обновление zapret v70 >> v70.3
21.02.25    | Change googlevideo.com strategy. Заменил стратегию для GV, пропали лаги на shorts, при включении некоторых видео и, возможно, иные проблемы!!!
18.02.25    | Iptables as default. (На некоторых хостингах zapret ставил почему-то nftables. C nftables не работает или работает нестабильно, может не всегда, не везде, но зачем, если можно просто юзать iptables на данном этапе.
08.02.25    | Обновление zapret v69.x >> v70. Убрана проверка наличия zip и его скачивание при отсутствии (фикс двойного скачивания так же из-за этого)
19.01.25    | Добавлен вариант установки Marzban помимо 3xui и прочего
17.01.25    | Включена работа с IPv6 по умолчанию. Добавлена возможность также установить wg или 3proxy в начале работы скрипта (ранее был только 3xui)
31.12.24    | Обновление zapret v69.8 >> v69.9v. Добавлено удаление архива после установки
30.12.24    | Команда установки сокращена, скрипт теперь не скачивается на ваш сервер для своего исполнения
29.12.24(3) | Фикс ввода Y при запросе на установку 3x-ui, если ранее был ввод русскими буквами
29.12.24(2) | Изменена стратегия udp quick под VDS хостинг. На рокете также отлично работает. Будем считать универсальной. Добавлена перезагрузка zapret. Повышает стабильность. Хз почему. Но это так.
29.12.24    | Оптимизация под другие хостинги (убран принудительный выбор WAN интерфейса). Добавлена возможность в самом начале скрипта попросить установить 3x-ui панель (просто ввести Y на вопрос)
28.12.24    | Добавлена проверка на наличие архива zapret, дабы избежать повторного скачивания и размножения архивов
26.12.24    | Обновлена стратегия под googlevideo.com



---

<a id="english-version"></a>

## Table of Contents
1. [Installation and Update](#installation-and-update)
2. [Quick Config Update](#quick-config-update)
3. [Requirements and Dependencies](#requirements-and-dependencies)
4. [Support](#support)
5. [Changelog](#changelog-english-version)

<a id="installation-and-update"></a>
### 🔧 Installation and Update
Installs the latest zapret version with current bypass strategies. Compatible with:
- VPS (Ubuntu 22/24, Debian 12, tested on rocketcloud.ru)
- OpenWRT/Keenetic with Entware (KN-3811)

**Main command** (copy/paste to SSH):
```bash
curl -O https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/refs/heads/master/z4r.sh && bash z4r.sh && rm z4r.sh
```

**After launch:**
1. Press `Enter` for all prompts (if no additional actions needed)
2. Run script again to activate strategy selection (if encountering website issues)

**Features:**
- Unrestricted YouTube access
- Access to ntc.party, meduza.io and similar resources
- Discord works via TUN mode (for voice channels)
- Instagram only available via official app (Access in Russia is blocked by IP)

<a id="quick-config-update"></a>
### ⚡ Quick Config Update
If zapret is already installed and only config update is needed:
```bash
curl -Ls https://raw.githubusercontent.com/IndeecFOX/zapret4rocket/master/extra_strats/config.default -o /opt/zapret/config && /opt/zapret/init.d/sysv/zapret restart
```

<a id="requirements-and-dependencies"></a>
### ⚙️ Requirements and Dependencies
If required utilities are missing

**For OpenWRT/Keenetic (Entware):**
```bash
opkg update && opkg install curl bash wget-ssl
```

**For Ubuntu/Debian:**
```bash
apt update && apt install curl bash wget-ssl
```

<a id="support"></a>
### 💬 Support
Discussion chat (It is not guaranteed that you will receive a reply in English, as the chat is Russian-speaking, but you can try):  
[https://t.me/zee4r/](https://t.me/zee4r/)

<a id="changelog-english-version"></a>
## 📜 Changelog
Date        | Changes
------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
11.08.25    | Git-http is no longer downloaded. wget is used instead. Saves ~20MB of space for routers without external storage. However, downloading via wget takes 30-60 seconds longer.
05.08.25    | Changed method of detecting entware (Keenetic)
03.08.25    | The latest version of zapret will now be installed by default unless the user specifies otherwise. Added detection for immortalwrt and asuswrt.
02.08.25    | zapret 71.2 >> 71.3
29.07.25    | The user is now asked which version of zapret to install. Press Enter for the default (moved to a separate variable in the code). Default updated zapret v71.1 >> v71.2
27.07.25    | OpenWRT: Removed installation of unzip (no longer needed). Added prompt to skip installing git-http and copying repository folders (for users with little space who uploaded the folders themselves)
23.07.25    | Major update. Several scripts merged into a single one. Single script now supports Keenetic Entware. Script translated to Russian, text polished. Minor code cleanup, removed unnecessary parts.
03-09.07.25 | Various bug fixes and adjustments.
02.07.25    | Added comments to strategies in the config file. Nothing major.
26.06.25    | Added many strategies for googlevideo.com. To activate, remove the "--skip" near the desired one. Strategies for UDP (quick) and TCP.
21.06.25v2  | Restored old GoogleVideo strategies to fix freezes in some cases.
21.06.25    | Fixed stuttering on YouTube (googlevideo.com assigned to a different strategy)
20.06.25    | Update due to Roskomnadzor. Fixed websites behind CF. Update with full command — tls fake files added to the fakes folder.
19.06.25    | Major update of strategies. Added downloading of lists and fakes for new KDS strategies (ntc.party), removed 2s delay. Deleted old commented lines for Discord.
12.06.25    | zapret update v70.6 >> v71.1. Minor fix (ytimg.com domain), add FILTER_TTL_EXPIRED_ICMP parameter for 71v).
03.05.25    | Added CDN bypass domains prnhub and xv-ru for the true one-handed pros ;)
24.04.25    | Updated strategies to lighter, more universal ones. Old ones commented out in the file with "7" before the port number. Can be restored by simple editing and restarting the service. Also now writes date at the beginning of the config.
12.04.25    | zapret update v70.3 >> v70.6, updated strategies, removed Discord script (replaced with a strategy)
06.03.25    | zapret update v70 >> v70.3
21.02.25    | Changed googlevideo.com strategy. Fixed shorts lags, some video startup issues, and possibly other problems!!!
18.02.25    | iptables as default. (On some hosts zapret was installed with nftables for some reason. With nftables it doesn't work or works unstably — maybe not always or everywhere — but why bother if iptables works fine at this stage.)
08.02.25    | zapret update v69.x >> v70. Removed zip check and download if missing (also fixed double download caused by this)
19.01.25    | Added installation option for Marzban alongside 3xui and others
17.01.25    | Enabled IPv6 by default. Added option to also install wg or 3proxy at the beginning of the script (previously only 3xui)
31.12.24    | zapret update v69.8 >> v69.9v. Added deletion of archive after installation
30.12.24    | Installation command shortened, script no longer downloads to your server for execution
29.12.24(3) | Fixed Y input when installing 3x-ui if previously typed in Russian letters
29.12.24(2) | Changed udp quick strategy for VDS hosting. Works great on Rocket too — will consider universal. Added zapret restart. Increases stability (unknown why, but it does).
29.12.24    | Optimization for other hosts (removed forced WAN interface selection). Added ability at script start to request 3x-ui panel installation (just enter Y when prompted)
28.12.24    | Added check for presence of zapret archive to avoid repeated downloads and duplicate archives
26.12.24    | Updated strategy for googlevideo.com
