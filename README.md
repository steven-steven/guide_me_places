# Guide Me Places
Explore a curation of tourist spots in the Indonesia archipelago

## Development instruction
- Run `bin/rails db:migrate`
- Run `overmind start -f Procfile.dev` or `bin/dev`
- Run `overmind connect web` or `bundle exec rdbg -a` in a separate terminal for debugging
- `EDITOR=vim rails credentials:edit` / `EDITOR=vim rails credentials:edit --environment production`

## How contents are curated
- Place
    1. Enter location, emojis, iframes in [Excel Sheet](https://docs.google.com/spreadsheets/d/1AXS8XtibYs0Ou-CgtrxaiJ87u464EdL7S0dCRPyhvv0/edit#gid=0)
    2. Update new locations from excel to airtable
    3. `rails data:fetch_and_store_places` to batch refresh articles to DB

- Article
    1. Save url to [airtable base](https://airtable.com/appWX3ubnFwIVgs2t/shrWiOeH9DBF4Ftl4) (with Shortcuts automation)
    2. In Airtable, tag with places
    4. Scrape the url to enrich the records (ie. `rails data:enhance_articles`)
    5. `rails data:fetch_and_store_articles` to batch refresh articles to DB
