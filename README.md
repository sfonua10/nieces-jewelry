# Viola & Tirana's Jewelry Shop

A tiny static website for two sisters who make jewelry and take payment via Venmo.

No framework, no build step, no Node required. Just three files: `index.html`, `style.css`, `main.js`.

---

## First things to do after getting this site

Before sharing the site with anyone, fill in the real info. Everything to change is marked with `TODO:` in the HTML comments.

### 1. Venmo handles

Open `index.html` and find-and-replace:

- `viola-venmo-handle` → Viola's real Venmo username (without the `@`, e.g. `viola-smith`)
- `tirana-venmo-handle` → Tirana's real Venmo username

Each placeholder appears in several places (one per product + footer). A find-and-replace-all does them all at once.

**To find a Venmo username:** open Venmo → profile → the text under your name that starts with `@` is the username. Leave off the `@` when pasting into the HTML.

### 2. Product info

Each product is a block in `index.html` that looks like this:

```html
<article class="product" data-maker="viola">
  <div class="product-media">
    <img src="images/sunset-hoops.svg" alt="..." loading="lazy" />
  </div>
  <div class="product-body">
    <h3 class="product-name">Sunset hoop earrings</h3>
    <p class="product-byline">
      <span class="maker-tag">by Viola</span>
      <span class="product-price">$22</span>
    </p>
    <a class="pay-link"
       data-venmo="viola-venmo-handle"
       data-amount="22"
       data-note="Sunset hoop earrings · Viola &amp; Tirana"
       target="_blank" rel="noopener">Pay $22 on Venmo</a>
  </div>
</article>
```

To **edit** a product: change the name, price, and the three `data-*` attributes on the pay link (they must match the price shown).

To **add** a product: copy an existing `<article class="product">…</article>` block and change the values.

To **remove** a product: delete the whole block.

To **mark sold out**: add the `sold-out` class — `<article class="product sold-out" data-maker="viola">`.

### 3. Product photos

Replace the `.svg` placeholders in `/images/` with real photos. Any square (1:1) JPG or PNG works, around 800×800px is ideal.

To use a photo called `my-photo.jpg`:

1. Drop it into the `images/` folder.
2. Edit the `<img src="images/...">` line for that product to point at `my-photo.jpg`.

### 4. "Meet the makers" blurbs

Near the bottom of `index.html`, find the two `<p class="maker-blurb">` paragraphs and replace them with something from each niece. Keep each to a sentence or two.

---

## How to preview the site locally

Just double-click `index.html` — it opens in your browser with no setup. The fonts load from Google Fonts over the internet, so you'll need a connection.

(For a closer-to-production preview, you can run any static server. Python:

```sh
cd nieces-jewlery
python3 -m http.server 8000
```

then open http://localhost:8000 — but this is optional.)

---

## How to deploy

### Deploy to Vercel (free)

1. Install the Vercel CLI once: `npm i -g vercel`
2. From this folder, run: `vercel deploy` — answer a few prompts the first time.
3. You'll get a preview URL. When everything looks good, run `vercel deploy --prod`.

That's it. No framework config needed; Vercel detects the plain `index.html` automatically.

### Deploy anywhere else

This folder is just static files. It works on GitHub Pages, Netlify, Cloudflare Pages, or any cheap web host — drag and drop the files in and you're live.

---

## File layout

```
index.html         the whole page
style.css          colors, layout, responsive grid
main.js            builds Venmo links from data-* attributes
images/            product photos + favicon + og-image.png (social preview)
og-source/
  og.html          source for the social-preview image
  render.sh        regenerates images/og-image.png from og.html
```

## Regenerating the social-preview (OG) image

If you edit `og-source/og.html` (or want a fresh render), run:

```sh
./og-source/render.sh
```

It uses Chrome headless + macOS's built-in `sips` tool — no install needed. Output is written to `images/og-image.png` at 1200×630.

## How the "Pay with Venmo" button works

Each pay button is a plain `<a>` link with three data attributes:

- `data-venmo="<username>"` — the niece's Venmo handle (no `@`)
- `data-amount="<dollars>"` — the price as a number
- `data-note="<text>"` — what will show up in Venmo's description field

When the page loads, `main.js` reads those attributes and builds a URL like:

```
https://venmo.com/?txn=pay&recipients=viola-smith&amount=22&note=Sunset%20hoop%20earrings
```

On a phone with the Venmo app installed, the phone opens Venmo with the amount and note prefilled. On desktop, it opens Venmo's website.

---

Made with ♥ for Viola & Tirana.
