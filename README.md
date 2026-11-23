# Garden Walk · Apple Challenge

Walk around a small garden and collect the five numbered apples in order. Walk into an apple to collect it. Each correct pickup appears in the collection row across the top. Touching the wrong apple returns all five to the garden.

- Tap an apple or a walkable spot to automatically walk there, click with a mouse for the same behaviour, and use WASD or arrow keys on a keyboard.
- Press R to start a new round.

## Run locally

Open `project.godot` in Godot 4.5.1 and press F5. The project uses the Compatibility renderer.

## Export for the browser

Install the matching Godot 4.5.1 web export templates. Choose the Web preset and export to `index.html` in an empty folder. The preset is single-threaded. Serve the whole folder over HTTP, for example by running `python3 -m http.server 8000` in the export folder and opening `http://127.0.0.1:8000/`.

The apple challenge and its scene attachment were written and repaired by Hermes. The original Garden Walk movement script is retained.
