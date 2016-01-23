<p align="center">
  <img alt="jess" src="https://js.coach/gestalt.png" width="190" height="190">
</p>

This is the code that powers the website and scheduled scripts. It uses [Rails](http://rubyonrails.org/)
with [Webpack](https://webpack.github.io/), [Babel](https://babeljs.io/),
[PostCSS](https://github.com/postcss/postcss) and [React](https://facebook.github.io/react/).  

This stack was chosen for no particular reason :sweat_smile: Being a side-project, I wanted
to try to integrate Webpack with the Asset Pipeline and was curious about
[CSS modules](https://github.com/css-modules/css-modules). A lot can still be improved including:

- Use [Redux](http://redux.js.org/) instead of URL and contexts to handle global state
- Test React components using [Enzyme](http://airbnb.io/enzyme/) or similar
- Share variables across CSS files and still be able to use PostCSS plugins like `pxtorem`

<br>

---

### Setting up JS.coach

#### Running in development

Install the [`invoker`](http://invoker.codemancers.com) or
[`foreman`](https://github.com/ddollar/foreman) gem. Both use the same `Procfile`, but
Invoker supports .dev domains.  
After setting up the database run: `invoker start`

#### Setting up a production environment

The app is hosted on DigitalOcean and the one-click _Ruby on Rails on Ubuntu 14.04
(Postgres, Nginx, Unicorn)_ droplet was used. It includes Ruby v2.2.1, installed with RVM,
and Rails v4.2.4.

Capistrano is used for deployment. You should enable passwordless sudo for the `rails`
user by adding the following above the `#includedir` line:

```shell
rails ALL=(ALL) NOPASSWD:ALL
```

After that, set any required environment variables inside the user's `.bashrc` file. Be sure
to put them before the comment that says "If not running interactively, don't do anything":

```shell
export APP_DATABASE_NAME="..."
export APP_DATABASE_USERNAME="..."
export APP_DATABASE_PASSWORD="..."
export SECRET_KEY_BASE="..."
export GITHUB_USERNAME="..."
```

Finally, you should create a clean database or restore one from a dump file:

```shell
pg_dump -U rails -W -h localhost -f jscoach.sql jscoach_development
createdb jscoach_production -U rails -W -h localhost
psql -U rails -W -h localhost -d jscoach_production -f ~/jscoach.sql
```

If you ever end up needing more permissions (for example, to create extensions) you can:

```shell
sudo -u postgres psql
postgres=# alter role rails with superuser;
```

You should now be able to deploy the application:

```shell
bundle exec cap production setup
bundle exec cap production deploy
```

To avoid having to enter your password on every deploy, copy your public SSH key:

```shell
cat ~/.ssh/id_rsa.pub | ssh rails@123.45.56.78 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

To run the update tasks that use Node, you'll need to install Node, NPM and the dependencies:

```shell
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
NODE_ENV=production npm install
```

#### Cron jobs in production

The cron jobs should be configured automatically thanks to the integration between
Whenever and Capistrano. Check if the cron job was setup correctly with `crontab -l`.

### Working on JS.coach

#### CSS guidelines

Sometimes it's easier to write and maintain CSS when you break component isolation. For example,
if you have a body with a sidebar and a main section, it's easier to set up this layout in a single
file. You should do so, even if you don't import the styles in the `<Body>` component itself, you
can import them in the `sidebar.css` and `main.css` files. This makes it a lot easier to maintain
nested layouts that use flexbox. Here's an example:

```jsx
// body.jsx
import styles from './body.css'

export default (props) => (
  <div className={styles.container}>
    <Sidebar />
    <Main />
  </div>
)
```
```css
/* body.css */
.container {
  display: flex;
  flex-direction: row;
  height: 100vh;
}
.sidebar {
  flex: none;
}
.main {
  flex: 1;
  overflow-y: auto;
}
```
```jsx
// main.jsx
import styles from './main.css'

export default (props) => (
  <div className={styles.container}>
    {...}
  </div>
)
```
```css
/* main.css */
.container {
  composes: main from "./body.css";
  /* And here another flexbox layout can be configured */
}
```
