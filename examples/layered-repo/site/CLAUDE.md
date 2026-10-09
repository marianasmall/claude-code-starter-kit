# site/ — the website

## Run it
- `npm install` once, then `npm run dev` and open the local URL it prints.
- `npm run build` must pass before a pull request. It also checks for broken internal links.

## Conventions that explain the code
- Every page has a one-sentence `description` in its front matter. Search results and link previews use it; a missing one shows the first line of the page instead.
- Images go in `site/public/img/` and every image has alt text written for someone who can't see it ("Volunteers setting up tables in the park", not "image1").
- Event pages are generated from `site/content/events/*.md`. Edit the Markdown, not the generated HTML in `dist/`, which is overwritten on every build.
- Event times follow the rule in `.claude/rules/event-times.md`. It loads on its own when you open an event file.

## Traps
- The map embed breaks if a venue address contains an ampersand. Write "and".
