# Group Notes

Jedná se o webovou aplikaci, ve které si uživatel může vytvářet své poznámky. Každá poznámka se skládá z nadpisu, popisu a zvolené barvy. Uživatel může obsah svých poznámek upravovat nebo celou poznámku smazat. Aplikace také poskytuje uživatelům možnost registrace a přihlášení, což jim zpřístupňuje funkce pro správu a vytvoření svých poznámek. Původním záměrem aplikace bylo sdílení krátkých denních zápisků mezi blízkými lidmi, aby se usnadnila každodenní práce s To-Do listem. Autor na jejím dalším rozvoji stále pracuje.

<img width="992" height="386" alt="image" src="https://github.com/user-attachments/assets/4e6bdcd2-90d2-4194-9e40-cc7abe849587" />

# Návod na spuštění aplikace

1. **Zkontrolujte verzi Rails v příkazovém řádku, pokud jste tak ještě neučinili:**

    Aktuální verze Ruby
    ```bash
    ruby -v
    ```

    Instalace nové verze Rails
  	```bash
  	gem install rails
  	```

2. **V příkazovém řádku nakolnujte vytvořenou Rails aplikaci:**

	```bash
	git clone https://github.com/Vlada45/group-notes.git
	```

   kde "group-notes" je název vaší aplikace.

3. **Přejděte do složky group-notes:**

    Změna složky projektu
    ```bash
    cd group-notes
    ```

4. **Nainstalujte potřebné závislosti:**

    ```bash
    bundle install
    yarn install
    ```

5. **Proveďte nastavení databáze:**

    Vytvoření databáze
    ```bash
    bin/rails db:create
    ```
    Provedení migrací
    ```bash
    bin/rails db:migrate
    ```
    Naplnění testovacích dat
    ```bash
    bin/rails db:seed
    ```


6. **Spusťte webový server:**
    
    Spustí Rails server + Tailwind + JS watch
    ```bash
    bin/dev
    ```      
    
    Alternativně spusťte každý proces samostatně
    ```bash
    bin/rails server
    bin/rails tailwindcss:watch
    yarn watch
    ```

    Spusťte s `--help` nebo `-h` pro zobrazení dostupných možností.

7. **Otevřete http://localhost:3000 ve vašem prohlížeči a uvidíte úvodní obrazovku aplikce Group Notes**
