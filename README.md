# Group Notes

Jedná se o responzivní webovou aplikaci, která umožňuje uživatelům vytvářet vlastní poznámky. Každá poznámka obsahuje nadpis, popis a zvolenou barvu. Uživatel může své poznámky upravovat nebo je zcela odstranit. Aplikace nabízí možnost registrace a přihlášení, které uživatelům zpřístupňují funkce pro vytváření a správu jejich poznámek.

Původním záměrem aplikace bylo sdílení krátkých denních zápisků mezi blízkými lidmi s cílem usnadnit každodenní organizaci úkolů prostřednictvím To-Do listu. V aktuální demo verzi (viz obrázek níže) však mohou uživatelé vytvářet poznámky pouze pro vlastní potřebu. Funkce sdílení poznámek a další rozvoj aplikace jsou momentálně ve fázi vývoje.

## Použité technologie

- **Full-stack framework:** Ruby on Rails  
- **Databáze:** Supabase (využívá PostgreSQL)  
- **Dynamické UI:** Hotwire  
- **Styling:** Tailwind CSS

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
