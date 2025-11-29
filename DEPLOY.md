# How to Deploy PedsCalc to GitHub Pages

I have set up a GitHub Actions workflow that will automatically build and deploy your app to GitHub Pages whenever you push to GitHub.

## Steps to Deploy

1. **Create a new repository on GitHub**
   - Go to https://github.com/new
   - Name it `pedscalc` (or whatever you like, but keep it consistent)
   - Do **not** initialize with README, .gitignore, or license (we already have them)

2. **Push your code**
   Run these commands in your terminal:
   ```bash
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/pedscalc.git
   git push -u origin main
   ```
   *(Replace `YOUR_USERNAME` with your actual GitHub username)*

3. **Enable GitHub Pages**
   - Go to your repository **Settings** > **Pages**
   - Under **Build and deployment**, select **Source** as `Deploy from a branch`
   - Select **Branch** as `gh-pages` (this branch will be created automatically by the action after your first push)
   - Click **Save**

4. **View your App**
   - Your app will be live at `https://YOUR_USERNAME.github.io/pedscalc/`
   - It might take a minute or two for the first deployment.

## Manual Deployment (Alternative)

If you prefer to deploy manually without GitHub Actions:

1. Build the web app:
   ```bash
   flutter build web --release --base-href "/pedscalc/"
   ```

2. Upload the contents of `build/web` to any static hosting service (GitHub Pages, Netlify, Vercel, Firebase Hosting, etc.).
